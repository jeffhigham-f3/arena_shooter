import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../config/game_config.dart';
import 'components/bullet.dart';
import 'components/player.dart';
import 'managers/enemy_manager.dart';
import 'managers/wave_manager.dart';

/// Game state enum
enum GameState { menu, playing, paused, gameOver }

/// Main game class that extends FlameGame
/// This is the entry point for all game logic
class MyGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  MyGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: GameConfig.gameWidth,
            height: GameConfig.gameHeight,
          ),
        );

  late Player player;
  late EnemyManager enemyManager;
  late WaveManager waveManager;
  
  /// Current game state
  GameState _gameState = GameState.menu;
  
  /// Get current game state
  GameState get gameState => _gameState;
  
  /// Current score
  int _score = 0;
  
  /// Get current score
  int get score => _score;
  
  /// Final score when game ended
  int _finalScore = 0;
  
  /// Get final score
  int get finalScore => _finalScore;
  
  /// Waves survived when game ended
  int _wavesSurvived = 0;
  
  /// Get waves survived
  int get wavesSurvived => _wavesSurvived;
  
  /// Get current difficulty name
  String get difficultyName => GameConfig.difficultySettings.name;

  @override
  Color backgroundColor() => const Color(0xFF2A2A40);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add player to the game world
    player = Player();
    world.add(player);

    // Add enemy manager
    enemyManager = EnemyManager();
    add(enemyManager);
    
    // Add wave manager
    waveManager = WaveManager(enemyManager: enemyManager);
    add(waveManager);

    // Debug mode if enabled
    if (GameConfig.showHitboxes) {
      debugMode = true;
    }
    
    // Start paused on main menu
    pauseEngine();
  }
  
  /// Start the game from the main menu
  void startGame() {
    _gameState = GameState.playing;
    overlays.remove('MainMenu');
    overlays.add('HUD');
    
    // Reset game state in case we're restarting
    resetGame();
    
    resumeEngine();
  }

  /// Add to the current score
  void addScore(int points) {
    _score += points;
  }

  /// Called when the player dies
  void onPlayerDeath() {
    _gameState = GameState.gameOver;
    _finalScore = _score;
    _wavesSurvived = waveManager.currentWave;
    pauseEngine();
    overlays.add('GameOver');
  }

  /// Pause the game and show pause overlay
  void pauseGame() {
    if (_gameState == GameState.playing) {
      _gameState = GameState.paused;
      pauseEngine();
      overlays.add('PauseMenu');
    }
  }

  /// Resume the game from pause
  void resumeGame() {
    if (_gameState == GameState.paused) {
      _gameState = GameState.playing;
      overlays.remove('PauseMenu');
      resumeEngine();
    }
  }

  /// Reset the game state for a new game
  void resetGame() {
    // Reset score
    _score = 0;
    _finalScore = 0;
    _wavesSurvived = 0;
    
    // Reset game state
    _gameState = GameState.playing;
    
    // Reset player
    player.reset();
    
    // Clear all enemies
    enemyManager.clearAllEnemies();
    
    // Clear all bullets
    world.children.whereType<Bullet>().toList().forEach((bullet) {
      bullet.removeFromParent();
    });
    
    // Reset wave manager
    waveManager.reset();
  }

  /// Go back to the main menu
  void goToMainMenu() {
    _gameState = GameState.menu;
    
    // Clear game state
    _score = 0;
    _finalScore = 0;
    _wavesSurvived = 0;
    
    // Reset player
    player.reset();
    
    // Clear all enemies
    enemyManager.clearAllEnemies();
    
    // Clear all bullets
    world.children.whereType<Bullet>().toList().forEach((bullet) {
      bullet.removeFromParent();
    });
    
    // Reset wave manager
    waveManager.reset();
    
    // Switch overlays
    overlays.remove('HUD');
    overlays.add('MainMenu');
  }
}
