import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../providers/mission_provider.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/expandable_detail_card.dart';

class AnugaTab extends StatelessWidget {
  const AnugaTab({super.key});

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
                  'Nenhuma informação da ANUGA disponível',
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
            final anuga = anugaItems[index];
            List<String> tags = [];
            if (anuga.eventDate != null) tags.add(_formatDate(anuga.eventDate!));
            if (anuga.location != null) tags.add(anuga.location!);
            
            return ExpandableDetailCard(
              imageUrl: anuga.imageUrl,
              title: anuga.title,
              description: anuga.description ?? 'Feira internacional de alimentos',
              linkUrl: anuga.linkUrl,
              details: {
                if (anuga.eventDate != null) 'Data do Evento': _formatFullDate(anuga.eventDate!),
                if (anuga.location != null) 'Local': anuga.location!,
                if (anuga.boothNumber != null) 'Número do Stand': anuga.boothNumber!,
                if (anuga.contactInfo != null) 'Contato': anuga.contactInfo!,
                'Ordem de Exibição': anuga.displayOrder.toString(),
              },
              tags: tags,
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
