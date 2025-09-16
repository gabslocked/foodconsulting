import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../providers/auth_provider.dart';
import '../../providers/mission_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/sponsors_banner.dart';
import '../../widgets/skeleton_loader.dart';
import 'widgets/mission_card.dart';
import 'widgets/premium_mission_card.dart';
import 'widgets/upcoming_activity_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final missionProvider = context.read<MissionProvider>();
    final userProvider = context.read<UserProvider>();
    final notificationProvider = context.read<NotificationProvider>();
    
    await Future.wait([
      missionProvider.loadUserMissions(),
      notificationProvider.loadUnreadCount(),
    ]);
    
    // Load sponsors for the first mission if available
    if (missionProvider.missions.isNotEmpty) {
      final firstMissionId = missionProvider.missions.first.id;
      await missionProvider.loadMissionDetails(firstMissionId);
    }
  }

  Future<void> _onRefresh() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Consumer2<AuthProvider, MissionProvider>(
          builder: (context, authProvider, missionProvider, child) {
            final user = authProvider.user;
            
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome section
                  _buildWelcomeSection(user?.fullName ?? 'Usuário'),
                  const SizedBox(height: AppDimensions.spacing24),
                  
                  // Missions section
                  missionProvider.isLoading 
                    ? _buildMissionsSkeletonSection()
                    : _buildMissionsSection(missionProvider),
                  const SizedBox(height: AppDimensions.spacing24),
                  
                  // Sponsors section
                  missionProvider.isLoading 
                    ? _buildSponsorsSkeletonSection()
                    : _buildSponsorsSection(missionProvider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(AppStrings.home),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        Consumer<NotificationProvider>(
          builder: (context, notificationProvider, child) {
            return Stack(
              children: [
                Semantics(
                  label: notificationProvider.unreadCount > 0 
                    ? 'Notificações. ${notificationProvider.unreadCount} não lidas'
                    : 'Notificações. Nenhuma notificação não lida',
                  button: true,
                  child: IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      context.push('/home/notifications');
                    },
                    tooltip: 'Ver notificações',
                  ),
                ),
                if (notificationProvider.unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${notificationProvider.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(String userName) {
    return Semantics(
      label: 'Seção de boas-vindas. Bem-vindo, $userName. Acompanhe suas missões e atividades',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                '${AppStrings.welcome}, $userName!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              'Acompanhe suas missões e atividades',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionsSection(MissionProvider missionProvider) {
    return Semantics(
      container: true,
      label: 'Seção das minhas missões',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              AppStrings.myMissions,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        const SizedBox(height: AppDimensions.spacing16),
        
        if (missionProvider.isLoading)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => 
                const SizedBox(height: AppDimensions.spacing12),
            itemBuilder: (context, index) => const MissionCardSkeleton(),
          )
        else if (missionProvider.error != null)
          ErrorDisplayWidget(
            message: missionProvider.error!,
            onRetry: () => missionProvider.loadUserMissions(),
          )
        else if (missionProvider.missions.isEmpty)
          const EmptyStateWidget(
            title: 'Nenhuma missão',
            message: 'Você ainda não possui missões cadastradas.',
            icon: Icons.business_center_outlined,
          )
        else
          Semantics(
            label: '${missionProvider.missions.length} missões encontradas',
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: missionProvider.missions.length,
              separatorBuilder: (context, index) => 
                  const SizedBox(height: AppDimensions.spacing12),
              itemBuilder: (context, index) {
                final mission = missionProvider.missions[index];
                return PremiumMissionCard(
                  mission: mission,
                  onTap: () => context.push('/mission/${mission.id}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionsSkeletonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suas Missões',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
        const MissionCardSkeleton(),
        const MissionCardSkeleton(),
      ],
    );
  }

  Widget _buildSponsorsSkeletonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Apoiadores',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMedium),
        const SponsorImageSkeleton(),
        const SponsorImageSkeleton(),
        const SponsorImageSkeleton(),
      ],
    );
  }

  Widget _buildSponsorsSection(MissionProvider missionProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<MissionProvider>(
          builder: (context, provider, child) {
            return SponsorsBanner(sponsors: provider.sponsors);
          },
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                accountName: Text(user?.fullName ?? 'Usuário'),
                accountEmail: Text(user?.email ?? ''),
                currentAccountPicture: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            user.avatarUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/logo-food.png',
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/logo-food.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person_outlined),
                title: const Text(AppStrings.profile),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock_outlined),
                title: const Text('Alterar Senha'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/change-password');
                },
              ),
              Consumer<MissionProvider>(
                builder: (context, missionProvider, child) {
                  return ListTile(
                    leading: const Icon(Icons.event_outlined),
                    title: const Text(AppStrings.events),
                    onTap: () {
                      Navigator.of(context).pop();
                      // Navigate to active mission's programming tab
                      final activeMissions = missionProvider.missions.where((m) => 
                        m.status.toLowerCase() == 'active' || m.status.toLowerCase() == 'ativo'
                      ).toList();
                      
                      if (activeMissions.isNotEmpty) {
                        final activeMission = activeMissions.first;
                        context.push('/mission/${activeMission.id}?tab=2'); // Tab 2 is programming
                      }
                    },
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text(
                  AppStrings.logout,
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutDialog(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sair'),
          content: const Text('Tem certeza que deseja sair do aplicativo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthProvider>().signOut();
              },
              child: const Text(
                AppStrings.logout,
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
