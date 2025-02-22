
import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:securetech_connect/colors.dart';
import 'package:securetech_connect/extension.dart';

class Particle {
  double x, y, speedX, speedY, size;
  Color color;
  
  Particle(this.x, this.y, this.speedX, this.speedY, this.size, this.color);
}

class TechAiBackgroundScreen extends StatefulWidget {
  final Widget child;
  const TechAiBackgroundScreen({super.key, required this.child});

  @override
  State<TechAiBackgroundScreen> createState() => _TechAiBackgroundScreenState();
}

class _TechAiBackgroundScreenState extends State<TechAiBackgroundScreen> {
  final Random _random = Random();
  List<Particle> _particles = [];
  late Size screenSize;
  final double maxDistance = 100;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenSize = MediaQuery.of(context).size;
    _generateParticles();
    _startAnimation();
  }

  void _generateParticles() {
    for (int i = 0; i < 500; i++) { // Increased particle count
      _particles.add(
        Particle(
          _random.nextDouble() * screenSize.width,
          _random.nextDouble() * screenSize.height,
          (_random.nextDouble() - 0.5) * 2,
          (_random.nextDouble() - 0.5) * 2,
          _random.nextDouble() * 4 + 1,
          Color.lerp(Colors.cyan, Colors.greenAccent, _random.nextDouble())!,
        ),
      );
    }
  }

  void _startAnimation() {
    Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {
        for (var particle in _particles) {
          particle.x += particle.speedX;
          particle.y += particle.speedY;

          if (particle.x < 0 || particle.x > screenSize.width) particle.speedX *= -1;
          if (particle.y < 0 || particle.y > screenSize.height) particle.speedY *= -1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: ParticlePainter(_particles, maxDistance),
            ),
          ),
        Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
              child: Container(
                height: context.screenHeight * 0.4,
                width: context.screenWidth * 0.4,
                decoration: BoxDecoration(
                  color: primaryBgColor.withValues(alpha: 0.9), // Semi-transparent white
                  borderRadius: BorderRadius.circular(20), // Optional rounded corners
                  // border: Border.all(color: Colors.white, width: 2), // Optional border
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      spreadRadius: 9,
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                  ],
                ),
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class ParticlePainter extends CustomPainter {
  List<Particle> particles;
  double maxDistance;

  ParticlePainter(this.particles, this.maxDistance);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Draw connections
    for (var i = 0; i < particles.length; i++) {
      for (var j = i + 1; j < particles.length; j++) {
        double dx = particles[i].x - particles[j].x;
        double dy = particles[i].y - particles[j].y;
        double distance = sqrt(dx * dx + dy * dy);

        if (distance < maxDistance) {
          double opacity = (1 - distance / maxDistance).clamp(0, 1);
          paint.color = Colors.cyan.withValues(alpha: opacity);
          paint.strokeWidth = 1;
          canvas.drawLine(
            Offset(particles[i].x, particles[i].y),
            Offset(particles[j].x, particles[j].y),
            paint,
          );
        }
      }
    }

    // Draw particles
    for (var particle in particles) {
      paint.color = particle.color;
      canvas.drawCircle(Offset(particle.x, particle.y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

