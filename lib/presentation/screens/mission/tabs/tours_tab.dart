import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../providers/mission_provider.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/expandable_detail_card.dart';

class ToursTab extends StatelessWidget {
  const ToursTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MissionProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingDetails) {
          return const LoadingWidget();
        }

        if (provider.error != null) {
          return ErrorDisplayWidget(
            message: provider.error!,
            onRetry: () => provider.loadUserMissions(),
          );
        }

        final tours = provider.tours;
        
        if (tours.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.tour, size: 64, color: AppColors.textSecondary),
                SizedBox(height: 16),
                Text(
                  'Nenhum tour disponível',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          itemCount: tours.length,
          itemBuilder: (context, index) {
            final tour = tours[index];
            List<String> tags = [];
            if (tour.duration != null) tags.add(tour.duration!);
            if (tour.location != null) tags.add(tour.location!);
            
            return ExpandableDetailCard(
              imageUrl: tour.imageUrl,
              title: tour.title,
              description: tour.description ?? 'Tour cultural',
            );
          },
        );
      },
    );
  }
}
