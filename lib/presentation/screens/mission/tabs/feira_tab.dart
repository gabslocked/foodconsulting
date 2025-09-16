import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../providers/mission_provider.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/expandable_detail_card.dart';

class FeiraTab extends StatelessWidget {
  const FeiraTab({super.key});

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

        final anugaItems = provider.anugaItems;
        
        if (anugaItems.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event, size: 64, color: AppColors.textSecondary),
                SizedBox(height: 16),
                Text(
                  'Nenhuma informação da feira disponível',
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
          itemCount: anugaItems.length,
          itemBuilder: (context, index) {
            final feira = anugaItems[index];
            List<String> tags = [];
            if (feira.eventDate != null) tags.add(_formatDate(feira.eventDate!));
            if (feira.location != null) tags.add(feira.location!);
            
            return ExpandableDetailCard(
              imageUrl: feira.imageUrl,
              title: feira.title,
              description: feira.description ?? 'Feira internacional de alimentos',
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  String _formatFullDate(DateTime date) {
    final months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
}
