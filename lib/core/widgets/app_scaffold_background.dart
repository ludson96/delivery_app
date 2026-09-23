import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppScaffoldBackground extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final double overlayOpacity;

  const AppScaffoldBackground({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.overlayOpacity = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: appBar,
      body: Stack(
        children: [
          // Background.webp fixo em tela cheia
          Positioned.fill(
            child: Image.asset(
              AppConstants.backgroundAsset,
              fit: BoxFit.cover,
            ),
          ),
          // Overlay escuro com opacidade ajustável para excelente contraste e legibilidade
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: overlayOpacity),
            ),
          ),
          // Conteúdo da tela
          Positioned.fill(
            child: child,
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
