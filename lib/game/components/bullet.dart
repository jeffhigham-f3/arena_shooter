import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../config/game_config.dart';
import '../my_game.dart';
import 'enemy.dart';
import 'player.dart';

/// Bullet component for both player and enemy projectiles
/// Uses collision detection to damage appropriate targets
class Bullet extends PositionComponent with CollisionCallbacks, HasGameReference<MyGame> {
  /// Direction the bullet travels (normalized)
  final Vector2 direction;
  
  /// Whether this bullet was fired by the player
  final bool isPlayerBullet;
  
  /// Damage dealt by this bullet
  final int damage;
  
  /// How long the bullet lives before disappearing (seconds)
  static double get maxLifespan => GameConfig.bulletLifespan;
  
  /// Time this bullet has been alive
  double _lifespan = 0;

  Bullet({
    required Vector2 position,
    required this.direction,
    required this.isPlayerBullet,
    this.damage = GameConfig.bulletDamage,
  }) : super(
          position: position,
          size: Vector2.all(GameConfig.bulletSize),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add circular hitbox for collision detection
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Track lifespan and remove if expired
    _lifespan += dt;
    if (_lifespan >= maxLifespan) {
      removeFromParent();
      return;
    }
    
    // Move bullet in its direction
    position += direction * GameConfig.bulletSpeed * dt;
    
    // Wrap position (Asteroids-style)
    _wrapPosition();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw bullet as a colored circle
    final paint = Paint()
      ..color = isPlayerBullet 
          ? const Color(0xFF00FFFF) // Cyan for player bullets
          : const Color(0xFFFF6600) // Orange for enemy bullets
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );
    
    // Add glow effect
    final glowPaint = Paint()
      ..color = (isPlayerBullet 
          ? const Color(0xFF00FFFF) 
          : const Color(0xFFFF6600)).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2 + 2,
      glowPaint,
    );
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    
    if (isPlayerBullet) {
      // Player bullets damage enemies
      if (other is Enemy) {
        other.takeDamage(damage);
        removeFromParent();
      }
    } else {
      // Enemy bullets damage player
      if (other is Player) {
        other.takeDamage(damage);
        removeFromParent();
      }
    }
  }

  /// Wrap bullet position to opposite side (Asteroids-style)
  void _wrapPosition() {
    final halfWidth = game.worldWidth / 2;
    final halfHeight = game.worldHeight / 2;
    final buffer = size.x / 2;

    // Wrap horizontally
    if (position.x < -halfWidth - buffer) {
      position.x = halfWidth + buffer;
    } else if (position.x > halfWidth + buffer) {
      position.x = -halfWidth - buffer;
    }

    // Wrap vertically
    if (position.y < -halfHeight - buffer) {
      position.y = halfHeight + buffer;
    } else if (position.y > halfHeight + buffer) {
      position.y = -halfHeight - buffer;
    }
  }
}
