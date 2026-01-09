import 'package:flutter/material.dart';
import 'package:afia_plus_app/utils/app_constants.dart';

/// A reusable widget that loads profile images from network URLs (Supabase bucket)
/// with fallback to default asset images
class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final bool isDoctor;
  final double radius;

  const ProfileImageWidget({
    super.key,
    this.imageUrl,
    this.isDoctor = true,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    // Default image based on role
    final defaultImage = isDoctor
        ? AppConstants.defaultDoctorImage
        : AppConstants.defaultPatientImage;

    // If imageUrl is null or empty, use default asset image
    if (imageUrl == null || imageUrl!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(defaultImage),
      );
    }

    // Check if it's a network URL (contains http:// or https://)
    if (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://')) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
        onBackgroundImageError: (exception, stackTrace) {
          // On error, fall back to default asset
          // Note: This won't trigger a rebuild, but prevents crash
          debugPrint('Error loading profile image: $exception');
        },
        child: Container(
          // This will only show while loading or on error
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(defaultImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    // If it's a local path (legacy data), use asset image
    return CircleAvatar(
      radius: radius,
      backgroundImage: AssetImage(defaultImage),
    );
  }
}

/// Extension to provide a better error-handling CircleAvatar
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
    final defaultImage = isDoctor
        ? AppConstants.defaultDoctorImage
        : AppConstants.defaultPatientImage;

    // Use FadeInImage approach for better loading experience
    if (imageUrl != null &&
        imageUrl!.isNotEmpty &&
        (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://'))) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: FadeInImage.assetNetwork(
            placeholder: defaultImage,
            image: imageUrl!,
            fit: BoxFit.cover,
            width: radius * 2,
            height: radius * 2,
            imageErrorBuilder: (context, error, stackTrace) {
              // Show default image on error
              return Image.asset(
                defaultImage,
                fit: BoxFit.cover,
                width: radius * 2,
                height: radius * 2,
              );
            },
          ),
        ),
      );
    }

    // Fallback to default asset image
    return CircleAvatar(
      radius: radius,
      backgroundImage: AssetImage(defaultImage),
    );
  }
}
