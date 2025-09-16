import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../providers/mission_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';

class MissionTab extends StatelessWidget {
  const MissionTab({super.key});

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
            onRetry: () => provider.loadMissionDetails(provider.currentMission?.id ?? ''),
          );
        }

        final mission = provider.currentMission;
        if (mission == null) {
          return const Center(
            child: Text('Missão não encontrada'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mission Info Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacing16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mission.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing8),
                      MarkdownBody(
                        data: mission.description ?? '',
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                          strong: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                          em: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                          h1: const TextStyle(
                            fontSize: 18,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                          h2: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                          h3: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                          blockquote: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                          code: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            fontFamily: 'monospace',
                          ),
                          listBullet: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing16),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppDimensions.spacing8),
                          Text(
                            mission.city.isNotEmpty 
                              ? '${mission.city}, ${mission.country}'
                              : mission.country,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spacing8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppDimensions.spacing8),
                          Text(
                            '${DateFormatter.formatDate(mission.startDate)} - ${DateFormatter.formatDate(mission.endDate)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppDimensions.spacing24),
              
              // Members Section
              Row(
                children: [
                  Icon(
                    Icons.group,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: AppDimensions.spacing8),
                  const Text(
                    'Participantes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.spacing16),
              
              // Participants List
              FutureBuilder<List<Map<String, dynamic>>>(
                future: provider.getMissionParticipants(mission.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Erro ao carregar participantes: ${snapshot.error}'),
                    );
                  }
                  
                  final participants = snapshot.data ?? [];
                  
                  if (participants.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum participante encontrado',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: participants.length,
                    itemBuilder: (context, index) {
                      final participant = participants[index];
                      return _buildParticipantCard(participant);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildParticipantCard(Map<String, dynamic> participant) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: participant['avatar_url'] != null && participant['avatar_url'].isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: participant['avatar_url'],
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        size: 30,
                        color: AppColors.primary,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 30,
                      color: AppColors.primary,
                    ),
            ),
            
            const SizedBox(width: AppDimensions.spacing16),
            
            // Participant Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    participant['full_name'] ?? 'Nome não informado',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing4),
                  if (participant['company'] != null && participant['company'].isNotEmpty)
                    Text(
                      participant['company'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  const SizedBox(height: AppDimensions.spacing4),
                  if (participant['email'] != null && participant['email'].isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppDimensions.spacing4),
                        Expanded(
                          child: Text(
                            participant['email'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: AppDimensions.spacing4),
                  if (participant['phone'] != null && participant['phone'].isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppDimensions.spacing4),
                        Text(
                          participant['phone'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
