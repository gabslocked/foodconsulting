import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/sponsor_model.dart';

class SponsorsBanner extends StatelessWidget {
  final List<SponsorModel> sponsors;

  const SponsorsBanner({
    super.key,
    required this.sponsors,
  });

  @override
  Widget build(BuildContext context) {
    if (sponsors.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort sponsors by display_order
    final sortedSponsors = List<SponsorModel>.from(sponsors)
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Apoiadores',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          ...sortedSponsors.map((sponsor) => _buildSponsorImage(sponsor)).toList(),
        ],
      ),
    );
  }

  Widget _buildSponsorImage(SponsorModel sponsor) {
    return GestureDetector(
      onTap: sponsor.websiteUrl != null ? () => _launchUrl(sponsor.websiteUrl!) : null,
      child: Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.only(bottom: AppDimensions.spacing8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          border: Border.all(color: AppColors.gray200.withOpacity(0.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            child: Image.network(
              sponsor.logoUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  child: const Icon(
                    Icons.business,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
