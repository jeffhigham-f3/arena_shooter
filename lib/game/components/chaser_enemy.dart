import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../config/game_config.dart';
import 'enemy.dart';

/// Chaser enemy that moves directly toward the player
/// Damages player on contact
class ChaserEnemy extends Enemy {
  ChaserEnemy({required super.position})
      : super(
          size: Vector2.all(GameConfig.chaserSize),
          speed: GameConfig.chaserSpeed,
          health: GameConfig.chaserHealth,
          contactDamage: GameConfig.chaserDamage,
          scoreValue: GameConfig.chaserScore,
          color: const Color(0xFFE53935), // Red
          borderColor: const Color(0xFFFF6659), // Light red
        );

  @override
  void updateBehavior(double dt) {
    // Calculate direction to player
    final direction = playerPosition - position;
    
    if (direction.length > 0) {
      direction.normalize();
      
      // Move toward player
      position += direction * speed * dt;
    }
  }
}
