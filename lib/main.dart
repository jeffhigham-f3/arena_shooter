import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'config/game_config.dart';
import 'game/my_game.dart';
import 'game/overlays/game_over.dart';
import 'game/overlays/hud.dart';
import 'game/overlays/main_menu.dart';
import 'game/overlays/pause_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  late final MyGame _game;

  @override
  void initState() {
    super.initState();
    _game = MyGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FittedBox(
          child: SizedBox(
            width: GameConfig.gameWidth,
            height: GameConfig.gameHeight,
            child: GameWidget<MyGame>(
              game: _game,
              // Initial overlays to display
              initialActiveOverlays: const ['MainMenu'],
              // Define all available overlays
              overlayBuilderMap: {
                'MainMenu': (context, game) => MainMenu(game: game),
                'HUD': (context, game) => HUD(game: game),
                'PauseMenu': (context, game) => PauseMenu(game: game),
                'GameOver': (context, game) => GameOver(game: game),
              },
              // Loading screen while game initializes
              loadingBuilder: (context) => const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4CAF50),
                ),
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
      ),
    );
  }
}
