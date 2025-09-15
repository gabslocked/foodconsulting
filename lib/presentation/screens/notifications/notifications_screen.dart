import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/date_formatter.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/empty_state_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  Future<void> _onRefresh() async {
    await context.read<NotificationProvider>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.notifications,
        showNotificationBadge: false,
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
              if (notificationProvider.unreadCount > 0) {
                return TextButton(
                  onPressed: () => notificationProvider.markAllAsRead(),
                  child: const Text(
                    'Marcar todas como lidas',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          if (notificationProvider.isLoading) {
            return const LoadingWidget(message: 'Carregando notificações...');
          }

          if (notificationProvider.error != null) {
            return ErrorDisplayWidget(
              message: notificationProvider.error!,
              onRetry: () => notificationProvider.loadNotifications(),
            );
          }

          if (notificationProvider.notifications.isEmpty) {
            return const EmptyStateWidget(
              title: 'Nenhuma notificação',
              message: 'Você não possui notificações no momento.',
              icon: Icons.notifications_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              itemCount: notificationProvider.notifications.length,
              separatorBuilder: (context, index) => 
                  const SizedBox(height: AppDimensions.spacing8),
              itemBuilder: (context, index) {
                final notification = notificationProvider.notifications[index];
                return _NotificationCard(
                  notification: notification,
                  onTap: () => _handleNotificationTap(notification, notificationProvider),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _handleNotificationTap(
    notification,
    NotificationProvider notificationProvider,
  ) {
    final notificationId = notification.id;
    final isRead = notification.read;

    if (!isRead) {
      notificationProvider.markAsRead(notificationId);
    }

    // Handle navigation based on notification type
    if (notification.relatedId != null) {
      // Navigate to related content based on type
      switch (notification.type) {
        case 'mission':
          // context.push('/mission/${notification.relatedId}');
          break;
        case 'activity':
          // Navigate to activity details
          break;
        default:
          break;
      }
    }
  }
}

class _NotificationCard extends StatelessWidget {
  final notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = notification.read;
    final title = notification.title ?? 'Notificação';
    final body = notification.message ?? '';
    final createdAt = notification.createdAt;
    final type = notification.type ?? 'info';

    return Card(
      elevation: isRead ? 1 : 3,
      color: isRead ? AppColors.surface : AppColors.primary.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        side: isRead 
            ? BorderSide.none 
            : BorderSide(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getTypeColor(type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Icon(
                  _getTypeIcon(type),
                  color: _getTypeColor(type),
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                        color: isRead ? AppColors.textSecondary : AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    if (body.isNotEmpty) ...[
                      const SizedBox(height: AppDimensions.spacing4),
                      Text(
                        body,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    const SizedBox(height: AppDimensions.spacing8),
                    
                    // Time
                    Text(
                      DateFormatter.getRelativeDate(createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Unread indicator
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'flight_update':
        return Icons.flight;
      case 'hotel_update':
        return Icons.hotel;
      case 'itinerary_update':
        return Icons.schedule;
      case 'mission_update':
        return Icons.business_center;
      case 'warning':
        return Icons.warning;
      case 'success':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'flight_update':
        return AppColors.info;
      case 'hotel_update':
        return AppColors.success;
      case 'itinerary_update':
        return AppColors.warning;
      case 'mission_update':
        return AppColors.primary;
      case 'warning':
        return AppColors.error;
      case 'success':
        return AppColors.success;
      default:
        return AppColors.gray500;
    }
  }
}
