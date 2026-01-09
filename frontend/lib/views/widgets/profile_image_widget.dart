import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';

/// A reusable widget that loads profile images from network URLs (Supabase bucket)
/// Shows a person icon if no image is available
class NetworkProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final bool isDoctor;
  final double radius;

  const NetworkProfileAvatar({
    super.key,
    this.imageUrl,
    this.isDoctor = true,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    // If URL exists and is valid, load from network
    if (imageUrl != null &&
        imageUrl!.isNotEmpty &&
        (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://'))) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            width: radius * 2,
            height: radius * 2,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                  color: darkGreenColor,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              // Show person icon on error
              return Container(
                color: Colors.grey[200],
                child: Icon(
                  Icons.person,
                  size: radius * 1.2,
                  color: Colors.grey[400],
                ),
              );
            },
          ),
        ),
      );
    }

    // No image URL - show person icon placeholder
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      child: Icon(Icons.person, size: radius * 1.2, color: Colors.grey[400]),
    );
  }
}
