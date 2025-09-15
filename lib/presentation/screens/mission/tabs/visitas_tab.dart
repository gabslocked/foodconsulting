import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../providers/mission_provider.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/expandable_detail_card.dart';

class VisitasTab extends StatelessWidget {
  const VisitasTab({super.key});

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

        final visits = provider.activities
            .where((activity) => activity.isVisit)
            .toList();
        
        if (visits.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.business, size: 64, color: AppColors.textSecondary),
                SizedBox(height: 16),
                Text(
                  'Nenhuma visita técnica disponível',
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
          itemCount: visits.length,
          itemBuilder: (context, index) {
            final visit = visits[index];
            List<String> tags = [];
            if (visit.address != null) tags.add(visit.address!);
            
            // Use available fields from ActivityModel
            final company = visit.recommendedBy;
            final focus = visit.category;
            
            if (company != null) tags.add(company);
            if (focus != null) tags.add(focus);
            
            return ExpandableDetailCard(
              imageUrl: visit.imageUrl,
              title: visit.name,
              description: visit.description ?? 'Visita técnica',
              linkUrl: null,
              details: {
                if (visit.address != null) 'Local': visit.address!,
                if (visit.address != null) 'Endereço': visit.address!,
                if (company != null) 'Empresa': company,
                if (focus != null) 'Foco': focus,
                if (visit.phone != null) 'Telefone': visit.phone!,
                if (visit.website != null) 'Website': visit.website!,
              },
              tags: tags,
            );
          },
        );
      },
    );
  }
}
