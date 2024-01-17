import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';
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

    final restartTextPaint = TextPaint(style: restartText);
    restartTextComponent = TextComponent(textRenderer: restartTextPaint);
    restartTextComponent.x = 730;
    restartTextComponent.y = 800;
    restartTextComponent.text = "Restart";
    //add(gameOverTextComponent);
    x = 64;
    y = 32;

    // addTapHandler(
    //   onTapUp: (event) {
    //     final Vector2 tapPosition = event.eventPosition.game;
    //     // restartTextComponent를 터치한 경우
    //     if (restartTextComponent.toRect().contains(tapPosition)) {
    //       // 여기에서 다른 페이지로 이동하는 코드를 작성
    //       print('Restart Text Clicked!');
    //       // 예를 들어, 현재 게임 페이지를 떠날 때 Navigator를 사용하여 다른 페이지로 이동할 수 있습니다.
    //       // Navigator.push(
    //       //   gameRef.context,
    //       //   MaterialPageRoute(builder: (context) => YourNextPage()),
    //       // );
    //     }
    //   },
    // );
  }

  late final TextComponent textComponent;
  late final TextComponent gameOverTextComponent;
  late final TextComponent scoreTextComponent;
  late final TextComponent restartTextComponent;
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

  static const restartText = TextStyle(
    fontSize: 96,
    fontFamily: 'main',
    color: Colors.red,
  );

  @override
  void update(double dt) {
    super.update(dt);
    if (!gameRef.player.isStop) textComponent.text = 'Score: ${getScore()}';
    if (!isOver && gameRef.player.isStop) {
      scoreTextComponent.text = 'Score: ${getScore()}';
      showGameOver();
      isOver = true;
    }
    if (isOver && !gameRef.player.isStop) {
      removeGameOver();
      isOver = false;
    }
  }

  int getScore() {
    double playTime = gameRef.player.playTime;
    double dis = gameRef.player.dis;
    if (playTime == 0) return 0;
    return (dis / playTime).toInt();
  }

  void showGameOver() {
    add(gameOverTextComponent);
    add(scoreTextComponent);
    add(restartTextComponent);
  }

  void removeGameOver() {
    remove(gameOverTextComponent);
    remove(scoreTextComponent);
    remove(restartTextComponent);
  }
}
