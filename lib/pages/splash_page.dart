import 'package:ecommerce_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  // How long the splash stays on screen before moving to the home page.
  final Duration duration;
  const SplashPage({
    this.duration = const Duration(milliseconds: 2500),
    super.key,
  });

  // Same dark color as the logo's background, so the logo blends in.
  static const background = Color.fromRGBO(35, 39, 42, 1);
  static const gold = Color.fromRGBO(180, 152, 95, 1);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..forward();

  late final Animation<double> _logoScale = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.7, curve: Curves.easeOutBack),
  );

  late final Animation<double> _titleFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.4, 1, curve: Curves.easeOut),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.duration, _goHome);
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
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
      backgroundColor: SplashPage.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _logoScale,
              child: Image.asset('assets/images/logo.png', width: 200),
            ),
            const SizedBox(height: 24),
            FadeTransition(
              opacity: _titleFade,
              child: Column(
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 40,
                        letterSpacing: 2,
                      ),
                      children: [
                        TextSpan(
                          text: 'SHOE',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: SplashPage.gold,
                          ),
                        ),
                        TextSpan(
                          text: 'HUB',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Step into style',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      letterSpacing: 1.5,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
