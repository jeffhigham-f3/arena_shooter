import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../my_game.dart';
import 'player.dart';

/// Base class for all enemy types
/// Provides common functionality: health, hitbox, damage, and score
abstract class Enemy extends PositionComponent with CollisionCallbacks, HasGameReference<MyGame> {
  /// Enemy speed
  final double speed;
  
  /// Enemy health (hits to kill)
  int _health;
  
  /// Damage dealt to player on contact
  final int contactDamage;
  
  /// Score awarded when killed
  final int scoreValue;
  
  /// Color for rendering
  final Color color;
  
  /// Border color for rendering
  final Color borderColor;

  Enemy({
    required Vector2 position,
    required Vector2 size,
    required this.speed,
    required int health,
    required this.contactDamage,
    required this.scoreValue,
    required this.color,
    required this.borderColor,
  }) : _health = health,
       super(
         position: position,
         size: size,
         anchor: Anchor.center,
       );

  /// Get current health
  int get health => _health;
  
  /// Check if enemy is alive
  bool get isAlive => _health > 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add hitbox for collision detection
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (!isAlive) return;
    
    // Subclasses implement specific behavior
    updateBehavior(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw enemy as a colored rectangle
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(4),
      ),
      paint,
    );

    // Draw border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(4),
      ),
      borderPaint,
    );
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    
    // Damage player on contact
    if (other is Player && contactDamage > 0) {
      other.takeDamage(contactDamage);
    }
  }

  /// Take damage from a bullet or other source
  void takeDamage(int damage) {
    if (!isAlive) return;
    
    _health -= damage;
    
    if (_health <= 0) {
      _health = 0;
      _onDeath();
    }
  }

  /// Called when the enemy dies
  void _onDeath() {
    game.addScore(scoreValue);
    game.enemyManager.onEnemyKilled(this);
    removeFromParent();
  }

  /// Abstract method for subclass-specific behavior
  void updateBehavior(double dt);
  
  /// Get the player position for AI targeting
  Vector2 get playerPosition => game.player.position;
}
