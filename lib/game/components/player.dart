import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/game_config.dart';
import '../my_game.dart';
import 'bullet.dart';

/// Player component that handles player movement, shooting, health, and rendering
class Player extends PositionComponent with KeyboardHandler, CollisionCallbacks, HasGameReference<MyGame> {
  Player()
      : super(
          size: Vector2.all(GameConfig.playerSize),
          anchor: Anchor.center,
        );

  /// Movement direction based on input
  final Vector2 _velocity = Vector2.zero();

  /// Track which keys are currently pressed
  final Set<LogicalKeyboardKey> _keysPressed = {};

  /// Current health
  int _health = GameConfig.playerMaxHealth;
  
  /// Get current health
  int get health => _health;
  
  /// Get max health
  int get maxHealth => GameConfig.playerMaxHealth;
  
  /// Check if player is alive
  bool get isAlive => _health > 0;

  /// Shooting cooldown timer
  double _shootCooldown = 0;
  
  /// Time between shots (based on fire rate)
  double get _shootInterval => 1.0 / GameConfig.playerFireRate;

  /// Invincibility timer (after taking damage)
  double _invincibilityTimer = 0;
  
  /// Check if currently invincible
  bool get isInvincible => _invincibilityTimer > 0;

  /// Direction player is aiming (for shooting)
  final Vector2 _aimDirection = Vector2(1, 0); // Default: right

  /// Joystick input for movement (set by touch controls)
  Vector2 _joystickMoveInput = Vector2.zero();
  
  /// Joystick input for aiming (set by touch controls)
  Vector2 _joystickAimInput = Vector2.zero();
  
  /// Whether shooting via joystick
  bool _joystickShooting = false;

  /// Set joystick movement input (called from touch controls)
  void setJoystickMove(Vector2 direction) {
    _joystickMoveInput = direction;
  }

  /// Set joystick aim input and shooting state (called from touch controls)
  void setJoystickAim(Vector2 direction, bool shooting) {
    _joystickAimInput = direction;
    _joystickShooting = shooting;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Start player in center of game world
    position = Vector2.zero();
    
    // Add hitbox for collision detection
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update cooldowns
    if (_shootCooldown > 0) {
      _shootCooldown -= dt;
    }
    if (_invincibilityTimer > 0) {
      _invincibilityTimer -= dt;
    }

    // Calculate velocity based on keyboard input
    _velocity.setZero();

    if (_keysPressed.contains(LogicalKeyboardKey.keyW) ||
        _keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      _velocity.y -= 1;
    }
    if (_keysPressed.contains(LogicalKeyboardKey.keyS) ||
        _keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      _velocity.y += 1;
    }
    if (_keysPressed.contains(LogicalKeyboardKey.keyA) ||
        _keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      _velocity.x -= 1;
    }
    if (_keysPressed.contains(LogicalKeyboardKey.keyD) ||
        _keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      _velocity.x += 1;
    }

    // Add joystick movement input (if any)
    if (_joystickMoveInput.length > 0.1) {
      _velocity.setFrom(_joystickMoveInput);
    }

    // Normalize diagonal movement
    if (_velocity.length > 1) {
      _velocity.normalize();
    }

    // Update aim direction based on input
    if (_velocity.length > 0) {
      // If moving with keyboard (no joystick aim), aim in move direction
      if (_joystickAimInput.length < 0.1) {
        _aimDirection.setFrom(_velocity);
        _aimDirection.normalize();
      }
    }

    // Joystick aim overrides movement-based aim
    if (_joystickAimInput.length > 0.1) {
      _aimDirection.setFrom(_joystickAimInput);
      _aimDirection.normalize();
    }

    // Apply movement
    position += _velocity * GameConfig.playerSpeed * dt;

    // Wrap player position (Asteroids-style)
    _wrapPosition();

    // Handle shooting (keyboard spacebar or joystick aim)
    final wantsToShoot = _keysPressed.contains(LogicalKeyboardKey.space) || _joystickShooting;
    if (wantsToShoot && _shootCooldown <= 0) {
      _shoot();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Flash effect when invincible
    final isFlashing = isInvincible && ((_invincibilityTimer * 10).toInt() % 2 == 0);
    
    // Draw player as a colored rectangle
    final paint = Paint()
      ..color = isFlashing 
          ? const Color(0xFFFFFFFF).withValues(alpha: 0.5) 
          : const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(8),
      ),
      paint,
    );

    // Draw border
    final borderPaint = Paint()
      ..color = isFlashing 
          ? const Color(0xFFFFFFFF) 
          : const Color(0xFF81C784)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(8),
      ),
      borderPaint,
    );

    // Draw aim direction indicator
    final centerX = size.x / 2;
    final centerY = size.y / 2;
    final indicatorLength = size.x / 2 + 10;
    
    final indicatorPaint = Paint()
      ..color = const Color(0xFF00FFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(
        centerX + _aimDirection.x * indicatorLength,
        centerY + _aimDirection.y * indicatorLength,
      ),
      indicatorPaint,
    );
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _keysPressed.clear();
    _keysPressed.addAll(keysPressed);
    return true;
  }

  /// Shoot a bullet in the aim direction
  void _shoot() {
    _shootCooldown = _shootInterval;
    
    // Create bullet at player position, offset in aim direction
    final bulletOffset = _aimDirection.clone() * (size.x / 2 + GameConfig.bulletSize);
    final bullet = Bullet(
      position: position + bulletOffset,
      direction: _aimDirection.clone(),
      isPlayerBullet: true,
    );
    
    game.world.add(bullet);
  }

  /// Take damage from an enemy or bullet
  void takeDamage(int damage) {
    if (isInvincible || !isAlive) return;
    
    _health -= damage;
    _invincibilityTimer = GameConfig.playerInvincibilityDuration;
    
    if (_health <= 0) {
      _health = 0;
      game.onPlayerDeath();
    }
  }

  /// Reset player state for new game
  void reset() {
    position = Vector2.zero();
    _health = GameConfig.playerMaxHealth;
    _invincibilityTimer = 0;
    _shootCooldown = 0;
    _aimDirection.setValues(1, 0);
    _joystickMoveInput = Vector2.zero();
    _joystickAimInput = Vector2.zero();
    _joystickShooting = false;
  }

  /// Wrap player position to opposite side (Asteroids-style)
  void _wrapPosition() {
    final gameHalfWidth = game.worldWidth / 2;
    final gameHalfHeight = game.worldHeight / 2;
    final buffer = size.x / 2; // Small buffer so player fully exits before appearing

    // Wrap horizontally
    if (position.x < -gameHalfWidth - buffer) {
      position.x = gameHalfWidth + buffer;
    } else if (position.x > gameHalfWidth + buffer) {
      position.x = -gameHalfWidth - buffer;
    }

    // Wrap vertically
    if (position.y < -gameHalfHeight - buffer) {
      position.y = gameHalfHeight + buffer;
    } else if (position.y > gameHalfHeight + buffer) {
      position.y = -gameHalfHeight - buffer;
    }
  }
}
