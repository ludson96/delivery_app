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
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true, // Estende o background por trás da AppBar e Status Bar
      appBar: appBar,
      body: Stack(
        children: [
          // Background.webp em tela cheia estendido cobrindo AppBar e StatusBar
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
          // Conteúdo da tela com SafeArea opcional ou padding do topo da AppBar
          Positioned.fill(
            child: appBar != null
                ? Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + kToolbarHeight,
                    ),
                    child: child,
                  )
                : child,
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
