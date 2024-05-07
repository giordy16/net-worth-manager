import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef XAxisRangeWidgetBuilder = Widget Function(double minX, double maxX);

class ZoomableChart extends StatefulWidget {
  final double minX;
  final double maxX;
  final int visibleXSize;
  final XAxisRangeWidgetBuilder itemBuilder;
  final double xScrollOffset;
  const ZoomableChart({
    required this.minX,
    required this.maxX,
    required this.itemBuilder,
    this.visibleXSize = 5,
    this.xScrollOffset = 0.01,
    Key? key,
  }) : super(key: key);

  @override
  State<ZoomableChart> createState() => _LinePlotState();
}

class _LinePlotState extends State<ZoomableChart> {
  late double minX;
  late double maxX;
  late double xRange;
  late double currentMinX;
  late double currentMaxX;
  late int visibleRange;
  @override
  void initState() {
    super.initState();
    _handleX();
  }

  @override
  void didUpdateWidget(covariant ZoomableChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.minX != oldWidget.minX || widget.maxX != oldWidget.maxX) {
      setState(() {
        _handleX();
      });
    }
  }

  void _handleX() {
    visibleRange = widget.visibleXSize - 1;
    minX = widget.minX;
    maxX = widget.maxX;
    xRange = maxX -= minX;
    currentMaxX = maxX;
    currentMinX = maxX - visibleRange;
    if (currentMinX < minX) {
      currentMinX = minX;
      currentMaxX = minX + visibleRange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (dragUpdDet) {
        double primaryDelta = dragUpdDet.primaryDelta ?? 0.0;
        double tempMinX = currentMinX;
        double tempMaxX = currentMaxX;
        if (primaryDelta != 0) {
          if (primaryDelta.isNegative) {
            tempMinX += xRange * widget.xScrollOffset;
            tempMaxX += xRange * widget.xScrollOffset;
          } else {
            tempMinX -= xRange * widget.xScrollOffset;
            tempMaxX -= xRange * widget.xScrollOffset;
          }
        }
        if (tempMinX < minX) {
          setState(() {
            currentMinX = minX;
          });
          return;
        }
        if (tempMaxX > maxX) {
          setState(() {
            currentMaxX = maxX;
          });
          return;
        }
        setState(() {
          currentMinX = tempMinX;
          currentMaxX = tempMaxX;
        });
      },
      child: widget.itemBuilder(currentMinX, currentMaxX),
    );
  }
}
