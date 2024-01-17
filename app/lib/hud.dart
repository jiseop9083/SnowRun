import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:app/game_screen.dart';

class Hud extends PositionComponent with HasGameRef<SnowManGame> {
  Hud() {
    final textPaint = TextPaint(style: textStyle);
    textComponent = TextComponent(textRenderer: textPaint);
    final gameoverTextPaint = TextPaint(style: gameOverText);
    gameOverTextComponent = TextComponent(textRenderer: gameoverTextPaint);
    gameOverTextComponent.x = 380;
    gameOverTextComponent.y = 200;
    gameOverTextComponent.text = "Game Over";

    final scoreTextPaint = TextPaint(style: scoreText);
    scoreTextComponent = TextComponent(textRenderer: scoreTextPaint);
    scoreTextComponent.x = 580;
    scoreTextComponent.y = 440;
    add(textComponent);
    //add(gameOverTextComponent);
    x = 64;
    y = 32;
  }

  late final TextComponent textComponent;
  late final TextComponent gameOverTextComponent;
  late final TextComponent scoreTextComponent;
  late final CameraComponent cameraComponent;
  bool isOver = false;

  static const textStyle = TextStyle(
    fontSize: 64,
    fontFamily: 'main',
    color: Colors.white,
  );

  static const gameOverText = TextStyle(
    fontSize: 224,
    fontFamily: 'main',
    color: Colors.yellowAccent,
  );

  static const scoreText = TextStyle(
    fontSize: 128,
    fontFamily: 'main',
    color: Colors.white,
  );

  @override
  void update(double dt) {
    super.update(dt);
    if (!gameRef.player.isStop)
      textComponent.text = 'Time: ${gameRef.player.playTime.toInt()}';
    if (!isOver && gameRef.player.isStop) {
      scoreTextComponent.text = 'Score: ${gameRef.player.playTime.toInt()}';
      showGameOver();
      isOver = true;
    }
    if (isOver && !gameRef.player.isStop) {
      removeGameOver();
      isOver = false;
    }
  }

  void showGameOver() {
    add(gameOverTextComponent);
    add(scoreTextComponent);
  }

  void removeGameOver() {
    remove(gameOverTextComponent);
    remove(scoreTextComponent);
  }
}
