// game_screen.dart
import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:leap/leap.dart';

import 'package:app/map/Level.dart';
import 'package:app/Components/Player.dart';
import 'package:app/util/AudioManager.dart';
import 'package:app/hud.dart';

class SnowManGame extends LeapGame with TapCallbacks, HasGameRef {
  SnowManGame({
    required super.tileSize,
  });

  late CameraComponent cam; // finl
  Player player = Player();
  Hud hud = Hud();
  AudioManager audioManager = AudioManager();

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final world = Level(player: player);
    cam = CameraComponent.withFixedResolution(
      world: world,
      width: tileSize * 29,
      height: tileSize * 18,
    );
    cam.viewfinder.anchor = Anchor.topCenter;

    cam.viewport.add(hud);
    cam.follow(player, horizontalOnly: true);

    addAll([cam, world]); //player
    audioManager.initialize();
    audioManager.playMainBGM();
    return super.onLoad();
  }

  // DO TO: 터치 후 이동하면 취소 안됨
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    final touchPoint = event.canvasPosition;
    if (hud.isOver &&
        310 < touchPoint.x &&
        touchPoint.x < 310 + 130 &&
        305 < touchPoint.y &&
        touchPoint.y < 305 + 20) {
      restartGame();
    }
    if (!event.handled && !player.isStop) {
      final localPoint = cam.globalToLocal(touchPoint);

      if (player.position.y - (player.hitbox.height / 2) <= localPoint.y &&
          localPoint.y <= player.position.y + (player.hitbox.height / 2) &&
          player.position.x - (player.hitbox.width / 2) <= localPoint.x &&
          localPoint.x <= player.position.x + (player.hitbox.width / 2)) {
        player.rolling();
      } else if (touchPoint.y <= size.y / 2) {
        // jump
        player.jump();
      } else if (touchPoint.y > size.y / 2 && touchPoint.x > size.x / 2) {
        // right
        player.setMoveDirection(1);
      } else {
        //left
        player.setMoveDirection(-1);
      }
    } else {
      player.setMoveDirection(0);
    }
  }

  void restartGame() {
    print('Game Restarted!');

    player = Player();

    hud = Hud();
    audioManager = AudioManager();
    this.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    if (event.canvasPosition.y > size.y / 2) {
      // jump
      player.setMoveDirection(0);
    }
  }

  @override
  void update(double dt) async {
    super.update(dt);
    player.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    //gameOverScreen.render(canvas);
  }
}
