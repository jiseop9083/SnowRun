import 'package:app/Components/collistion_block.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:app/util/Collision.dart';
import 'package:app/Components/PlayerHixbox.dart';

enum PlayerState { idle, jump, walk, melt, rolling, head }

class Player extends SpriteAnimationComponent with HasGameRef {
  Vector2 previousPos = Vector2(0, 0);
  Vector2 velocity = Vector2(0, 0);
  Vector2 acceleration = Vector2(0, 0);
  List<CollisionBlock> collisionBlocks = [];
  PlayerHitbox hitbox =
      PlayerHitbox(offsetX: 40, offsetY: 20, width: 48, height: 88);

  late PlayerState animationMode;
  var animations = {};

  //constant
  static const playerSize = 128.0;
  final double _moveVelocity = 100.8;

  final _jumpPower = 300.0;
  final double _terminalVelocity = 200;
  final double _gravity = 9.8;

  // isState
  bool isOnGround = false;
  bool isFacingRight = true;
  bool isAnimationChanged = false;
  int moveDirection = 0;
  bool isRolling = false;
  int rollingCounter = 0;

  // animations
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _jumpAnimation;
  late final SpriteAnimation _walkAnimation;
  late final SpriteAnimation _meltAnimation;
  late final SpriteAnimation _rollingAnimation;
  late final SpriteAnimation _headAnimation;

  Player({position})
      : super(
            position: position,
            size: Vector2.all(playerSize),
            anchor: Anchor.center) {
    animationMode = PlayerState.idle;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations();
    debugMode = true;
    add(RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height)));
    animationMode = PlayerState.idle;
    isAnimationChanged = true;
  }

  @override
  void update(double dt) {
    // movement and gravity -> collision detection -> updateState -> rendering

    if (rollingCounter > 0) {
      rollingCounter--;
    }
    if (rollingCounter == 0 && isRolling) _stateRolling();
    if (isRolling) {
      angle += 0.05 * (position.x - previousPos.x);
    }
    previousPos.x = position.x;
    previousPos.y = position.y;
    super.update(dt);
    _applyGravity(dt);
    _updatePlayerMovement(dt);
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
      print("stop rolling");
      return;
    }
    animationMode = PlayerState.rolling;
    isAnimationChanged = true;
    isRolling = true;
    rollingCounter = 80;
    animation = animations[animationMode];
    isAnimationChanged = false;
  }

  void _stateRolling() {
    animationMode = PlayerState.head;
    animation = animations[animationMode];
    isAnimationChanged = false;
    hitbox = PlayerHitbox(offsetX: 40, offsetY: 40, width: 48, height: 44);
    // add(RectangleHitbox(
    //     position: Vector2(hitbox.offsetX, hitbox.offsetY),
    //     size: Vector2(hitbox.width, hitbox.height)));
  }

  void _updatePlayerState() {
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
    if (isRolling == false && isAnimationChanged) {
      animation = animations[animationMode];
      isAnimationChanged = false;
    }
  }

  void _checkCollisions() {
    for (final block in collisionBlocks) {
      if (block.isSlope) {
        if (checkCollision(this, block)) {
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
            position.y =
                block.y - (height - (hitbox.height / 2) - hitbox.offsetY);
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
              position.y = block.y - (height / 2 - hitbox.offsetY);
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

    velocity.x = _moveVelocity * moveDirection;
    position.x += velocity.x * dt;
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpPower, _terminalVelocity);
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

    final rollingSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('snowman_rolling.png'),
      srcSize: Vector2(64, 64),
    );

    final headSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('snowman_rolling_head.png'),
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

    _rollingAnimation = rollingSpriteSheet.createAnimation(
      row: 0,
      loop: false,
      stepTime: 0.2,
      to: 4,
    );

    _headAnimation = headSpriteSheet.createAnimation(
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
      PlayerState.rolling: _rollingAnimation,
      PlayerState.head: _headAnimation
    };
  }
}
