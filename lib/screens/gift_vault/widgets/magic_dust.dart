import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../theme/app_theme.dart';

class MagicDust extends StatefulWidget {
  final Offset startPosition;
  final Offset endPosition;
  final Widget child;
  final VoidCallback? onComplete;

  const MagicDust({
    super.key,
    required this.startPosition,
    required this.endPosition,
    required this.child,
    this.onComplete,
  });

  @override
  State<MagicDust> createState() => _MagicDustState();
}

class _MagicDustState extends State<MagicDust>
    with SingleTickerProviderStateMixin {
  static const int particleCount = 20; // Number of particles in trail
  
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  final List<Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _positionAnimation = Tween<Offset>(
      begin: widget.startPosition,
      end: widget.endPosition,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Generate particles
    for (int i = 0; i < particleCount; i++) {
      _particles.add(Particle(
        offset: Offset(
          _random.nextDouble() * 40 - 20,
          _random.nextDouble() * 40 - 20,
        ),
        color: _getRandomColor(),
        size: _random.nextDouble() * 8 + 4,
        delay: i * 0.05,
      ));
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _controller.forward();
  }

  Color _getRandomColor() {
    final colors = [
      AppTheme.pink,
      AppTheme.purple,
      AppTheme.cyan,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Particles trail
            for (final particle in _particles)
              if (_controller.value > particle.delay)
                Positioned(
                  left: _positionAnimation.value.dx +
                      particle.offset.dx * (1 - _controller.value),
                  top: _positionAnimation.value.dy +
                      particle.offset.dy * (1 - _controller.value),
                  child: Opacity(
                    opacity: (1 - _controller.value).clamp(0.0, 1.0),
                    child: Container(
                      width: particle.size,
                      height: particle.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: particle.color,
                        boxShadow: [
                          BoxShadow(
                            color: particle.color.withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            // Flying product image
            Positioned(
              left: _positionAnimation.value.dx - 30,
              top: _positionAnimation.value.dy - 30,
              child: Transform.scale(
                scale: 1 - (_controller.value * 0.3),
                child: widget.child,
              ),
            ),
          ],
        );
      },
    );
  }
}

class Particle {
  final Offset offset;
  final Color color;
  final double size;
  final double delay;

  Particle({
    required this.offset,
    required this.color,
    required this.size,
    required this.delay,
  });
}

class MagicDustOverlay {
  static OverlayEntry? _overlayEntry;

  static void showFlyAnimation({
    required BuildContext context,
    required Offset startPosition,
    required Offset endPosition,
    required Widget productImage,
    VoidCallback? onComplete,
  }) {
    // Remove any existing overlay
    remove();

    _overlayEntry = OverlayEntry(
      builder: (context) => MagicDust(
        startPosition: startPosition,
        endPosition: endPosition,
        onComplete: () {
          remove();
          onComplete?.call();
        },
        child: productImage,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void remove() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
