import 'package:app/util/MoveWithGravity.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

enum PlayerState { idle, jump, walk, melt }

class Player extends SpriteAnimationComponent with HasGameRef {
  MoveWithGravity gravity = MoveWithGravity();
  Vector2 velocity = Vector2(0, 0);
  Vector2 acceleration = Vector2(0, 0);

  late PlayerState animationMode;
  var animations = {};

  //constant
  double moveVelocity = 1.8;
  static const playerSize = 128.0;
  double jumpPower = -3.0;

  // isState
  bool isJump = false;
  bool isFacingRight = true;
  bool isAnimationChanged = false;
  int moveDirection = 0;

  // animations
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _jumpAnimation;
  late final SpriteAnimation _walkAnimation;
  late final SpriteAnimation _meltAnimation;

  Player({position})
      : super(
          position: position,
          size: Vector2.all(playerSize),
          anchor: Anchor.bottomCenter,
        ) {
    animationMode = PlayerState.idle;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations();

    animationMode = PlayerState.idle;
    isAnimationChanged = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    velocity.x = moveDirection == 0 ? velocity.x : moveDirection * moveVelocity;
    position = gravity.update(position, velocity, acceleration);
    if (animationMode != PlayerState.melt &&
        velocity.x == 0 &&
        velocity.y == 0) {
      animationMode = PlayerState.melt;
      isAnimationChanged = true;
    }
    if (moveDirection != 0) {
      animationMode = PlayerState.walk; // idle
      isAnimationChanged = true;
    }
    if (isFacingRight && moveDirection < 0) {
      flipHorizontallyAroundCenter();
      isFacingRight = false;
    }
    if (!isFacingRight && moveDirection > 0) {
      flipHorizontallyAroundCenter();
      isFacingRight = true;
    }
    if (position.y == 270) isJump = false;
    if (isAnimationChanged) {
      animation = animations[animationMode];
      isAnimationChanged = false;
    }
  }

  void setMoveDirection(int move) {
    moveDirection = move;
  }

  void jump() {
    if (isJump) return;
    animationMode = PlayerState.jump;
    isAnimationChanged = true;
    isJump = true;
    velocity.y = jumpPower;
    // temp
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

    final walkSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('snowman_walk.png'),
      srcSize: Vector2(64, 64),
    );

    final meltSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('snowman_melt.png'),
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
      to: 11,
    );

    _walkAnimation = walkSpriteSheet.createAnimation(
      row: 0,
      loop: true,
      stepTime: 0.5,
      to: 3,
    );

    _meltAnimation = meltSpriteSheet.createAnimation(
      row: 0,
      loop: false,
      stepTime: 0.7,
      to: 7,
    );

    animations = {
      PlayerState.idle: _idleAnimation,
      PlayerState.jump: _jumpAnimation,
      PlayerState.walk: _walkAnimation,
      PlayerState.melt: _meltAnimation
    };
  }
}
