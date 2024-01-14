import 'package:app/util/MoveWithGravity.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Player extends SpriteAnimationComponent with HasGameRef {
  static const playerSize = 128.0;
  MoveWithGravity gravity = MoveWithGravity();
  Vector2 velocity = Vector2(0, 0);
  Vector2 acceleration = Vector2(0, 0);
  double moveVelocity = 3;
  bool isJump = false;
  int moveDirection = 0;
  late String animationMode;

  // animations
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _jumpAnimation;

  Player({
    required position,
    Color color = const Color(0xffffff00),
  }) : super(
          position: position,
          size: Vector2.all(playerSize),
          anchor: Anchor.bottomCenter,
          paint: Paint()..color = color,
        ) {
    animationMode = 'idle';
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations();
    animation = _idleAnimation;
    animationMode = 'idle';
    // sprite = await gameRef.loadSprite('snowman.png');
    position = gameRef.size / 2;
  }

  Future<void> _loadAnimations() async {
    final idleSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('snowman_idle.png'),
      srcSize: Vector2(64, 64),
    );

    final jumpSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('snowman_jump.png'),
      srcSize: Vector2(64, 64),
    );

    _idleAnimation = idleSpriteSheet.createAnimation(
      row: 0,
      loop: true,
      stepTime: 0.55,
      to: 2,
    );

    _jumpAnimation = jumpSpriteSheet.createAnimation(
      row: 0,
      loop: false,
      stepTime: 0.2,
      to: 10,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    velocity.x = moveDirection == 0 ? velocity.x : moveDirection * moveVelocity;
    position = gravity.update(position, velocity, acceleration);
    if (animationMode != 'idle' && velocity.x == 0 && velocity.y == 0) {
      animationMode = 'idle';
      animation = _idleAnimation;
    }

    if (position.y == 270) isJump = false;
  }

  void setMoveDirection(int move) {
    moveDirection = move;
  }

  void jump() {
    if (isJump) return;
    animationMode = 'jump';
    animation = _jumpAnimation;
    isJump = true;
    velocity.y = -5;
    // temp
  }
}
