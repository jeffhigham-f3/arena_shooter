import 'package:flame/components.dart';

import '../../config/game_config.dart';
import 'enemy_manager.dart';

/// Manages wave progression and difficulty scaling
class WaveManager extends Component {
  /// Reference to enemy manager
  final EnemyManager enemyManager;
  
  /// Current wave number
  int _currentWave = 0;
  
  /// Get current wave number
  int get currentWave => _currentWave;
  
  /// Number of enemies left to spawn in current wave
  int _enemiesToSpawn = 0;
  
  /// Chasers left to spawn
  int _chasersToSpawn = 0;
  
  /// Shooters left to spawn
  int _shootersToSpawn = 0;
  
  /// Timer for spawn delays
  double _spawnTimer = 0;
  
  /// Timer for wave pause
  double _wavePauseTimer = 0;
  
  /// Whether we're currently in a wave pause
  bool _inWavePause = false;
  
  /// Whether all waves are complete (never true - infinite waves)
  bool get isComplete => false;
  
  /// Whether currently spawning enemies
  bool get isSpawning => _enemiesToSpawn > 0;

  WaveManager({required this.enemyManager});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Start with initial delay before first wave
    _wavePauseTimer = GameConfig.waveStartDelay;
    _inWavePause = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Handle wave pause
    if (_inWavePause) {
      _wavePauseTimer -= dt;
      if (_wavePauseTimer <= 0) {
        _inWavePause = false;
        _startNextWave();
      }
      return;
    }
    
    // Handle enemy spawning
    if (_enemiesToSpawn > 0) {
      _spawnTimer -= dt;
      if (_spawnTimer <= 0) {
        _spawnNextEnemy();
        _spawnTimer = GameConfig.enemySpawnDelay;
      }
    }
    
    // Check for wave completion
    if (!isSpawning && enemyManager.allEnemiesDead && _currentWave > 0) {
      // Wave complete - start pause before next wave
      _inWavePause = true;
      _wavePauseTimer = GameConfig.wavePauseDuration;
    }
  }

  /// Start the next wave
  void _startNextWave() {
    _currentWave++;
    
    // Calculate enemy counts for this wave
    _chasersToSpawn = GameConfig.baseChaseCount + 
        ((_currentWave - 1) * GameConfig.chaserIncreasePerWave);
    
    if (_currentWave >= GameConfig.shooterStartWave) {
      _shootersToSpawn = GameConfig.baseShooterCount + 
          ((_currentWave - GameConfig.shooterStartWave + 1) * GameConfig.shooterIncreasePerWave);
    } else {
      _shootersToSpawn = 0;
    }
    
    _enemiesToSpawn = _chasersToSpawn + _shootersToSpawn;
    _spawnTimer = 0; // Spawn first enemy immediately
  }

  /// Spawn the next enemy in the queue
  void _spawnNextEnemy() {
    if (_chasersToSpawn > 0) {
      enemyManager.spawnEnemy(EnemyType.chaser);
      _chasersToSpawn--;
    } else if (_shootersToSpawn > 0) {
      enemyManager.spawnEnemy(EnemyType.shooter);
      _shootersToSpawn--;
    }
    _enemiesToSpawn--;
  }

  /// Reset wave manager for new game
  void reset() {
    _currentWave = 0;
    _enemiesToSpawn = 0;
    _chasersToSpawn = 0;
    _shootersToSpawn = 0;
    _spawnTimer = 0;
    _wavePauseTimer = GameConfig.waveStartDelay;
    _inWavePause = true;
  }
}
