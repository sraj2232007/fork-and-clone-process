import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
    _navigationTimer = Timer(const Duration(seconds: 4), _openLoginScreen);
  }

  void _openLoginScreen() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF071A36), Color(0xFF050D1B), Color(0xFF10132B)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -110,
              right: -100,
              child: _GlowOrb(color: Color(0xFF087EFF), size: 300),
            ),
            const Positioned(
              bottom: -155,
              left: -120,
              child: _GlowOrb(color: Color(0xFFFF6B00), size: 310),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                    final logoSize =
                      math.min(constraints.maxWidth * 0.84, 390.0).toDouble();
                  final minContentHeight = constraints.hasBoundedHeight
                      ? math.max(0.0, constraints.maxHeight - 56).toDouble()
                      : 0.0;
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 28,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: minContentHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 12),
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                final phase = _animationController.value;
                                final angle = math.sin(phase * math.pi) * 0.12;
                                final lift = math.sin(phase * math.pi) * 10;

                                return Transform.translate(
                                  offset: Offset(0, -lift),
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..setEntry(3, 2, 0.0015)
                                      ..rotateY(angle)
                                      ..rotateX(-angle * 0.3),
                                    child: child,
                                  ),
                                );
                              },
                              child: SizedBox(
                                width: logoSize,
                                height: logoSize,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _animationController,
                                      builder: (context, child) => Container(
                                        width: logoSize * 0.78,
                                        height: logoSize * 0.78,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF078DFF)
                                                    .withValues(
                                                    alpha: 0.16 +
                                                      _animationController.value *
                                                        0.14,
                                                    ),
                                              blurRadius: 62,
                                              spreadRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    CustomPaint(
                                      size: Size.square(logoSize),
                                      painter: _OrbitPainter(
                                        progress: _animationController.value,
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/images/busiserve_logo.png',
                                      width: logoSize * 0.9,
                                      height: logoSize * 0.9,
                                      fit: BoxFit.contain,
                                      filterQuality: FilterQuality.high,
                                      semanticLabel:
                                          'BusiServe Infotech Solution logo',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'BUSINESS, MOVING FORWARD.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFF4F8FF),
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.4,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 330),
                              child: const Text(
                                'Smart technology. Bold ideas. Better growth.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF9BAEC9),
                                  fontSize: 15,
                                  height: 1.5,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 42),
                            const _LoadingIndicator(),
                            const SizedBox(height: 18),
                            const Text(
                              'INNOVATION THAT MOVES YOU',
                              style: TextStyle(
                                color: Color(0xFF8194B0),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.17), color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  const _OrbitPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: size.width * 0.91,
      height: size.height * 0.48,
    );
    final rotation = -0.22 + math.sin(progress * math.pi) * 0.08;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawOval(
      rect,
      Paint()
        ..color = const Color(0xFF58B7FF).withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    final dotAngle = progress * math.pi * 2;
    final dotPosition = Offset(
      center.dx + math.cos(dotAngle) * rect.width / 2,
      center.dy + math.sin(dotAngle) * rect.height / 2,
    );
    canvas.drawCircle(
      dotPosition,
      3.2,
      Paint()
        ..color = const Color(0xFFFF8B19)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawCircle(dotPosition, 2, Paint()..color = const Color(0xFFFFB13D));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _LoadingIndicator extends StatefulWidget {
  const _LoadingIndicator();

  @override
  State<_LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<_LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
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
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final phase = (_controller.value - index * 0.18) % 1;
            final emphasis = 0.45 + 0.55 * math.sin(phase * math.pi);
            return Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.lerp(
                  const Color(0xFF168DFF),
                  const Color(0xFFFF8A12),
                  index / 2,
                )!.withValues(alpha: emphasis),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF148CFF)
                        .withValues(alpha: emphasis * 0.35),
                    blurRadius: 8,
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
