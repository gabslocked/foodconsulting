import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mission_provider.dart';
import '../../../widgets/expandable_detail_card.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/attraction_model.dart';

class AtracoesTab extends StatelessWidget {
  const AtracoesTab({super.key});

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

        final attractions = provider.attractions;
        
        if (attractions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.attractions, size: 64, color: AppColors.textSecondary),
                SizedBox(height: 16),
                Text(
                  'Nenhuma atração encontrada',
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
          itemCount: attractions.length,
          itemBuilder: (context, index) {
            final attraction = attractions[index];
            return ExpandableDetailCard(
              imageUrl: attraction.imageUrl,
              title: attraction.title,
              description: attraction.description ?? 
                (attraction.address != null ? 'Local: ${attraction.address}' : 'Atração turística'),
              details: {
                if (attraction.address != null) 'Endereço': attraction.address!,
                if (attraction.category != null) 'Categoria': attraction.categoryDisplayName,
                if (attraction.location != null) 'Localização': attraction.location!,
                if (attraction.recommendedBy != null) 'Recomendado por': attraction.recommendedBy!,
              },
              tags: [
                if (attraction.category != null) attraction.categoryDisplayName,
              ],
            );
          },
        );
      },
    );
  }
}
