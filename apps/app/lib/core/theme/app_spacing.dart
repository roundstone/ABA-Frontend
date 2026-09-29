import 'package:flutter/material.dart';

class AppSpacing {
  // Base spacing unit (8px grid system)
  static const double baseUnit = 8.0;

  // Spacing values
  static const double xs = baseUnit * 0.5; // 4px
  static const double sm = baseUnit * 1; // 8px
  static const double md = baseUnit * 2; // 16px
  static const double lg = baseUnit * 3; // 24px
  static const double xl = baseUnit * 4; // 32px
  static const double xxl = baseUnit * 5; // 40px
  static const double xxxl = baseUnit * 6; // 48px

  // Padding constants
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);

  // Horizontal padding
  static const EdgeInsets paddingHorizontalXS = EdgeInsets.symmetric(
    horizontal: xs,
  );
  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(
    horizontal: sm,
  );
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(
    horizontal: md,
  );
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(
    horizontal: lg,
  );
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(
    horizontal: xl,
  );

  // Vertical padding
  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(
    vertical: xs,
  );
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(
    vertical: sm,
  );
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(
    vertical: md,
  );
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(
    vertical: lg,
  );
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(
    vertical: xl,
  );

  // Specific padding combinations (commonly used in Clay app)
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets cardPaddingLarge = EdgeInsets.all(lg);

  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  static const EdgeInsets screenPadding = EdgeInsets.all(md);
  static const EdgeInsets screenPaddingLarge = EdgeInsets.all(lg);

  // List item padding
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  // App bar padding
  static const EdgeInsets appBarPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: xs,
  );

  // Bottom navigation padding
  static const EdgeInsets bottomNavPadding = EdgeInsets.symmetric(
    horizontal: sm,
    vertical: xs,
  );

  // Margin constants
  static const EdgeInsets marginXS = EdgeInsets.all(xs);
  static const EdgeInsets marginSM = EdgeInsets.all(sm);
  static const EdgeInsets marginMD = EdgeInsets.all(md);
  static const EdgeInsets marginLG = EdgeInsets.all(lg);
  static const EdgeInsets marginXL = EdgeInsets.all(xl);

  // Horizontal margins
  static const EdgeInsets marginHorizontalXS = EdgeInsets.symmetric(
    horizontal: xs,
  );
  static const EdgeInsets marginHorizontalSM = EdgeInsets.symmetric(
    horizontal: sm,
  );
  static const EdgeInsets marginHorizontalMD = EdgeInsets.symmetric(
    horizontal: md,
  );
  static const EdgeInsets marginHorizontalLG = EdgeInsets.symmetric(
    horizontal: lg,
  );

  // Vertical margins
  static const EdgeInsets marginVerticalXS = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets marginVerticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets marginVerticalMD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets marginVerticalLG = EdgeInsets.symmetric(vertical: lg);

  // Border radius values
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusCircle = 50.0;

  // Border radius constants
  static const BorderRadius borderRadiusXS = BorderRadius.all(
    Radius.circular(radiusXS),
  );
  static const BorderRadius borderRadiusSM = BorderRadius.all(
    Radius.circular(radiusSM),
  );
  static const BorderRadius borderRadiusMD = BorderRadius.all(
    Radius.circular(radiusMD),
  );
  static const BorderRadius borderRadiusLG = BorderRadius.all(
    Radius.circular(radiusLG),
  );
  static const BorderRadius borderRadiusXL = BorderRadius.all(
    Radius.circular(radiusXL),
  );
  static const BorderRadius borderRadiusXXL = BorderRadius.all(
    Radius.circular(radiusXXL),
  );

  // Specific border radius for components
  static const BorderRadius buttonRadius = BorderRadius.all(
    Radius.circular(radiusMD),
  );
  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(radiusMD),
  );
  static const BorderRadius inputRadius = BorderRadius.all(
    Radius.circular(radiusMD),
  );
  static const BorderRadius dialogRadius = BorderRadius.all(
    Radius.circular(radiusLG),
  );
  static const BorderRadius bottomSheetRadius = BorderRadius.only(
    topLeft: Radius.circular(radiusXL),
    topRight: Radius.circular(radiusXL),
  );

  // Service card specific radius (larger for visual impact)
  static const BorderRadius serviceCardRadius = BorderRadius.all(
    Radius.circular(radiusLG),
  );

  // Product card radius
  static const BorderRadius productCardRadius = BorderRadius.all(
    Radius.circular(radiusMD),
  );

  // Avatar radius
  static const BorderRadius avatarRadius = BorderRadius.all(
    Radius.circular(radiusCircle),
  );

  // Gap spacing (for Flex widgets)
  static const double gapXS = xs;
  static const double gapSM = sm;
  static const double gapMD = md;
  static const double gapLG = lg;
  static const double gapXL = xl;

  // Elevation values
  static const double elevationNone = 0;
  static const double elevationLow = 2;
  static const double elevationMedium = 4;
  static const double elevationHigh = 8;
  static const double elevationMax = 16;

  // Icon sizes
  static const double iconSizeXS = 16.0;
  static const double iconSizeSM = 20.0;
  static const double iconSizeMD = 24.0;
  static const double iconSizeLG = 32.0;
  static const double iconSizeXL = 40.0;
  static const double iconSizeXXL = 48.0;

  // Button heights
  static const double buttonHeightSM = 32.0;
  static const double buttonHeightMD = 40.0;
  static const double buttonHeightLG = 48.0;
  static const double buttonHeightXL = 56.0;

  // Input field heights
  static const double inputHeightSM = 40.0;
  static const double inputHeightMD = 48.0;
  static const double inputHeightLG = 56.0;

  // App bar height
  static const double appBarHeight = 56.0;

  // Bottom navigation height
  static const double bottomNavHeight = 60.0;

  // Card dimensions
  static const double cardMinHeight = 120.0;
  static const double serviceCardHeight = 140.0;
  static const double productCardWidth = 200.0;
  static const double productCardHeight = 280.0;

  // Layout breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Splash screen and loading indicators
  static const Duration splashDuration = Duration(milliseconds: 2000);
  static const Duration loadingDuration = Duration(milliseconds: 1000);

  // Helper methods for responsive spacing
  static double getResponsiveSpacing(
    BuildContext context, {
    double mobile = md,
    double tablet = lg,
    double desktop = xl,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < mobileBreakpoint) {
      return mobile;
    } else if (screenWidth < tabletBreakpoint) {
      return tablet;
    } else {
      return desktop;
    }
  }

  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    EdgeInsets mobile = paddingMD,
    EdgeInsets tablet = paddingLG,
    EdgeInsets desktop = paddingXL,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < mobileBreakpoint) {
      return mobile;
    } else if (screenWidth < tabletBreakpoint) {
      return tablet;
    } else {
      return desktop;
    }
  }

  static double getResponsiveRadius(
    BuildContext context, {
    double mobile = radiusMD,
    double tablet = radiusLG,
    double desktop = radiusXL,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < mobileBreakpoint) {
      return mobile;
    } else if (screenWidth < tabletBreakpoint) {
      return tablet;
    } else {
      return desktop;
    }
  }

  // Spacing widgets for easy use
  static Widget get verticalSpaceXS => const SizedBox(height: xs);
  static Widget get verticalSpaceSM => const SizedBox(height: sm);
  static Widget get verticalSpaceMD => const SizedBox(height: md);
  static Widget get verticalSpaceLG => const SizedBox(height: lg);
  static Widget get verticalSpaceXL => const SizedBox(height: xl);
  static Widget get verticalSpaceXXL => const SizedBox(height: xxl);

  static Widget get horizontalSpaceXS => const SizedBox(width: xs);
  static Widget get horizontalSpaceSM => const SizedBox(width: sm);
  static Widget get horizontalSpaceMD => const SizedBox(width: md);
  static Widget get horizontalSpaceLG => const SizedBox(width: lg);
  static Widget get horizontalSpaceXL => const SizedBox(width: xl);
  static Widget get horizontalSpaceXXL => const SizedBox(width: xxl);

  // Custom spacing widget
  static Widget verticalSpace(double height) => SizedBox(height: height);
  static Widget horizontalSpace(double width) => SizedBox(width: width);
}
// Usage example:
// final double spacing = AppSpacing.md;
// final EdgeInsets padding = AppSpacing.paddingMD;