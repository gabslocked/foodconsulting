import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../data/models/mission_model.dart';

class MissionCard extends StatefulWidget {
  final MissionSummary mission;
  final VoidCallback onTap;

  const MissionCard({
    super.key,
    required this.mission,
    required this.onTap,
  });

  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _elevationAnimation = Tween<double>(
      begin: AppDimensions.elevationLow,
      end: AppDimensions.elevationHigh,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'mission-${widget.mission.id}',
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
      elevation: _elevationAnimation.value,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _animationController.forward().then((_) {
              _animationController.reverse();
              widget.onTap();
            });
          },
          onTapDown: (_) => _animationController.forward(),
          onTapCancel: () => _animationController.reverse(),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Semantics(
          label: 'Missão ${widget.mission.name}. Toque para ver detalhes',
          button: true,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusMedium),
                topRight: Radius.circular(AppDimensions.radiusMedium),
              ),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: widget.mission.coverImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: widget.mission.coverImageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.gray200,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.gray200,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: AppColors.gray400,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.gray200,
                        child: const Icon(
                          Icons.business_center,
                          size: 48,
                          color: AppColors.gray400,
                        ),
                      ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mission name
                  Text(
                    widget.mission.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  
                  const SizedBox(height: AppDimensions.spacing4),
                  
                  // Status indicator only
                  Row(
                    children: [
                      const Spacer(),
                      
                      // Status indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing8,
                          vertical: AppDimensions.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(widget.mission.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                        ),
                        child: Text(
                          _getStatusText(widget.mission.status),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getStatusColor(widget.mission.status),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          ),
        ),
      ),
        ),
      ),
        );
      },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'ativo':
        return AppColors.success;
      case 'upcoming':
      case 'próximo':
        return AppColors.info;
      case 'completed':
      case 'concluído':
        return AppColors.gray500;
      case 'cancelled':
      case 'cancelado':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Ativo';
      case 'upcoming':
        return 'Próximo';
      case 'completed':
        return 'Concluído';
      case 'cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _StatusBadge({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing8,
        vertical: AppDimensions.spacing4,
      ),
      decoration: BoxDecoration(
        color: isActive ? AppColors.success.withOpacity(0.1) : AppColors.gray200,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isActive ? AppColors.success : AppColors.gray500,
          ),
          const SizedBox(width: AppDimensions.spacing4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isActive ? AppColors.success : AppColors.gray500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
