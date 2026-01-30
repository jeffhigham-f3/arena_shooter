# Arena Shooter

A fast-paced, top-down arena shooter built with Flutter and the Flame game engine. Survive waves of enemies, master your aim, and achieve the highest score possible.

## 🎮 Game Overview

Arena Shooter is an action-packed survival game where you control a player character in a top-down arena. Face increasingly difficult waves of enemies, each with unique behaviors and attack patterns. Your goal is simple: survive as long as possible and rack up the highest score.

### Key Features

- **Wave-Based Gameplay**: Progress through increasingly challenging waves of enemies
- **Multiple Enemy Types**:
  - **Chasers**: Fast-moving melee enemies that rush toward you
  - **Shooters**: Ranged enemies that maintain distance and fire projectiles
- **Difficulty Levels**: Choose from Easy, Normal, or Hard to match your skill level
- **Dynamic Controls**:
  - Touch controls for mobile and web
  - Keyboard controls for desktop
- **Score System**: Earn points by defeating enemies and track your best performance
- **Health System**: Manage your health with invincibility frames after taking damage
- **Responsive Design**: Automatically adapts to different screen sizes and aspect ratios
- **Immersive UI**: Full-screen landscape gameplay with clean, modern overlays

## 📋 Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Building](#building)
- [Controls](#controls)
- [Game Mechanics](#game-mechanics)
- [Configuration](#configuration)
- [Development](#development)
- [Platform Support](#platform-support)
- [Contributing](#contributing)
- [Privacy](#privacy)
- [License](#license)

## 🔧 Requirements

- **Flutter SDK**: 3.9.2 or higher
- **Dart SDK**: Compatible with Flutter 3.9.2
- **Platform-specific requirements**:
  - **iOS**: Xcode 14.0+ (for iOS builds)
  - **Android**: Android Studio with Android SDK (for Android builds)
  - **Web**: Chrome, Firefox, Safari, or Edge (for web builds)
  - **Desktop**: Platform-specific build tools (for macOS, Windows, Linux)

## 📦 Installation

1. **Clone the repository**:

   ```bash
   git clone <repository-url>
   cd arena_shooter
   ```

2. **Install Flutter dependencies**:

   ```bash
   flutter pub get
   ```

3. **Verify Flutter setup**:

   ```bash
   flutter doctor
   ```

## 🏗️ Building

### Development Build

Run the game in debug mode:

```bash
flutter run
```

### Platform-Specific Builds

#### Web

```bash
flutter build web
```

The built files will be in `build/web/`. Serve them with any static web server.

#### Android

```bash
flutter build apk          # APK file
flutter build appbundle    # App Bundle for Play Store
```

#### iOS

```bash
flutter build ios
```

Open `ios/Runner.xcworkspace` in Xcode to configure signing and build.

#### macOS

```bash
flutter build macos
```

#### Windows

```bash
flutter build windows
```

#### Linux

```bash
flutter build linux
```

## 🎯 Controls

### Desktop/Web (Keyboard)

- **Movement**: `W` `A` `S` `D` or Arrow Keys
- **Aim**: Automatic (aims in movement direction)
- **Shoot**: `Space`
- **Pause**: Pause button in HUD

### Mobile (Touch)

- **Movement**: Left joystick (virtual D-pad)
- **Aim & Shoot**: Right joystick (aim direction determines shooting direction)
- **Pause**: Pause button in HUD

## 🎲 Game Mechanics

### Player

- **Health**: Varies by difficulty (75-150 HP)
- **Movement Speed**: 200 units/second
- **Fire Rate**: 5 shots per second
- **Invincibility**: Brief invincibility period after taking damage (varies by difficulty)

### Enemies

#### Chaser Enemy

- Fast-moving melee enemy
- Charges directly at the player
- Deals contact damage on collision
- **Score**: 10 points

#### Shooter Enemy

- Ranged enemy that maintains distance
- Fires projectiles at the player
- Moves to maintain optimal shooting distance
- **Score**: 25 points

### Waves

- Waves start after a 2-second delay
- Each wave increases in difficulty with more enemies
- Shooter enemies begin appearing from Wave 2
- 3-second pause between waves
- Enemy spawn rate and difficulty scale with selected difficulty level

### Scoring

- Defeat enemies to earn points
- Chaser enemies: 10 points each
- Shooter enemies: 25 points each
- Final score is displayed on the Game Over screen

## ⚙️ Configuration

Game settings can be modified in `lib/config/game_config.dart`:

- **Difficulty Settings**: Adjust enemy speed, health, damage, and spawn rates
- **Player Settings**: Movement speed, health, fire rate
- **Enemy Settings**: Speed, health, damage, and behavior parameters
- **Wave Settings**: Spawn delays, wave progression, enemy counts
- **Debug Options**: Enable hitbox visualization and debug info

### Difficulty Levels

- **Easy**: Slower enemies, less damage, more player health, longer invincibility
- **Normal**: Balanced gameplay (default)
- **Hard**: Faster enemies, more damage, less player health, shorter invincibility

## 💻 Development

### Project Structure

```
lib/
├── config/
│   └── game_config.dart      # Centralized game configuration
├── game/
│   ├── components/           # Game entities
│   │   ├── player.dart
│   │   ├── enemy.dart
│   │   ├── chaser_enemy.dart
│   │   ├── shooter_enemy.dart
│   │   ├── bullet.dart
│   │   └── touch_controls.dart
│   ├── managers/             # Game systems
│   │   ├── enemy_manager.dart
│   │   └── wave_manager.dart
│   ├── overlays/             # UI overlays
│   │   ├── main_menu.dart
│   │   ├── hud.dart
│   │   ├── pause_menu.dart
│   │   └── game_over.dart
│   └── my_game.dart          # Main game class
└── main.dart                 # App entry point
```

### Key Dependencies

- **flame**: ^1.34.0 - Game engine
- **flame_audio**: ^2.11.12 - Audio support
- **flutter**: SDK - UI framework

### Adding Assets

Place assets in the following directories:

- **Images**: `assets/images/`
- **Audio**: `assets/audio/`

Update `pubspec.yaml` if adding new asset directories.

### Debug Mode

Enable debug features in `game_config.dart`:

```dart
static const bool showDebugInfo = true;
static const bool showHitboxes = true;
```

## 🌐 Platform Support

Arena Shooter supports the following platforms:

- ✅ **Web** - Play in your browser
- ✅ **Android** - Mobile devices
- ✅ **iOS** - iPhone and iPad
- ✅ **macOS** - Desktop
- ✅ **Windows** - Desktop
- ✅ **Linux** - Desktop

### Platform-Specific Notes

- **Web**: Keyboard controls only (same as desktop)
- **Mobile**: Touch controls with virtual joysticks; landscape orientation is locked for optimal gameplay
- **Desktop**: Keyboard controls are available

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow Dart/Flutter style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions focused and single-purpose

## 🔒 Privacy

Arena Shooter respects your privacy. The app does not collect, store, or transmit any personal or usage data. For full details, see our [Privacy Policy](privacy.md).

## 📄 License

[Specify your license here]

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- Game engine powered by [Flame](https://flame-engine.org/)
- Audio support via [flame_audio](https://pub.dev/packages/flame_audio)
- App Icon via [IconKitchen](https://icon.kitchen/i/H4sIAAAAAAAAA0VQwU7DMAz9FWSuAzXrNkRvgABx3m4IITdx2kppU5K00zTt37FT0HKI45en5_d8hhndRBGqM9jmxTsfoILbjUa7LWAF9RVTu7UqibExPjcClErVj-sMvGXA5pOBQ5ccMfYUaMCbfet9opB_PrQfoEphopVMdN2IIcn4SFzAkMXJJaZ2mQg6-PE7_kwYCC5i6HAaRbkJaDoahFk37_-N6CQ_5jyFeCpsudlJEpUzoMK1ZCjuNw8LsqRiZRwasVyqLTeppZ4MVBZdZKN1s28xj9Vd0EwT76_Wkk48CmKLxh9FpPdmcrLOT9YzwXdGkvjI95FqvnvUS4dJt_mV5lz-6GmWLTk83XEOjvx1-QXK8eqPowEAAA)

---

**Enjoy the game and good luck surviving the arena!** 🎮
