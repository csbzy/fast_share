import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(SizingInformation sizingInformation) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return  builder(SizingInformation(width, height));
  }
}

class SizingInformation {
  final bool isMobile;
  final bool isTabletOrDesktop;
  final bool isDesktop;
  final double screenWidth;
  final double screenHeight;

  SizingInformation(double width, double height)
      : isMobile = width < 700,
        isTabletOrDesktop = width >= 700,
        isDesktop = width >= 800,
        screenHeight = height,
        screenWidth = width;
}
