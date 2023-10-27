import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'half_widget.dart';

class FlipStack extends StatelessWidget {
  final Widget aboveWidget;
  final Widget belowWidget;

  /// A value between -1 and 1
  /// -1 / 1 means the below widget is fully visible
  /// 0 means above widget is fully visible
  /// 0 < flipFactor < 1 means bottom of above is flipping up
  /// -1 < flipFactor < 0 means top of above is flipping down
  final double flipFactor;

  const FlipStack({
    super.key,
    required this.aboveWidget,
    required this.belowWidget,
    this.flipFactor = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// ----- flipping up -------
        if (flipFactor > 0 && flipFactor < 0.5)
          Positioned.fill(
            child: Darken(
                amount: clampDouble(0.75 - 2 * flipFactor, 0, 0.75),
                child: belowWidget),
          ),
        if (flipFactor > 0 && flipFactor < 0.5)
          Positioned.fill(top: 0, child: TopHalf(child: aboveWidget)),
        if (flipFactor > 0.5)
          Positioned.fill(
            child: Darken(
                amount: clampDouble(2 * (flipFactor - 0.5), 0, 0.75),
                child: aboveWidget),
          ),
        if (flipFactor > 0.5)
          Positioned.fill(bottom: 0, child: BottomHalf(child: belowWidget)),
        if (flipFactor > 0 && flipFactor < 0.5)
          Positioned.fill(
            bottom: 0,
            child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(pi * flipFactor),
                child: BottomHalf(
                  child: Darken(
                    amount: flipFactor,
                    child: aboveWidget,
                  ),
                )),
          ),
        if (flipFactor > 0.5)
          Positioned.fill(
            top: 0,
            child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(pi * flipFactor - pi),
                child: TopHalf(
                  child: Darken(
                    amount: 1 - flipFactor,
                    child: belowWidget,
                  ),
                )),
          ),

        /// ----- flipping down -------
        if (flipFactor < 0 && flipFactor > -0.5)
          Positioned.fill(
            child: Darken(
                amount: clampDouble(0.75 - 2 * flipFactor.abs(), 0, 0.75),
                child: belowWidget),
          ),
        if (flipFactor < 0 && flipFactor > -0.5)
          Positioned.fill(bottom: 0, child: BottomHalf(child: aboveWidget)),
        if (flipFactor < -0.5)
          Positioned.fill(
            child: Darken(
                amount: clampDouble(2 * (flipFactor.abs() - 0.5), 0, 0.75),
                child: aboveWidget),
          ),
        if (flipFactor < -0.5)
          Positioned.fill(top: 0, child: TopHalf(child: belowWidget)),
        if (flipFactor < 0 && flipFactor > -0.5)
          Positioned.fill(
            top: 0,
            child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(pi * flipFactor),
                child: TopHalf(
                  child: Darken(
                    amount: flipFactor.abs(),
                    child: aboveWidget,
                  ),
                )),
          ),
        if (flipFactor < -0.5)
          Positioned.fill(
            bottom: 0,
            child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(pi * flipFactor + pi),
                child: BottomHalf(
                  child: Darken(
                    amount: 1 - flipFactor.abs(),
                    child: belowWidget,
                  ),
                )),
          ),
      ],
    );
  }
}

class Darken extends StatelessWidget {
  final double amount;
  final Widget child;

  const Darken({super.key, required this.amount, required this.child});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(amount),
        BlendMode.srcOver,
      ),
      child: child,
    );
  }
}
