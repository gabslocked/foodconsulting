import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../providers/mission_provider.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import 'tabs/mission_tab.dart';
import 'tabs/destinations_tab.dart';
import 'tabs/schedule_tab.dart';
import 'tabs/feira_tab.dart';
import 'tabs/visitas_tab.dart';
import 'tabs/tours_tab.dart';
import 'tabs/hotel_tab.dart';
import 'tabs/transportes_tab.dart';
import 'tabs/atracoes_tab.dart';
import 'tabs/tips_tab.dart';

class MissionDetailScreen extends StatefulWidget {
  final String missionId;

  const MissionDetailScreen({
    super.key,
    required this.missionId,
  });

  @override
  State<MissionDetailScreen> createState() => _MissionDetailScreenState();
}

class _MissionDetailScreenState extends State<MissionDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);

    // Load mission details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MissionProvider>().loadMissionDetails(widget.missionId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Consumer<MissionProvider>(
          builder: (context, provider, child) {
            return Text(
              provider.currentMission?.name ?? 'Detalhes da Missão',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Missão'),
            Tab(text: 'Destinos'),
            Tab(text: 'Programação'),
            Tab(text: 'Feira'),
            Tab(text: 'Visitas'),
            Tab(text: 'Tours'),
            Tab(text: 'Hotéis'),
            Tab(text: 'Transportes'),
            Tab(text: 'Atrações'),
            Tab(text: 'Dicas'),
          ],
        ),
      ),
      body: Consumer<MissionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingDetails) {
            return const LoadingWidget();
          }

          if (provider.error != null) {
            return ErrorDisplayWidget(
              message: provider.error!,
              onRetry: () => provider.loadMissionDetails(widget.missionId),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: const [
              MissionTab(),
              DestinationsTab(),
              ScheduleTab(),
              FeiraTab(),
              VisitasTab(),
              ToursTab(),
              HotelTab(),
              TransportesTab(),
              AtracoesTab(),
              TipsTab(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacing12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
