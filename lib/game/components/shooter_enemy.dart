import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../config/game_config.dart';
import 'bullet.dart';
import 'enemy.dart';

/// Shooter enemy that maintains distance and fires bullets at the player
class ShooterEnemy extends Enemy {
  /// Timer for shooting cooldown
  double _shootCooldown = 0;
  
  /// Time between shots
  double get _shootInterval => 1.0 / GameConfig.enemyFireRate;

  ShooterEnemy({required super.position})
      : super(
          size: Vector2.all(GameConfig.shooterSize),
          speed: GameConfig.shooterSpeed,
          health: GameConfig.shooterHealth,
          contactDamage: GameConfig.shooterDamage,
          scoreValue: GameConfig.shooterScore,
          color: const Color(0xFF7B1FA2), // Purple
          borderColor: const Color(0xFFBA68C8), // Light purple
        );

  @override
  void updateBehavior(double dt) {
    // Update shoot cooldown
    if (_shootCooldown > 0) {
      _shootCooldown -= dt;
    }

    // Calculate direction to player
    final toPlayer = playerPosition - position;
    final distanceToPlayer = toPlayer.length;
    
    if (distanceToPlayer > 0) {
      toPlayer.normalize();
      
      // Move to maintain preferred distance from player
      if (distanceToPlayer > GameConfig.shooterPreferredDistance + 20) {
        // Too far - move toward player
        position += toPlayer * speed * dt;
      } else if (distanceToPlayer < GameConfig.shooterPreferredDistance - 20) {
        // Too close - move away from player
        position -= toPlayer * speed * dt;
      } else {
        // At good distance - strafe slightly to make it harder to hit
        final perpendicular = Vector2(-toPlayer.y, toPlayer.x);
        position += perpendicular * speed * 0.5 * dt;
      }
      
      // Shoot at player if cooldown allows
      if (_shootCooldown <= 0) {
        _shoot(toPlayer);
      }
    }
    
    // Keep enemy within bounds
    _clampPosition();
  }

  /// Shoot a bullet toward the player
  void _shoot(Vector2 direction) {
    _shootCooldown = _shootInterval;
    
    // Create bullet at enemy position
    final bulletOffset = direction.clone() * (size.x / 2 + GameConfig.bulletSize);
    final bullet = Bullet(
      position: position + bulletOffset,
      direction: direction.clone(),
      isPlayerBullet: false,
      damage: GameConfig.shooterDamage,
    );
    
    game.world.add(bullet);
  }

  /// Keep enemy within game bounds
  void _clampPosition() {
    final halfWidth = size.x / 2;
    final halfHeight = size.y / 2;
    final gameHalfWidth = game.worldWidth / 2;
    final gameHalfHeight = game.worldHeight / 2;

    position.x = position.x.clamp(
      -gameHalfWidth + halfWidth,
      gameHalfWidth - halfWidth,
    );
    position.y = position.y.clamp(
      -gameHalfHeight + halfHeight,
      gameHalfHeight - halfHeight,
    );
  }
}
