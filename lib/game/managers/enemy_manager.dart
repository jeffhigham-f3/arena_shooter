import 'dart:math';

import 'package:flame/components.dart';

import '../../config/game_config.dart';
import '../components/chaser_enemy.dart';
import '../components/enemy.dart';
import '../components/shooter_enemy.dart';
import '../my_game.dart';

/// Enum for enemy types
enum EnemyType { chaser, shooter }

/// Manages enemy spawning and tracking
class EnemyManager extends Component with HasGameReference<MyGame> {
  /// Random number generator for spawn positions
  final Random _random = Random();
  
  /// List of currently active enemies
  final List<Enemy> _activeEnemies = [];
  
  /// Get count of active enemies
  int get enemyCount => _activeEnemies.length;
  
  /// Check if all enemies are dead
  bool get allEnemiesDead => _activeEnemies.isEmpty;

  /// Spawn an enemy of the specified type at a random edge position
  void spawnEnemy(EnemyType type) {
    final position = _getRandomEdgePosition();
    
    Enemy enemy;
    switch (type) {
      case EnemyType.chaser:
        enemy = ChaserEnemy(position: position);
        break;
      case EnemyType.shooter:
        enemy = ShooterEnemy(position: position);
        break;
    }
    
    _activeEnemies.add(enemy);
    game.world.add(enemy);
  }

  /// Called when an enemy is killed
  void onEnemyKilled(Enemy enemy) {
    _activeEnemies.remove(enemy);
  }

  /// Remove all enemies from the game
  void clearAllEnemies() {
    for (final enemy in _activeEnemies.toList()) {
      enemy.removeFromParent();
    }
    _activeEnemies.clear();
  }

  /// Get a random position along the edge of the game area
  Vector2 _getRandomEdgePosition() {
    final halfWidth = GameConfig.gameWidth / 2;
    final halfHeight = GameConfig.gameHeight / 2;
    
    // Choose a random edge (0 = top, 1 = right, 2 = bottom, 3 = left)
    final edge = _random.nextInt(4);
    
    double x, y;
    
    switch (edge) {
      case 0: // Top
        x = _random.nextDouble() * GameConfig.gameWidth - halfWidth;
        y = -halfHeight;
        break;
      case 1: // Right
        x = halfWidth;
        y = _random.nextDouble() * GameConfig.gameHeight - halfHeight;
        break;
      case 2: // Bottom
        x = _random.nextDouble() * GameConfig.gameWidth - halfWidth;
        y = halfHeight;
        break;
      case 3: // Left
      default:
        x = -halfWidth;
        y = _random.nextDouble() * GameConfig.gameHeight - halfHeight;
        break;
    }
    
    return Vector2(x, y);
  }
}
