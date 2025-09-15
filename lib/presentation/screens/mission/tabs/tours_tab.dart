import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mission_provider.dart';
import '../../../widgets/expandable_detail_card.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/tour_model.dart';

class ToursTab extends StatelessWidget {
  const ToursTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MissionProvider>();
    
    if (provider.isLoadingDetails) {
      return const LoadingWidget();
    }

    if (provider.error != null) {
      return ErrorDisplayWidget(
        message: provider.error!,
        onRetry: () => provider.refreshMissionData(),
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
        
        if (tour.category != null) tags.add(tour.categoryDisplayName);
        if (tour.duration != null) tags.add(tour.duration!);
        
        return ExpandableDetailCard(
          imageUrl: tour.imageUrl,
          title: tour.title,
          description: tour.description ?? 'Tour cultural e experiencial',
          details: {
            if (tour.address != null) 'Endereço': tour.address!,
            if (tour.location != null) 'Localização': tour.location!,
            if (tour.category != null) 'Categoria': tour.categoryDisplayName,
            if (tour.duration != null) 'Duração': tour.durationDisplay,
            if (tour.recommendedBy != null) 'Recomendado por': tour.recommendedBy!,
          },
          tags: tags,
        );
      },
    );
  }
}
