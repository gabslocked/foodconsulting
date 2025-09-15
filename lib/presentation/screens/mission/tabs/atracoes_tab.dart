import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/activity_model.dart';
import '../../../providers/mission_provider.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/expandable_detail_card.dart';

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

        final attractions = provider.activities
            .where((activity) => activity.isAttraction)
            .toList();
        
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
            final activity = attractions[index];
            return ExpandableDetailCard(
              imageUrl: activity.imageUrl,
              title: activity.name,
              description: activity.description ?? 
                (activity.address != null ? 'Local: ${activity.address}' : 'Atração turística e gastronômica'),
              linkUrl: activity.website,
              details: {
                if (activity.address != null) 'Endereço': activity.address!,
                if (activity.priceRange != null) 'Faixa de Preço': activity.priceRange!,
                if (activity.category != null) 'Categoria': activity.category!,
                if (activity.rating != null) 'Avaliação': '${activity.rating}/5 ⭐',
                if (activity.phone != null) 'Telefone': activity.phone!,
                if (activity.recommendedBy != null) 'Recomendado por': activity.recommendedBy!,
              },
              tags: [
                if (activity.category != null) activity.category!,
                if (activity.priceRange != null) activity.priceRange!,
              ],
            );
          },
        );
      },
    );
  }
}
