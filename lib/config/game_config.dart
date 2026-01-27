/// Difficulty levels for the game
enum Difficulty { easy, normal, hard }

/// Settings that vary by difficulty level
class DifficultySettings {
  final String name;
  final double enemySpeedMultiplier;
  final double enemyDamageMultiplier;
  final double enemyHealthMultiplier;
  final double spawnRateMultiplier;
  final int playerMaxHealth;
  final double playerInvincibilityDuration;

  const DifficultySettings({
    required this.name,
    required this.enemySpeedMultiplier,
    required this.enemyDamageMultiplier,
    required this.enemyHealthMultiplier,
    required this.spawnRateMultiplier,
    required this.playerMaxHealth,
    required this.playerInvincibilityDuration,
  });

  static const easy = DifficultySettings(
    name: 'Easy',
    enemySpeedMultiplier: 0.7,
    enemyDamageMultiplier: 0.5,
    enemyHealthMultiplier: 0.8,
    spawnRateMultiplier: 0.7,
    playerMaxHealth: 150,
    playerInvincibilityDuration: 1.5,
  );

  static const normal = DifficultySettings(
    name: 'Normal',
    enemySpeedMultiplier: 1.0,
    enemyDamageMultiplier: 1.0,
    enemyHealthMultiplier: 1.0,
    spawnRateMultiplier: 1.0,
    playerMaxHealth: 100,
    playerInvincibilityDuration: 1.0,
  );

  static const hard = DifficultySettings(
    name: 'Hard',
    enemySpeedMultiplier: 1.3,
    enemyDamageMultiplier: 1.5,
    enemyHealthMultiplier: 1.5,
    spawnRateMultiplier: 1.3,
    playerMaxHealth: 75,
    playerInvincibilityDuration: 0.5,
  );

  static DifficultySettings fromDifficulty(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return easy;
      case Difficulty.normal:
        return normal;
      case Difficulty.hard:
        return hard;
    }
  }
}

/// Game configuration constants
/// Centralized location for all game settings
class GameConfig {
  // Prevent instantiation
  GameConfig._();

  // Current difficulty settings (can be changed at runtime)
  static DifficultySettings _difficultySettings = DifficultySettings.normal;
  
  /// Get current difficulty settings
  static DifficultySettings get difficultySettings => _difficultySettings;
  
  /// Set difficulty
  static void setDifficulty(Difficulty difficulty) {
    _difficultySettings = DifficultySettings.fromDifficulty(difficulty);
  }

  // Game window settings
  static const String gameTitle = 'Arena Shooter';
  static const double gameWidth = 800;
  static const double gameHeight = 600;

  // Player settings
  static const double playerSpeed = 200.0;
  static const double playerSize = 50.0;
  static int get playerMaxHealth => _difficultySettings.playerMaxHealth;
  static double get playerInvincibilityDuration => _difficultySettings.playerInvincibilityDuration;

  // Bullet settings
  static const double bulletSpeed = 400.0;
  static const double bulletSize = 8.0;
  static const double playerFireRate = 5.0; // shots per second
  static const double enemyFireRate = 1.0; // shots per second
  static const int bulletDamage = 50; // damage per bullet hit

  // Base chaser enemy settings (before difficulty multipliers)
  static const double _baseChaserSpeed = 120.0;
  static const double chaserSize = 40.0;
  static const int _baseChaserHealth = 1;
  static const int _baseChaserDamage = 20;
  static const int chaserScore = 10;

  // Chaser settings with difficulty applied
  static double get chaserSpeed => _baseChaserSpeed * _difficultySettings.enemySpeedMultiplier;
  static int get chaserHealth => (_baseChaserHealth * _difficultySettings.enemyHealthMultiplier).ceil();
  static int get chaserDamage => (_baseChaserDamage * _difficultySettings.enemyDamageMultiplier).round();

  // Base shooter enemy settings (before difficulty multipliers)
  static const double _baseShooterSpeed = 60.0;
  static const double shooterSize = 45.0;
  static const int _baseShooterHealth = 2;
  static const int _baseShooterDamage = 15;
  static const int shooterScore = 25;
  static const double shooterPreferredDistance = 200.0;

  // Shooter settings with difficulty applied
  static double get shooterSpeed => _baseShooterSpeed * _difficultySettings.enemySpeedMultiplier;
  static int get shooterHealth => (_baseShooterHealth * _difficultySettings.enemyHealthMultiplier).ceil();
  static int get shooterDamage => (_baseShooterDamage * _difficultySettings.enemyDamageMultiplier).round();

  // Wave settings
  static const double waveStartDelay = 2.0; // seconds before first wave
  static const double wavePauseDuration = 3.0; // seconds between waves
  static const double _baseEnemySpawnDelay = 0.5; // seconds between enemy spawns
  static double get enemySpawnDelay => _baseEnemySpawnDelay / _difficultySettings.spawnRateMultiplier;
  
  static const int _baseChaseCount = 5; // chasers in wave 1
  static const int _baseShooterCount = 0; // shooters in wave 1
  static int get baseChaseCount => (_baseChaseCount * _difficultySettings.spawnRateMultiplier).round();
  static int get baseShooterCount => _baseShooterCount;
  
  static const int _baseChaserIncreasePerWave = 2;
  static const int _baseShooterIncreasePerWave = 2;
  static int get chaserIncreasePerWave => (_baseChaserIncreasePerWave * _difficultySettings.spawnRateMultiplier).round();
  static int get shooterIncreasePerWave => (_baseShooterIncreasePerWave * _difficultySettings.spawnRateMultiplier).round();
  
  static const int shooterStartWave = 2; // wave when shooters start appearing

  // Physics settings
  static const double gravity = 980.0;
  static const double friction = 0.9;

  // Debug settings
  static const bool showDebugInfo = false;
  static const bool showHitboxes = false;
}
