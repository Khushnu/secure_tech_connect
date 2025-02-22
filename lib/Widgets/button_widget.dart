import 'package:flutter/material.dart';

class AnimatedSubmitButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String? text;
  final Color? color;
  final double? width;
  final double? height;
  const AnimatedSubmitButton({super.key, required this.onPressed, 
  this.text, this.color, this.width, this.height});

  @override
  _AnimatedSubmitButtonState createState() => _AnimatedSubmitButtonState();
}

class _AnimatedSubmitButtonState extends State<AnimatedSubmitButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Create a scale animation that scales from 1 to 0.95 and back to 1
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Reverse the animation when it completes
          _controller.reverse();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller.isCompleted || _controller.status == AnimationStatus.dismissed) {
          // Start the animation when the button is pressed
          _controller.forward();

          // Call the onPressed callback after a slight delay to ensure the animation completes
          Future.delayed(const Duration(milliseconds: 300), widget.onPressed);
        }
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: widget.color ?? Colors.blue,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              widget.text ?? 'Submit',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}