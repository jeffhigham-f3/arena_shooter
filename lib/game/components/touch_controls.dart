import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import '../my_game.dart';

/// Touch controls with dual virtual joysticks
/// Left joystick: Movement
/// Right joystick: Aim direction + shooting
class TouchControls extends Component with HasGameReference<MyGame> {
  /// Left joystick for movement
  late JoystickComponent moveJoystick;
  
  /// Right joystick for aiming/shooting
  late JoystickComponent aimJoystick;
  
  /// Size of the joystick background
  static const double joystickSize = 60.0;
  
  /// Size of the joystick knob
  static const double knobSize = 30.0;
  
  /// Margin from screen edges
  static const double margin = 40.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Create joystick paint styles
    final knobPaint = BasicPalette.white.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.white.withAlpha(80).paint();
    
    // Left joystick - movement (bottom left)
    moveJoystick = JoystickComponent(
      knob: CircleComponent(
        radius: knobSize,
        paint: knobPaint,
      ),
      background: CircleComponent(
        radius: joystickSize,
        paint: backgroundPaint,
      ),
      margin: const EdgeInsets.only(left: margin, bottom: margin),
    );
    
    // Right joystick - aim/shoot (bottom right)
    aimJoystick = JoystickComponent(
      knob: CircleComponent(
        radius: knobSize,
        paint: Paint()..color = const Color(0xCC00FFFF), // Cyan tint for shooting
      ),
      background: CircleComponent(
        radius: joystickSize,
        paint: Paint()..color = const Color(0x5000FFFF),
      ),
      margin: const EdgeInsets.only(right: margin, bottom: margin),
    );
    
    // Add joysticks to the game's camera viewport (so they stay fixed on screen)
    game.camera.viewport.add(moveJoystick);
    game.camera.viewport.add(aimJoystick);
  }

  @override
  void onRemove() {
    // Clean up joysticks when this component is removed
    moveJoystick.removeFromParent();
    aimJoystick.removeFromParent();
    super.onRemove();
  }

  /// Get the movement direction from the left joystick
  Vector2 get moveDirection => moveJoystick.relativeDelta;
  
  /// Get the aim direction from the right joystick
  Vector2 get aimDirection => aimJoystick.relativeDelta;
  
  /// Check if the aim joystick is being used (for shooting)
  bool get isShooting => !aimJoystick.delta.isZero();
  
  /// Check if the move joystick is being used
  bool get isMoving => !moveJoystick.delta.isZero();
}
