import 'package:flutter/material.dart';

class CustomMouseRegion extends StatefulWidget {
  final Widget child;
  final Color defaultColor;
  final Color hoverColor;
  final double height;
  final double width;
  final Duration duration;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  const CustomMouseRegion({
    super.key,
    required this.child,
    this.defaultColor = Colors.transparent,
    this.hoverColor = Colors.blue,
    this.height = 60,
    this.width = 60,
    this.duration = const Duration(milliseconds: 200),
    this.borderRadius,
    this.padding,
    this.onTap,
    this.border,
    this.boxShadow,
  });

  @override
  State<CustomMouseRegion> createState() => _CustomMouseRegionState();
}

class _CustomMouseRegionState extends State<CustomMouseRegion> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHover = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: widget.duration,
          padding: widget.padding,
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: isHover ? widget.hoverColor : widget.defaultColor,
            borderRadius: widget.borderRadius,
            border: widget.border,
            boxShadow: widget.boxShadow,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}