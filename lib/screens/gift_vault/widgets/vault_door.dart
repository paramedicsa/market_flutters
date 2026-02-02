import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../theme/app_theme.dart';

class VaultDoor extends StatefulWidget {
  final bool isOpen;
  final VoidCallback? onAnimationComplete;

  const VaultDoor({
    super.key,
    required this.isOpen,
    this.onAnimationComplete,
  });

  @override
  State<VaultDoor> createState() => _VaultDoorState();
}

class _VaultDoorState extends State<VaultDoor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _shouldShake = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        widget.onAnimationComplete?.call();
      }
    });

    if (widget.isOpen) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(VaultDoor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void slamShut() {
    setState(() {
      _shouldShake = true;
    });
    _controller.reverse();
    
    // Trigger screen shake effect
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _shouldShake = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            // Left Door
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(-size.width * 0.5 * _animation.value, 0.0),
                child: _buildDoor(
                  context,
                  isLeft: true,
                  shake: _shouldShake,
                ),
              ),
            ),
            // Right Door
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(size.width * 0.5 * _animation.value, 0.0),
                child: _buildDoor(
                  context,
                  isLeft: false,
                  shake: _shouldShake,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDoor(BuildContext context, {required bool isLeft, bool shake = false}) {
    final size = MediaQuery.of(context).size;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      transform: shake
          ? (Matrix4.identity()
            ..translate(math.Random().nextDouble() * 10 - 5, 0.0))
          : Matrix4.identity(),
      width: size.width * 0.5,
      height: size.height,
      decoration: BoxDecoration(
        gradient: AppTheme.goldenGradient(),
        border: Border.all(
          color: const Color(0xFFFFD700).withOpacity(0.8),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Door texture lines
          Positioned.fill(
            child: CustomPaint(
              painter: _DoorTexturePainter(),
            ),
          ),
          // GIFT VAULT Text
          Center(
            child: Transform.rotate(
              angle: isLeft ? -math.pi / 2 : math.pi / 2,
              child: Text(
                'GIFT VAULT',
                style: TextStyle(
                  fontFamily: 'CherryCreamSoda',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.3),
                  letterSpacing: 8,
                  shadows: [
                    Shadow(
                      color: Colors.white.withOpacity(0.5),
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Door handle
          Positioned(
            top: size.height * 0.5 - 30,
            left: isLeft ? size.width * 0.4 : size.width * 0.1,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFD700),
                    const Color(0xFFFFA500).withOpacity(0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoorTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Vertical lines for texture
    for (var i = 0; i < 5; i++) {
      final x = size.width * (i + 1) / 6;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines for panels
    final panelHeight = size.height / 4;
    for (var i = 1; i < 4; i++) {
      canvas.drawLine(
        Offset(0, panelHeight * i),
        Offset(size.width, panelHeight * i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
