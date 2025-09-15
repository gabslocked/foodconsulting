import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/tip_model.dart';
import '../../../providers/mission_provider.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/expandable_detail_card.dart';

class TipsTab extends StatelessWidget {
  const TipsTab({super.key});

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

        final tips = provider.tips;
        
        if (tips.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lightbulb_outline, size: 64, color: AppColors.textSecondary),
                SizedBox(height: 16),
                Text(
                  'Nenhuma dica encontrada',
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
          itemCount: tips.length,
          itemBuilder: (context, index) {
            final tip = tips[index];
            List<String> tags = [];
            if (tip.category != null) tags.add(tip.category!);
            if (tip.priority == 'alta') tags.add('ALTA PRIORIDADE');
            
            return ExpandableDetailCard(
              title: tip.title,
              description: tip.content ?? 'Sem descrição disponível',
              imageUrl: tip.imageUrl,
              details: {
                if (tip.category != null) 'Categoria': tip.category!,
                if (tip.priority != null) 'Prioridade': tip.priority == 'alta' ? 'Alta' : tip.priority == 'baixa' ? 'Baixa' : 'Normal',
                if (tip.authorName != null) 'Autor': tip.authorName!,
              },
              tags: tags,
            );
          },
        );
      },
    );
  }

}
