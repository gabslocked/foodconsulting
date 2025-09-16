import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class ExpandableDetailCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String description;

  const ExpandableDetailCard({
    super.key,
    this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showDetailModal(context),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            if (imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.radiusMedium),
                ),
                child: SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildImagePlaceholder(),
                    errorWidget: (context, url, error) => _buildImageFallback(),
                  ),
                ),
              ),
            
            // Content section
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spacingSmall),
                  Text(
                    _stripMarkdown(description),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spacingSmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Toque para ver detalhes',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppColors.primary,
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

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.2),
            AppColors.accent.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Carregando...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.8),
            AppColors.accent.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.image,
                size: 40,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Imagem não disponível',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.gray300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Large hero image
                          if (imageUrl != null)
                            SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => _buildImagePlaceholder(),
                                errorWidget: (context, url, error) => _buildImageFallback(),
                              ),
                            ),
                          
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    height: 1.2,
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Description
                                Markdown(
                                  data: description,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  styleSheet: MarkdownStyleSheet(
                                    p: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                      height: 1.6,
                                    ),
                                    strong: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      height: 1.6,
                                    ),
                                    em: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                      fontStyle: FontStyle.italic,
                                      height: 1.6,
                                    ),
                                    h1: const TextStyle(
                                      fontSize: 24,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      height: 1.3,
                                    ),
                                    h2: const TextStyle(
                                      fontSize: 20,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      height: 1.3,
                                    ),
                                    h3: const TextStyle(
                                      fontSize: 18,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                    ),
                                    blockquote: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                      fontStyle: FontStyle.italic,
                                      height: 1.6,
                                    ),
                                    code: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primary,
                                      backgroundColor: AppColors.primary.withOpacity(0.1),
                                      fontFamily: 'monospace',
                                    ),
                                    listBullet: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                      height: 1.6,
                                    ),
                                  ),
                                  onTapLink: (text, href, title) {
                                    if (href != null) {
                                      _launchUrl(href);
                                    }
                                  },
                                ),
                                
                                
                                
                                
                                
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _stripMarkdown(String text) {
    // Remove markdown formatting for preview
    String result = text;
    
    // Bold **text** and __text__
    result = result.replaceAllMapped(RegExp(r'\*\*(.*?)\*\*'), (match) => match.group(1) ?? '');
    result = result.replaceAllMapped(RegExp(r'__(.*?)__'), (match) => match.group(1) ?? '');
    
    // Italic *text* and _text_
    result = result.replaceAllMapped(RegExp(r'\*(.*?)\*'), (match) => match.group(1) ?? '');
    result = result.replaceAllMapped(RegExp(r'_(.*?)_'), (match) => match.group(1) ?? '');
    
    // Code `text`
    result = result.replaceAllMapped(RegExp(r'`(.*?)`'), (match) => match.group(1) ?? '');
    
    // Links [text](url)
    result = result.replaceAllMapped(RegExp(r'\[([^\]]+)\]\([^)]+\)'), (match) => match.group(1) ?? '');
    
    // Headers # ## ###
    result = result.replaceAll(RegExp(r'^#{1,6}\s+', multiLine: true), '');
    
    // Blockquotes >
    result = result.replaceAll(RegExp(r'^>\s+', multiLine: true), '');
    
    // Lists
    result = result.replaceAll(RegExp(r'^[-*+]\s+', multiLine: true), '• ');
    result = result.replaceAll(RegExp(r'^\d+\.\s+', multiLine: true), '• ');
    
    return result.trim();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}