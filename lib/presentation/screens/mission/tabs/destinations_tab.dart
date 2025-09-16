import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/destination_model.dart';
import '../../../providers/mission_provider.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/expandable_detail_card.dart';

class DestinationsTab extends StatelessWidget {
  const DestinationsTab({super.key});

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
            onRetry: () => provider.refreshMissionData(),
          );
        }

        final destinations = provider.destinations;
        
        if (destinations.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_city, size: 64, color: AppColors.textSecondary),
                SizedBox(height: 16),
                Text(
                  'Nenhum destino encontrado',
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
          itemCount: destinations.length,
          itemBuilder: (context, index) {
            final destination = destinations[index];
            return ExpandableDetailCard(
              imageUrl: destination.imageUrl,
              title: destination.name,
              description: destination.description ?? 
                  'Destino da missão ${destination.name}',
            );
          },
        );
      },
    );
  }
}
