// game_screen.dart
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:app/levels/level.dart';

class SnowManGame extends FlameGame with TapCallbacks {
  late final CameraComponent cam;

  final world = Level();

  late Player player;

  @override
  Future<void> onLoad() async {
    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;
    player = Player(
      position: Vector2(size.x * 0.75, size.y - 20),
    );
    addAll([cam, world, player]); // DOTO: insert world, cam
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!event.handled) {
      final touchPoint = event.canvasPosition;
      if (touchPoint.x > size.x / 2) {
        player.position = Vector2(size.x * 0.75, size.y * 0.5);
      } else {
        player.position = Vector2(size.x * 0.25, size.y * 0.5);
      }
    }
  }

  // @override
  // void render(Canvas canvas) {
  //   // canvas.drawRect(
  //   //   Rect.fromLTWH(0, 0, size.x, size.y),
  //   //   Paint()..color = Colors.blue,
  //   // );
  //   super.render(canvas);
  //   cam.render(canvas);
  //   player.render(canvas);

  //   // 다른 그래픽 요소들을 그릴 수 있습니다.
  //   // 예: drawRect, drawCircle 등
  // }
}

class Player extends RectangleComponent {
  static const playerSize = 80.0;

  Player({
    required position,
    Color color = const Color(0xffffff00),
  }) : super(
          position: position,
          size: Vector2.all(playerSize),
          anchor: Anchor.bottomCenter,
          paint: Paint()..color = color,
        );
}
