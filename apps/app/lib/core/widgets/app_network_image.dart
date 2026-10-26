import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Contextual fallback type used to select appropriate placeholder icons.
enum AppImageFallbackType { product, avatar, merchant, banner, generic }

/// A reusable cached network image widget with graceful fallbacks.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
    this.fallbackType = AppImageFallbackType.generic,
    this.fallbackText,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
    this.iconColor,
    this.memCacheWidth,
    this.memCacheHeight,
    this.cacheKey,
  });

  /// Factory for circular user or merchant avatars.
  factory AppNetworkImage.avatar({
    Key? key,
    required String? imageUrl,
    double size = 40,
    String? name,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return AppNetworkImage(
      key: key,
      imageUrl: imageUrl,
      width: size,
      height: size,
      shape: BoxShape.circle,
      fallbackType: AppImageFallbackType.avatar,
      fallbackText: name,
      backgroundColor: backgroundColor,
      iconColor: textColor,
    );
  }

  /// Factory for product thumbnails and catalog images.
  factory AppNetworkImage.product({
    Key? key,
    required String? imageUrl,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    BoxFit fit = BoxFit.cover,
    Color? backgroundColor,
  }) {
    return AppNetworkImage(
      key: key,
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      fallbackType: AppImageFallbackType.product,
    );
  }

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BoxShape shape;
  final BorderRadius? borderRadius;
  final AppImageFallbackType fallbackType;
  final String? fallbackText;
  final WidgetBuilder? placeholder;
  final Widget Function(BuildContext, Object, StackTrace?)? errorWidget;
  final Color? backgroundColor;
  final Color? iconColor;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final String? cacheKey;

  /// Returns a [CachedNetworkImageProvider] for use with [CircleAvatar] or [DecorationImage].
  static ImageProvider provider(
    String imageUrl, {
    String? cacheKey,
    int? maxHeight,
    int? maxWidth,
  }) {
    return CachedNetworkImageProvider(
      imageUrl,
      cacheKey: cacheKey,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );
  }

  bool get _isValidUrl {
    if (imageUrl == null) return false;
    final trimmed = imageUrl!.trim();
    return trimmed.isNotEmpty &&
        (trimmed.startsWith('http://') || trimmed.startsWith('https://'));
  }

  @override
  Widget build(BuildContext context) {
    final Widget imageContent;
    if (!_isValidUrl) {
      imageContent = _buildFallback(context);
    } else {
      imageContent = CachedNetworkImage(
        imageUrl: imageUrl!.trim(),
        cacheKey: cacheKey,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        fadeInDuration: const Duration(milliseconds: 180),
        fadeOutDuration: const Duration(milliseconds: 180),
        placeholder: (ctx, _) => placeholder != null
            ? placeholder!(ctx)
            : _buildLoadingPlaceholder(ctx),
        errorWidget: (ctx, _, err) => errorWidget != null
            ? errorWidget!(ctx, err, null)
            : _buildFallback(ctx),
      );
    }

    return _applyClipping(
      SizedBox(width: width, height: height, child: imageContent),
    );
  }

  Widget _applyClipping(Widget child) {
    if (shape == BoxShape.circle) return ClipOval(child: child);
    if (borderRadius != null && borderRadius != BorderRadius.zero) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _buildLoadingPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? AppColors.surface2,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        color: iconColor ?? AppColors.textSubtle.withAlpha(128),
        size: _calculateIconSize(),
      ),
    );
  }

  Widget _buildFallback(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.surface2;
    final fgColor = iconColor ?? AppColors.grey;

    if (fallbackType == AppImageFallbackType.avatar &&
        fallbackText != null &&
        fallbackText!.trim().isNotEmpty) {
      final initials = _extractInitials(fallbackText!);
      return Container(
        width: width,
        height: height,
        color: bgColor,
        alignment: Alignment.center,
        child: Text(
          initials,
          style: AppTypography.label.copyWith(
            color: fgColor,
            fontWeight: FontWeight.w700,
            fontSize: (width != null) ? (width! * 0.38) : 14.0,
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      color: bgColor,
      alignment: Alignment.center,
      child: HugeIcon(
        icon: _getFallbackIcon(),
        size: _calculateIconSize(),
        color: fgColor,
      ),
    );
  }

  List<List<dynamic>> _getFallbackIcon() {
    switch (fallbackType) {
      case AppImageFallbackType.product:
        return HugeIcons.strokeRoundedShoppingBag01;
      case AppImageFallbackType.avatar:
        return HugeIcons.strokeRoundedUser;
      case AppImageFallbackType.merchant:
        return HugeIcons.strokeRoundedStore01;
      case AppImageFallbackType.banner:
      case AppImageFallbackType.generic:
        return HugeIcons.strokeRoundedImage01;
    }
  }

  double _calculateIconSize() {
    final minDim = (width != null && height != null)
        ? (width! < height! ? width! : height!)
        : (width ?? height ?? 32.0);
    return (minDim * 0.45).clamp(16.0, 48.0);
  }

  String _extractInitials(String text) {
    final parts = text.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
