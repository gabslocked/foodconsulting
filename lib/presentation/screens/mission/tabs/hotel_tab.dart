import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/hotel_model.dart';
import '../../../providers/mission_provider.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/expandable_detail_card.dart';

class HotelTab extends StatelessWidget {
  const HotelTab({super.key});

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

        final hotels = provider.hotels;
        
        if (hotels.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hotel, size: 64, color: AppColors.textSecondary),
                SizedBox(height: 16),
                Text(
                  'Nenhum hotel encontrado',
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
          itemCount: hotels.length,
          itemBuilder: (context, index) {
            final hotel = hotels[index];
            List<String> tags = [];
            if (hotel.category != null) tags.add(hotel.category!.toUpperCase());
            if (hotel.priority == 'alta') tags.add('ALTA PRIORIDADE');
            if (hotel.starRating != null) tags.add(hotel.starRatingDisplay);
            
            return ExpandableDetailCard(
              title: hotel.title,
              description: hotel.content ?? 'Sem descrição disponível',
              imageUrl: hotel.imageUrl,
              linkUrl: hotel.websiteUrl,
              details: {
                if (hotel.address != null) 'Endereço': hotel.address!,
                if (hotel.phone != null) 'Telefone': hotel.phone!,
                if (hotel.category != null) 'Cidade': hotel.category!.toUpperCase(),
                if (hotel.starRating != null) 'Classificação': hotel.starRatingDisplay,
                if (hotel.priority != null) 'Prioridade': hotel.priority == 'alta' ? 'Alta' : hotel.priority == 'baixa' ? 'Baixa' : 'Normal',
                if (hotel.amenities.isNotEmpty) 'Comodidades': hotel.amenities.join(', '),
                if (hotel.nearbyAttractions.isNotEmpty) 'Atrações Próximas': hotel.nearbyAttractions.join(', '),
              },
              tags: tags,
            );
          },
        );
      },
    );
  }
}
