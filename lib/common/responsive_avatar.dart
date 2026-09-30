import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/provider/user_provider.dart';

/// Reusable responsive user avatar widget
class ResponsiveAvatar extends StatelessWidget {
  final double? size;
  final double? top;
  final double? left;
  final bool isProfilePage;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const ResponsiveAvatar({
    super.key,
    this.size,
    this.top,
    this.left,
    this.isProfilePage = false,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // responsiveness calculation for avatar size
    const double referenceWidth = 400.0;
    final double scaleFactor = screenSize.width / referenceWidth;

    final double computedSize = size ?? (90.0 * scaleFactor).clamp(60.0, 120.0);

    double? computedTop = top;
    double? computedLeft = left;

    if (isProfilePage && top == null && left == null) {
      computedTop = 105.0 * scaleFactor;
      computedLeft = 155.0 * scaleFactor;
    }

    Widget avatarContent = Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final userImage = userProvider.currentUserData?.userImage;
        return SizedBox(
          width: computedSize,
          height: computedSize,
          child: ClipOval(
            child: userImage != null && userImage.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: userImage,
                    fit: BoxFit.cover,
                    width: computedSize,
                    height: computedSize,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[800],
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: computedSize * 0.45,
                      ),
                    ),
                  )
                : Image.asset(
                    'assets/images/men.png',
                    fit: BoxFit.cover,
                    width: computedSize,
                    height: computedSize,
                  ),
          ),
        );
      },
    );

    if (onTap != null) {
      avatarContent = GestureDetector(
        onTap: onTap,
        child: avatarContent,
      );
    }

    if (padding != null) {
      avatarContent = Padding(
        padding: padding!,
        child: avatarContent,
      );
    } else if (computedTop != null || computedLeft != null) {
      avatarContent = Padding(
        padding: EdgeInsets.only(
          top: computedTop ?? 0.0,
          left: computedLeft ?? 0.0,
        ),
        child: avatarContent,
      );
    }

    return avatarContent;
  }
}
