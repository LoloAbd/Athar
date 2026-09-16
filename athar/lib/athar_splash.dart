import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'services/auth_gate.dart';

class AtharSplashScreen extends StatefulWidget {
  final Function(Locale) onLanguageChanged;

  const AtharSplashScreen({super.key, required this.onLanguageChanged});

  @override
  State<AtharSplashScreen> createState() => _AtharSplashScreenState();
}

class _AtharSplashScreenState extends State<AtharSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _logoAnimation;
  late Animation<double> _subtitleAnimation;
  late Animation<double> _bottomAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _logoAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
    );

    _subtitleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
    );

    _bottomAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );

    // Start animation
    _controller.forward();

    // بعد انتهاء الـ animation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goToAuth();
      }
    });
  }

  void _goToAuth() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            AuthGate(onLanguageChanged: widget.onLanguageChanged),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF173B5E),

      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // =========================
                  // LOGO
                  // =========================
                  Opacity(
                    opacity: _logoAnimation.value.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: 0.75 + (_logoAnimation.value * 0.25),
                      child: Column(
                        children: [
                          // Arabic logo
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Golden decorative curve
                              Positioned(
                                bottom: -8,
                                child: CustomPaint(
                                  size: const Size(180, 45),
                                  painter: GoldenCurvePainter(),
                                ),
                              ),

                              // Arabic text
                              Text(
                                'أَثر',
                                textDirection: TextDirection.rtl,
                                style: GoogleFonts.amiri(
                                  fontSize: 100,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFE3B866),
                                  height: 1,
                                ),
                              ),

                              // Small diamond
                              Positioned(
                                top: 3,
                                right: 50,
                                child: Transform.rotate(
                                  angle: 0.785,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE3B866),
                                    ),
                                  ),
                                ),
                              ),

                              // Small sparkle
                              Positioned(
                                top: 55,
                                left: 12,
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 22,
                                  color: const Color(0xFFE3B866),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // English name
                          Text(
                            'Athar',
                            style: GoogleFonts.cinzel(
                              fontSize: 48,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 7,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Golden divider
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 1,
                                color: const Color(0xFFE3B866),
                              ),

                              const SizedBox(width: 10),

                              const Icon(
                                Icons.diamond_outlined,
                                size: 15,
                                color: Color(0xFFE3B866),
                              ),

                              const SizedBox(width: 10),

                              Container(
                                width: 100,
                                height: 1,
                                color: const Color(0xFFE3B866),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // =========================
                  // SUBTITLE
                  // =========================
                  Opacity(
                    opacity: _subtitleAnimation.value.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, 25 * (1 - _subtitleAnimation.value)),
                      child: Column(
                        children: [
                          Text(
                            'رسالة تلامس قلبك',
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.almarai(
                              fontSize: 21,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'A message that touches your heart',
                            style: GoogleFonts.alike(
                              fontSize: 15,
                              letterSpacing: 0.5,
                              color: const Color(0xFFD7E2ED),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 55),

                  // =========================
                  // HEART
                  // =========================
                  Opacity(
                    opacity: _bottomAnimation.value.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - _bottomAnimation.value)),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                Icons.favorite_border,
                                size: 45,
                                color: Color(0xFFE3B866),
                              ),

                              Positioned(
                                top: -5,
                                right: -5,
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 15,
                                  color: const Color(0xFFE3B866),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'Every message leaves an أثر',
                            style: GoogleFonts.alike(
                              fontSize: 11,
                              letterSpacing: 1,
                              color: const Color(0xFFB9CADB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class GoldenCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE3B866)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path();
    path.moveTo(10, 20);
    path.quadraticBezierTo(size.width * 0.35, 0, size.width * 0.65, 15);
    path.quadraticBezierTo(size.width * 0.85, 28, size.width - 5, 10);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
