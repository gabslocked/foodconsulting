import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/attraction_model.dart';
import 'expandable_detail_card.dart';

class CityGroupedAttractionsWidget extends StatefulWidget {
  final List<AttractionModel> attractions;

  const CityGroupedAttractionsWidget({
    super.key,
    required this.attractions,
  });

  @override
  State<CityGroupedAttractionsWidget> createState() => _CityGroupedAttractionsWidgetState();
}

class _CityGroupedAttractionsWidgetState extends State<CityGroupedAttractionsWidget> {
  final Set<String> _expandedCities = <String>{};

  @override
  void initState() {
    super.initState();
    // Auto-expand first city if it exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoExpandFirstCity();
    });
  }

  void _autoExpandFirstCity() {
    if (widget.attractions.isNotEmpty && mounted) {
      final groupedAttractions = _groupAttractionsByCity(widget.attractions);
      final sortedCities = groupedAttractions.keys.toList();
      
      if (sortedCities.isNotEmpty) {
        setState(() {
          _expandedCities.add(sortedCities.first);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.attractions.isEmpty) {
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

    // Group attractions by city (already ordered by city_order from database)
    final groupedAttractions = _groupAttractionsByCity(widget.attractions);
    final sortedCities = groupedAttractions.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      itemCount: sortedCities.length,
      itemBuilder: (context, index) {
        final city = sortedCities[index];
        final cityAttractions = groupedAttractions[city]!;
        final isExpanded = _expandedCities.contains(city);

        return _buildCitySection(
          city: city,
          attractions: cityAttractions,
          isExpanded: isExpanded,
          onToggle: () {
            setState(() {
              if (isExpanded) {
                _expandedCities.remove(city);
              } else {
                _expandedCities.add(city);
              }
            });
          },
        );
      },
    );
  }

  Map<String, List<AttractionModel>> _groupAttractionsByCity(List<AttractionModel> attractions) {
    final Map<String, List<AttractionModel>> grouped = {};
    
    // Group attractions by city
    for (final attraction in attractions) {
      final city = attraction.location ?? 'Outras Cidades';
      if (!grouped.containsKey(city)) {
        grouped[city] = [];
      }
      grouped[city]!.add(attraction);
    }

    // Sort attractions within each city by display_order
    for (final cityAttractions in grouped.values) {
      cityAttractions..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    }

    // Create a list of cities with their order from database
    final cityOrderMap = <String, int>{};
    for (final attraction in attractions) {
      final city = attraction.location ?? 'Outras Cidades';
      if (!cityOrderMap.containsKey(city)) {
        cityOrderMap[city] = attraction.cityOrder ?? 999;
      }
    }

    // Sort cities by their city_order value
    final sortedCities = grouped.keys.toList()
      ..sort((a, b) => (cityOrderMap[a] ?? 999).compareTo(cityOrderMap[b] ?? 999));

    // Return ordered map based on city_order from database
    final orderedGrouped = <String, List<AttractionModel>>{};
    for (final city in sortedCities) {
      orderedGrouped[city] = grouped[city]!;
    }

    return orderedGrouped;
  }

  Widget _buildCitySection({
    required String city,
    required List<AttractionModel> attractions,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // City header
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Row(
                children: [
                  // City icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: const Icon(
                      Icons.location_city,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingMedium),
                  
                  // City info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${attractions.length} ${attractions.length == 1 ? 'atração' : 'atrações'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: AppDimensions.spacingSmall),
                  
                  // Expand/collapse icon
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          
          // Attractions list (collapsible)
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                children: attractions.map((attraction) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.spacingMedium),
                    child: ExpandableDetailCard(
                      imageUrl: attraction.imageUrl,
                      title: attraction.title,
                      description: attraction.description ?? 'Descrição não disponível',
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
