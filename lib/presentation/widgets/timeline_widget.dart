import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/itinerary_model.dart';

class TimelineWidget extends StatefulWidget {
  final List<ItineraryModel> itineraries;

  const TimelineWidget({
    super.key,
    required this.itineraries,
  });

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  final Set<String> _expandedDays = <String>{};

  @override
  void initState() {
    super.initState();
    // Auto-expand today's section if it exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoExpandTodaySection();
    });
  }

  void _autoExpandTodaySection() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayKey = _formatDateKey(today);
    
    // Check if there are events for today
    final hasEventsToday = widget.itineraries.any((itinerary) {
      final eventDate = DateTime(itinerary.date.year, itinerary.date.month, itinerary.date.day);
      return eventDate.isAtSameMomentAs(today);
    });
    
    if (hasEventsToday && mounted) {
      setState(() {
        _expandedDays.add(todayKey);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itineraries.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, size: 64, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text(
              'Nenhuma atividade programada',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // Group itineraries by date
    final groupedItineraries = _groupItinerariesByDate(widget.itineraries);
    final sortedDates = groupedItineraries.keys.toList()..sort();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final dayItineraries = groupedItineraries[date]!;
        final dayKey = _formatDateKey(date);
        final isExpanded = _expandedDays.contains(dayKey);
        final isDayPast = date.isBefore(today);
        final isDayToday = date.isAtSameMomentAs(today);

        return _buildDaySection(
          date: date,
          itineraries: dayItineraries,
          isExpanded: isExpanded,
          isDayPast: isDayPast,
          isDayToday: isDayToday,
          onToggle: () {
            setState(() {
              if (isExpanded) {
                _expandedDays.remove(dayKey);
              } else {
                _expandedDays.add(dayKey);
              }
            });
          },
        );
      },
    );
  }

  Map<DateTime, List<ItineraryModel>> _groupItinerariesByDate(List<ItineraryModel> itineraries) {
    final Map<DateTime, List<ItineraryModel>> grouped = {};
    
    for (final itinerary in itineraries) {
      final dateKey = DateTime(itinerary.date.year, itinerary.date.month, itinerary.date.day);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(itinerary);
    }

    // Sort itineraries within each day by time
    for (final dayItineraries in grouped.values) {
      dayItineraries.sort((a, b) {
        if (a.startTime != null && b.startTime != null) {
          return a.startTime!.compareTo(b.startTime!);
        }
        return 0;
      });
    }

    return grouped;
  }

  Widget _buildDaySection({
    required DateTime date,
    required List<ItineraryModel> itineraries,
    required bool isExpanded,
    required bool isDayPast,
    required bool isDayToday,
    required VoidCallback onToggle,
  }) {
    final now = DateTime.now();
    final completedEvents = itineraries.where((itinerary) => _isEventPast(itinerary, now)).length;
    final totalEvents = itineraries.length;

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
          // Day header
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
                  // Day indicator
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${date.day}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getMonthAbbr(date.month),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingMedium),
                  
                  // Day info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatFullDate(date),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$totalEvents ${totalEvents == 1 ? 'evento' : 'eventos'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Progress indicator for past days
                  if (isDayPast && completedEvents > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$completedEvents/$totalEvents',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
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
          
          // Events list (collapsible)
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                children: itineraries.asMap().entries.map((entry) {
                  final index = entry.key;
                  final itinerary = entry.value;
                  final isPast = _isEventPast(itinerary, now);
                  final isLast = index == itineraries.length - 1;

                  return _buildTimelineItem(
                    itinerary: itinerary,
                    isPast: isPast,
                    isToday: isDayToday,
                    isLast: isLast,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required ItineraryModel itinerary,
    required bool isPast,
    required bool isToday,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPast
                    ? Colors.green
                    : AppColors.primary,
                border: Border.all(
                  color: isPast
                      ? Colors.green
                      : AppColors.primary,
                  width: 2,
                ),
              ),
              child: isPast
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : const Icon(Icons.schedule, size: 12, color: Colors.white),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: AppColors.primary.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: AppDimensions.spacingMedium),
        
        // Content
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: AppDimensions.spacingMedium),
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: isPast ? Colors.grey[50] : Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        itinerary.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isPast ? AppColors.textSecondary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (isPast)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingSmall),
                
                // Time
                if (itinerary.startTime != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: isPast ? AppColors.textSecondary : AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTimeString(itinerary.startTime!),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isPast ? AppColors.textSecondary : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingSmall),
                ],
                
                if (itinerary.description != null) ...[
                  Text(
                    itinerary.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: isPast ? AppColors.textSecondary : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingSmall),
                ],
                
                if (itinerary.address != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: isPast ? AppColors.textSecondary : AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          itinerary.address!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isPast ? AppColors.textSecondary : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _isEventPast(ItineraryModel itinerary, DateTime now) {
    final eventDate = DateTime(itinerary.date.year, itinerary.date.month, itinerary.date.day);
    final today = DateTime(now.year, now.month, now.day);
    
    // If event date is after today, it's definitely future
    if (eventDate.isAfter(today)) {
      return false;
    }
    
    // If event date is before today, it's definitely past
    if (eventDate.isBefore(today)) {
      return true;
    }
    
    // If it's today, check the time
    if (eventDate.isAtSameMomentAs(today) && itinerary.startTime != null) {
      try {
        final timeParts = itinerary.startTime!.split(':');
        if (timeParts.length >= 2) {
          final eventHour = int.parse(timeParts[0]);
          final eventMinute = int.parse(timeParts[1]);
          final eventDateTime = DateTime(now.year, now.month, now.day, eventHour, eventMinute);
          return now.isAfter(eventDateTime);
        }
      } catch (e) {
        // If parsing fails, consider it not past
        return false;
      }
    }
    
    return false;
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatFullDate(DateTime date) {
    final weekdays = [
      'Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Quinta-feira', 
      'Sexta-feira', 'Sábado', 'Domingo'
    ];
    final months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    
    return '$weekday, ${date.day} de $month';
  }

  String _getMonthAbbr(int month) {
    final months = [
      'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN',
      'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ'
    ];
    return months[month - 1];
  }

  String _formatTimeString(String timeString) {
    // Remove seconds from time string (e.g., "14:30:00" -> "14:30")
    if (timeString.contains(':') && timeString.split(':').length >= 2) {
      final parts = timeString.split(':');
      return '${parts[0]}:${parts[1]}';
    }
    return timeString;
  }

}
