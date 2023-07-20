library running_stroke;

import 'dart:async';
import 'package:flutter/material.dart';

class RunningStroke extends StatefulWidget {
  RunningStroke({
    super.key,
    required this.text,
    this.style,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.velocity = 50.0,
  })  : assert(velocity >= 0.0, "The velocity cannot be zero and less than zero."),
        assert(velocity.isFinite);

  final String text;

  final TextStyle? style;

  final CrossAxisAlignment crossAxisAlignment;

  final double velocity;

  @override
  State<StatefulWidget> createState() => _RunningStrokeState();
}

class _RunningStrokeState extends State<RunningStroke> {
  final ScrollController scrollController = ScrollController();

  late double target;

  late Duration duration;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future<void>;
      Future.doWhile(scrolling);
    });
  }

  Future<bool> scrolling() async {
    await _animateTo(target, duration, Curves.linear);
    return false;
  }

  void _initialize(BuildContext context) {
    target = _getTextWidth(context);
    duration = Duration(milliseconds: (target / widget.velocity * 1000).toInt());
  }

  Future<void> _animateTo(
      double target,
      Duration duration,
      Curve curve,
      ) async {
    await scrollController.animateTo(target, duration: duration, curve: curve);
  }

  double _getTextWidth(BuildContext context) {
    final span = TextSpan(text: widget.text, style: widget.style);

    const constraints = BoxConstraints(maxWidth: double.infinity);

    final richTextWidget = Text.rich(span).build(context) as RichText;
    final renderObject = richTextWidget.createRenderObject(context);
    renderObject.layout(constraints);

    final boxes = renderObject.getBoxesForSelection(TextSelection(
      baseOffset: 0,
      extentOffset: TextSpan(text: widget.text).toPlainText().length,
    ));

    return boxes.last.end;
  }

  @override
  Widget build(BuildContext context) {
    _initialize(context);

    Alignment? alignment;

    switch (widget.crossAxisAlignment) {
      case CrossAxisAlignment.start:
        alignment =  Alignment.topCenter;
        break;
      case CrossAxisAlignment.end:
        alignment = Alignment.bottomCenter;
        break;
      case CrossAxisAlignment.center:
        alignment = Alignment.center;
        break;
      case CrossAxisAlignment.stretch:
        break;
      case CrossAxisAlignment.baseline:
        alignment = null;
        break;
    }

    Widget runningStroke = ListView.builder(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, i) {
        Text text = Text(widget.text, style: widget.style);
        return alignment == null
            ? text
            : Align(alignment: alignment, child: text);
        //text;
      },
    );

    return runningStroke;
  }
}
