import 'dart:math';

import 'package:flip_list/src/flip_stack.dart';
import 'package:flutter/material.dart';

/// Allows for showing a list of widgets
/// which the user can flip through with vertical swipes
/// and the items are folded like in a flipboard
class FlipList extends StatefulWidget {
  final int itemCount;
  final FlipListItemBuilder itemBuilder;

  const FlipList(
      {super.key, required this.itemBuilder, required this.itemCount});

  @override
  State<FlipList> createState() => _FlipListState();
}

typedef FlipListItemBuilder = Widget Function(BuildContext context, int index);

class _FlipListState extends State<FlipList>
    with SingleTickerProviderStateMixin {
  double _dragDistance = 200;
  int currentIndex = 0;
  int belowIndex = -1;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          currentIndex = belowIndex;
          belowIndex = -1;
        });
        _controller.reset();
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          belowIndex = -1;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dragDistance = MediaQuery.of(context).size.height / 3;
  }

  Offset _startDrag = Offset.zero;
  _onDragStart(DragStartDetails details) {
    if (_controller.isAnimating && belowIndex >= 0) {
      _controller.stop();
      if (belowIndex > currentIndex) {
        _startDrag = details.globalPosition -
            Offset(0, _dragDistance * _controller.value);
      } else {
        _startDrag = details.globalPosition +
            Offset(0, _dragDistance * _controller.value);
      }
    } else {
      _startDrag = details.globalPosition;
    }
  }

  _onDragUpdate(DragUpdateDetails details) {
    final dragDistance = details.globalPosition - _startDrag;
    if (belowIndex < 0) {
      if (dragDistance.dy > 0) {
        setState(() {
          belowIndex = currentIndex - 1;
        });
      } else {
        setState(() {
          belowIndex = currentIndex + 1;
        });
      }
    }
    _controller.value =
        min(dragDistance.dy.abs(), _dragDistance * 0.99) / _dragDistance;
  }

  _onDragEnd(DragEndDetails details) {
    if (_controller.value > 0.5 || details.primaryVelocity!.abs() > 500) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragStart: _onDragStart,
        onVerticalDragUpdate: _onDragUpdate,
        onVerticalDragEnd: _onDragEnd,
        child: belowIndex < 0
            ? widget.itemBuilder(context, currentIndex)
            : AnimatedBuilder(
                animation: _controller,
                builder: (ctx, child) => FlipStack(
                    flipFactor: (belowIndex - currentIndex) * _controller.value,
                    aboveWidget: widget.itemBuilder(context, currentIndex),
                    belowWidget: widget.itemBuilder(context, belowIndex)),
              ));
  }
}
