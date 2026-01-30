import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/game_config.dart';
import 'game/my_game.dart';
import 'game/overlays/game_over.dart';
import 'game/overlays/hud.dart';
import 'game/overlays/main_menu.dart';
import 'game/overlays/pause_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to landscape orientation for better gameplay
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Hide system UI for immersive gameplay
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: GameConfig.gameTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  MyGame? _game;
  double? _lastWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate game width based on screen aspect ratio
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          // Guard against invalid constraints (can be 0 on first frame in release mode)
          if (screenWidth <= 0 || screenHeight <= 0) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
            );
          }

          final gameWidth = GameConfig.calculateGameWidth(
            screenWidth,
            screenHeight,
          );

          // Only recreate game if width changed significantly (avoids rebuild loops)
          if (_game == null ||
              (_lastWidth != null && (gameWidth - _lastWidth!).abs() > 10)) {
            GameConfig.setGameWidth(gameWidth);
            _game = MyGame();
            _lastWidth = gameWidth;
          } else if (_lastWidth == null) {
            GameConfig.setGameWidth(gameWidth);
            _lastWidth = gameWidth;
          }

          return SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: GameConfig.gameWidth,
                height: GameConfig.gameHeight,
                child: GameWidget<MyGame>(
                  game: _game!,
                  initialActiveOverlays: const ['MainMenu'],
                  overlayBuilderMap: {
                    'MainMenu': (context, game) => MainMenu(game: game),
                    'HUD': (context, game) => HUD(game: game),
                    'PauseMenu': (context, game) => PauseMenu(game: game),
                    'GameOver': (context, game) => GameOver(game: game),
                  },
                  // Loading screen while game initializes
                  loadingBuilder: (context) => const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
                  ),
                  // Error display
                  errorBuilder: (context, error) => Center(
                    child: Text(
                      'Error: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
