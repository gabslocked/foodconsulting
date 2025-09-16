import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../providers/mission_provider.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/city_grouped_attractions_widget.dart';

class AtracoesTab extends StatelessWidget {
  const AtracoesTab({super.key});

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

        final attractions = provider.attractions;
        
        return CityGroupedAttractionsWidget(attractions: attractions);
      },
    );
  }
}
