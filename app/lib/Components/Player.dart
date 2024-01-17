import 'package:app/Components/collistionBlock.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'dart:math';

import 'package:app/util/Collision.dart';
import 'package:app/Components/PlayerHixbox.dart';

enum PlayerState { idle, jump, walk, melt, goin, goout, roll }

class Player extends SpriteAnimationComponent with HasGameRef {
  Vector2 previousPos = Vector2(0, 0);
  Vector2 velocity = Vector2(0, 0);
  Vector2 acceleration = Vector2(0, 0);
  double slopeLean = 0;
  List<CollisionBlock> collisionBlocks = [];
  PlayerHitbox hitbox =
      PlayerHitbox(offsetX: 80, offsetY: 40, width: 96, height: 176);
  late RectangleHitbox rectHitbox;
  double playTime = 0;
  double dis = 0;
  late PlayerState animationMode;
  var animations = {};

  //constant
  static const playerSize = 256.0;
  final double _moveVelocity = 200.0;

  final _jumpPower = 360.0;
  final double _terminalVelY = 300;
  final double _terminalVelX = 800;
  final double _gravity = 10.0;

  // isState
  bool isOnGround = false;
  bool isFacingRight = true;
  bool isAnimationChanged = false;
  int moveDirection = 0;
  bool isRolling = false;
  bool isLive = true;
  bool isStop = false;

  int rollingCounter = -1;

  // animations
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _jumpAnimation;
  late final SpriteAnimation _walkAnimation;
  late final SpriteAnimation _meltAnimation;
  late final SpriteAnimation _goinAnimation;
  late final SpriteAnimation _gooutAnimation;
  late final SpriteAnimation _rollAnimation;

  Player({position})
      : super(
            position: position,
            size: Vector2.all(playerSize),
            anchor: Anchor.center) {
    animationMode = PlayerState.idle;
    isLive = true;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations();
    rectHitbox = RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height));
    add(rectHitbox);
    animationMode = PlayerState.idle;
    isAnimationChanged = true;
  }

  @override
  void update(double dt) {
    // movement and gravity -> collision detection -> updateState -> rendering
    playTime += dt;
    dis = max(dis, position.x);
    if (rollingCounter > 0) {
      rollingCounter--;
    }
    if (rollingCounter == 0) {
      if (isRolling) {
        bool isColl = false;
        // for (final block in collisionBlocks) {
        //   if (!block.isPlatform) {
        //     if (block.y < position.y - (3 * hitbox.height / 2) &&
        //         position.y - (3 * hitbox.height / 2) < block.y + block.height) {
        //       isColl = true;
        //       print(block.y);
        //       break;
        //     }
        //   }
        // }
        if (!isColl) {
          hitbox = PlayerHitbox(
              offsetX: hitbox.offsetX,
              offsetY: (size.y - (hitbox.height * 2)) / 2,
              width: hitbox.width,
              height: hitbox.height * 2);
          remove(rectHitbox);
          rectHitbox = RectangleHitbox(
              position: Vector2(hitbox.offsetX, hitbox.offsetY),
              size: Vector2(hitbox.width, hitbox.height));
          add(rectHitbox);
          angle = 0;
          animationMode = PlayerState.idle;
          isAnimationChanged = true;
          isRolling = false;
        } else {
          animation = animations[PlayerState.roll];
        }
      } else {
        _startRolling();
        isRolling = true;
      }
      rollingCounter = -1;
    }
    if (isRolling) {
      double dx = (position.x - previousPos.x);
      double absdx = dx < 0 ? -dx : dx;
      angle += 0.05 * dx;
      hitbox.width = min((hitbox.width + 0.48 * absdx), 96).toInt().toDouble();
      hitbox.height =
          min((hitbox.height + (0.44 * absdx)), 88).toInt().toDouble();
      size.x = min(size.x + 1.28 * absdx, 256).toInt().toDouble();
      size.y = min(size.y + 1.28 * absdx, 256).toInt().toDouble();
      hitbox.offsetX = (size.x - hitbox.width) / 2;
      hitbox.offsetY = (size.y - hitbox.height) / 2;
      remove(rectHitbox);
      hitbox = PlayerHitbox(
          offsetX: hitbox.offsetX,
          offsetY: hitbox.offsetY,
          width: hitbox.width,
          height: hitbox.height);
      rectHitbox = RectangleHitbox(
          position: Vector2(hitbox.offsetX, hitbox.offsetY),
          size: Vector2(hitbox.width, hitbox.height));
      add(rectHitbox);
    }

    previousPos.x = position.x;
    previousPos.y = position.y;
    super.update(dt);
    _applyGravity(dt);
    _updatePlayerMovement(dt);
    slopeLean = 0;
    _checkCollisions();
    _updatePlayerState();
  }

  void setMoveDirection(int move) {
    moveDirection = move;
  }

  void jump() {
    if (!isOnGround) return;
    animationMode = PlayerState.jump;
    isAnimationChanged = true;
    isOnGround = false;
    velocity.y = -_jumpPower;
    // temp
  }

  void rolling() {
    if (isRolling) {
      rollingCounter = 80;
      angle = 0;

      animationMode = PlayerState.goout;
      animation = animations[animationMode];
      isAnimationChanged = false;
      return;
    }
    animationMode = PlayerState.goin;
    rollingCounter = 80;
    animation = animations[animationMode];
    isAnimationChanged = false;
  }

  void _startRolling() {
    animationMode = PlayerState.roll;
    animation = animations[animationMode];
    isAnimationChanged = false;
    // 왜인지 모르겠지만 size > height * offsetY * 2 일때 충돌 정상 작동
    hitbox = PlayerHitbox(
        offsetX: hitbox.offsetX,
        offsetY: (size.y - (hitbox.height / 2)) / 2,
        width: hitbox.width,
        height: hitbox.height / 2);

    remove(rectHitbox);
    rectHitbox = RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height));
    add(rectHitbox);
  }

  void _updatePlayerState() {
    if (isStop) return;
    // idle
    if (animationMode != PlayerState.idle &&
        velocity.x == 0 &&
        velocity.y == 0) {
      animationMode = PlayerState.idle;
      isAnimationChanged = true;
    }
    // walk
    if (moveDirection != 0) {
      animationMode = PlayerState.walk;
      isAnimationChanged = true;
    }
    if (velocity.y > _gravity) {
      // animationMode = PlayerState.fall;
      // isAnimationChanged = true;
    }
    if (isFacingRight && moveDirection < 0) {
      flipHorizontallyAroundCenter();
      isFacingRight = false;
    }
    if (!isFacingRight && moveDirection > 0) {
      flipHorizontallyAroundCenter();
      isFacingRight = true;
    }
    if ((rollingCounter < 0 && !isRolling) && isAnimationChanged) {
      animation = animations[animationMode];
      isAnimationChanged = false;
    }
  }

  void _checkCollisions() {
    slopeLean = 0.0;
    for (final block in collisionBlocks) {
      if (block.isEnd) {
        if (checkCollision(this, block)) {
          isStop = true;
          isLive = false;
          animationMode = PlayerState.idle;
          animation = animations[animationMode];
          dis = dis * 3;
          continue;
        }
      }
      if (block.isWater) {
        if (checkCollision(this, block)) {
          isStop = true;
          animationMode = PlayerState.melt;
          animation = animations[animationMode];
          isLive = false;
          continue;
        }
      }
      if (block.isSlope) {
        if (checkCollision(this, block)) {
          slopeLean =
              ((block.leftTop - block.rightTop).toDouble() / block.width);
          final playerX = position.x - (hitbox.width / 2); // center
          if (velocity.y != 0 || velocity.x != 0) {
            double m;
            double n;
            if (block.rightTop > block.leftTop) {
              m = playerX + hitbox.width - block.x;
              n = block.x + block.width - (playerX + hitbox.width);
            } else {
              m = playerX - block.x;
              n = block.x + block.width - playerX;
            }
            double leapHeight =
                ((m * block.rightTop + n * block.leftTop) / (block.width));
            velocity.y = 0;
            velocity.x = 0;
            position.y =
                (block.y + block.height - leapHeight - (hitbox.height / 2));
            isOnGround = true;
            break;
          }
        }
      } else if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - (hitbox.height / 2);
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          Vector2 temp = Vector2(position.x, position.y);
          position.y = previousPos.y;
          if (checkCollision(this, block)) {
            if (velocity.x > 0) {
              velocity.x = 0;
              position.x = block.x - (hitbox.width / 2);
              position.y = temp.y;
              continue;
            }
            if (velocity.x < 0) {
              velocity.x = 0;
              position.x = block.x + block.width + (hitbox.width / 2);
              position.y = temp.y;
              continue;
            }
          }
          position.y = temp.y;
          position.x = previousPos.x;
          if (checkCollision(this, block)) {
            if (velocity.y > 0) {
              velocity.y = 0;
              position.y = block.y - (hitbox.height / 2);
              isOnGround = true;
              position.x = temp.x;
              continue;
            }
            if (velocity.y < 0) {
              velocity.y = 0;
              position.y = block.y + block.height + (hitbox.height / 2);
              position.x = temp.x;
              continue;
            }
          }
          position.x = temp.x;
        }
      }
    }
  }

  void _updatePlayerMovement(double dt) {
    if (velocity.y > _gravity) isOnGround = false;

    velocity.x =
        _moveVelocity * moveDirection + (slopeLean * (isRolling ? 300 : 40));
    if (moveDirection == 0) velocity.x += (slopeLean * (isRolling ? 300 : 0));
    if (velocity.x > 0)
      velocity.x = min(velocity.x, _terminalVelX);
    else
      velocity.x = max(velocity.x, -_terminalVelX);
    position.x += velocity.x * dt;
    position.y += slopeLean * velocity.x * dt;
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpPower, _terminalVelY);
    position.y += velocity.y * dt;
    //position = gravity.update(position, velocity, acceleration);
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

    final goinSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('snowman_in.png'),
      srcSize: Vector2(64, 64),
    );

    final gooutSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('snowman_out.png'),
      srcSize: Vector2(64, 64),
    );

    final rollSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('snowman_roll.png'),
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

    _goinAnimation = goinSpriteSheet.createAnimation(
      row: 0,
      loop: false,
      stepTime: 0.5,
      to: 6,
    );

    _gooutAnimation = gooutSpriteSheet.createAnimation(
      row: 0,
      loop: false,
      stepTime: 0.5,
      to: 6,
    );

    _rollAnimation = rollSpriteSheet.createAnimation(
      row: 0,
      loop: true,
      stepTime: 1,
      to: 1,
    );

    animations = {
      PlayerState.idle: _idleAnimation,
      PlayerState.jump: _jumpAnimation,
      PlayerState.walk: _walkAnimation,
      PlayerState.melt: _meltAnimation,
      PlayerState.goin: _goinAnimation,
      PlayerState.goout: _gooutAnimation,
      PlayerState.roll: _rollAnimation
    };
  }
}
