import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mission_provider.dart';
import '../../../widgets/expandable_detail_card.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/technical_visit_model.dart';

class VisitasTab extends StatelessWidget {
  const VisitasTab({super.key});

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

    final technicalVisits = provider.technicalVisits;
    
    if (technicalVisits.isEmpty) {
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
      itemCount: technicalVisits.length,
      itemBuilder: (context, index) {
        final visit = technicalVisits[index];
        List<String> tags = [];
        
        if (visit.category != null) tags.add(visit.categoryDisplayName);
        if (visit.companyName != null) tags.add(visit.companyName!);
        if (visit.visitDate != null) tags.add(visit.visitDateDisplay);
        
        return ExpandableDetailCard(
          imageUrl: visit.imageUrl,
          title: visit.title,
          description: visit.description ?? 'Visita técnica empresarial',
          details: {
            if (visit.companyName != null) 'Empresa': visit.companyName!,
            if (visit.address != null) 'Endereço': visit.address!,
            if (visit.location != null) 'Localização': visit.location!,
            if (visit.category != null) 'Categoria': visit.categoryDisplayName,
            if (visit.contactPerson != null) 'Contato': visit.contactPerson!,
            if (visit.contactPhone != null) 'Telefone': visit.contactPhone!,
            if (visit.contactEmail != null) 'Email': visit.contactEmail!,
            if (visit.visitDate != null) 'Data da Visita': visit.visitDateDisplay,
            if (visit.visitTime != null) 'Horário': visit.visitTimeDisplay,
            if (visit.recommendedBy != null) 'Recomendado por': visit.recommendedBy!,
          },
          tags: tags,
        );
      },
    );
  }
}
