import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final Duration duration;
  final Color? color;
  final double? size;

  const TypewriterText({
    Key? key,
    required this.text,
    this.duration = const Duration(milliseconds: 100), this.color, this.size,
  }) : super(key: key);

  @override
  _TypewriterTextState createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: widget.duration * widget.text.length,
      vsync: this,
    );

    // Create an integer animation that goes from 0 to text length
    _animation = IntTween(begin: 0, end: widget.text.length).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text.substring(0, _animation.value),
      style: TextStyle(fontSize: widget.size ?? 24, color: widget.color ?? Colors.white.withValues(alpha: 0.5)), // Customize your text style here
    );
  }
}
