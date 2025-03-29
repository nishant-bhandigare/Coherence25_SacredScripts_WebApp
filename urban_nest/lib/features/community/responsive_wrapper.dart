import 'package:flutter/material.dart';

/// A utility class to help with responsive designs
class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 900;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900;

  /// Responsive value based on screen width
  static double value({
    required BuildContext context,
    required double mobile,
    double? tablet,
    required double desktop,
  }) {
    final size = MediaQuery.of(context).size;
    if (size.width >= 900) {
      return desktop;
    } else if (size.width >= 600) {
      return tablet ?? (mobile + desktop) / 2;
    } else {
      return mobile;
    }
  }

  /// Responsive padding based on screen width
  static EdgeInsets padding({
    required BuildContext context,
    required EdgeInsets mobile,
    EdgeInsets? tablet,
    required EdgeInsets desktop,
  }) {
    final size = MediaQuery.of(context).size;
    if (size.width >= 900) {
      return desktop;
    } else if (size.width >= 600) {
      return tablet ?? EdgeInsets.lerp(mobile, desktop, 0.5)!;
    } else {
      return mobile;
    }
  }
}

/// A widget that builds different layouts based on screen size
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Desktop layout
    if (size.width >= 900) {
      return desktop;
    }

    // Tablet layout
    if (size.width >= 600) {
      return tablet ?? mobile;
    }

    // Mobile layout
    return mobile;
  }
}

/// A widget that applies constraints for different screen sizes
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidthMobile;
  final double? maxWidthTablet;
  final double? maxWidthDesktop;
  final EdgeInsets padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidthMobile,
    this.maxWidthTablet,
    this.maxWidthDesktop,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    double? maxWidth;
    if (size.width >= 900) {
      maxWidth = maxWidthDesktop ?? 1200;
    } else if (size.width >= 600) {
      maxWidth = maxWidthTablet ?? 700;
    } else {
      maxWidth = maxWidthMobile;
    }

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        padding: padding,
        child: child,
      ),
    );
  }
}
