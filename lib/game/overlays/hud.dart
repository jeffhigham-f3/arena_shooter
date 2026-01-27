import 'dart:async';

import 'package:flutter/material.dart';

import '../my_game.dart';

/// Heads-up display overlay
/// Shows game information like score, health, wave number, etc.
class HUD extends StatefulWidget {
  final MyGame game;

  const HUD({super.key, required this.game});

  @override
  State<HUD> createState() => _HUDState();
}

class _HUDState extends State<HUD> {
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    // Update HUD periodically to reflect game state
    _updateTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Score, Wave, Pause button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Score and Wave
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Score display
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Score: ${widget.game.score}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Wave display
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Wave: ${widget.game.waveManager.currentWave}',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // Right side: Difficulty and Pause button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Pause button
                  IconButton(
                    onPressed: widget.game.pauseGame,
                    icon: const Icon(
                      Icons.pause_circle_filled,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  // Difficulty display
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.game.difficultyName.toUpperCase(),
                      style: TextStyle(
                        color: _getDifficultyColor(),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Bottom: Health bar
          _buildHealthBar(),
        ],
      ),
    );
  }

  Color _getDifficultyColor() {
    switch (widget.game.difficultyName) {
      case 'Easy':
        return Colors.green;
      case 'Normal':
        return Colors.amber;
      case 'Hard':
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  Widget _buildHealthBar() {
    final player = widget.game.player;
    final healthPercent = player.health / player.maxHealth;
    
    // Health bar color based on health level
    Color healthColor;
    if (healthPercent > 0.6) {
      healthColor = Colors.green;
    } else if (healthPercent > 0.3) {
      healthColor = Colors.orange;
    } else {
      healthColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                '${player.health}/${player.maxHealth}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            width: 150,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[600]!, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: healthPercent.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: healthColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
