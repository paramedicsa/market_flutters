import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/app_theme.dart';

class MediaTab extends StatefulWidget {
  final List<XFile> selectedImages;
  final Function() onPickImages;
  final Function(XFile) onRemoveImage;
  final Function() onClearImages;

  const MediaTab({
    super.key,
    required this.selectedImages,
    required this.onPickImages,
    required this.onRemoveImage,
    required this.onClearImages,
  });

  @override
  State<MediaTab> createState() => _MediaTabState();
}

class _MediaTabState extends State<MediaTab> {
  final TextEditingController affiliateUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Media & Images',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Selected Images Display
          if (widget.selectedImages.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected Images (${widget.selectedImages.length}/8)',
                        style: const TextStyle(
                          color: AppTheme.cyan,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onClearImages,
                        icon: const Icon(Icons.clear_all, color: Colors.red),
                        tooltip: 'Clear all images',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.selectedImages.map((image) => Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(image.path),
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                              // Add performance optimizations
                              cacheWidth: 160, // Cache at 2x display size for crisp display
                              cacheHeight: 160,
                              filterQuality: FilterQuality.low, // Faster rendering
                              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded) return child;
                                return AnimatedOpacity(
                                  opacity: frame == null ? 0 : 1,
                                  duration: const Duration(milliseconds: 200),
                                  child: child,
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.white54,
                                    size: 24,
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: GestureDetector(
                              onTap: () => widget.onRemoveImage(image),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Product Images',
                  style: TextStyle(
                    color: AppTheme.cyan,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: widget.selectedImages.length >= 8 ? null : widget.onPickImages,
                        icon: const Icon(Icons.upload_file),
                        label: Text('Upload Images (${widget.selectedImages.length}/8)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.cyan,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: widget.selectedImages.length >= 8 ? null : _takePhoto,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Take Photo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Upload up to 8 high-quality images of your product.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Affiliate Product Link Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Affiliate Product Link (Back Office Only)',
                  style: TextStyle(
                    color: AppTheme.cyan,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: affiliateUrlController,
                  decoration: InputDecoration(
                    hintText: 'Paste affiliate product URL here...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.cyan),
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                if (affiliateUrlController.text.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => launchUrl(Uri.parse(affiliateUrlController.text)),
                    child: Text(
                      affiliateUrlController.text,
                      style: const TextStyle(
                        color: Colors.amber,
                        decoration: TextDecoration.underline,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _takePhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null && widget.selectedImages.length < 8) {
      setState(() {
        widget.selectedImages.add(photo);
      });
    }
  }
}
