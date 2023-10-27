import 'package:flutter/material.dart';

class BottomHalf extends StatelessWidget {
  final Widget child;
  const BottomHalf({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.black,
              Colors.transparent,
              Colors.transparent,
            ], // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.clamp,
            stops: [0, 0.5, 0.5, 1.0]).createShader(bounds);
      },
      blendMode: BlendMode.dstOut,
      child: child,
    );
  }
}

class TopHalf extends StatelessWidget {
  final Widget child;
  const TopHalf({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.black,
              Colors.black,
            ], // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.clamp,
            stops: [0, 0.5, 0.5, 1.0]).createShader(bounds);
      },
      blendMode: BlendMode.dstOut,
      child: child,
    );
  }
}
