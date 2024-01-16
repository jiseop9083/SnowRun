// import 'package:app/Components/collistionBlock.dart';
// import 'package:flame/collisions.dart';
// import 'package:flame/components.dart';
// import 'package:flame/sprite.dart';
// import 'package:app/util/Collision.dart';
// import 'package:app/Components/PlayerHixbox.dart';

// class FollowedObject extends SpriteAnimationComponent with HasGameRef {
//   Vector2 previousPos = Vector2(0, 0);
//   Vector2 velocity = Vector2(0, 0);
//   List<CollisionBlock> collisionBlocks = [];
//   PlayerHitbox hitbox =
//       PlayerHitbox(offsetX: 40, offsetY: 20, width: 48, height: 88);

//   var animations = {};

//   //constant
//   static const playerSize = 128.0;
//   final double _moveVelocity = 100.8;

//   final _jumpPower = 300.0;
//   final double _terminalVelocity = 200;
//   final double _gravity = 9.8;

//   // isState
//   bool isOnGround = false;
//   bool isFacingRight = true;
//   bool isAnimationChanged = false;
//   int moveDirection = 0;
//   bool isRolling = false;
//   int rollingCounter = 0;

//   // animations
//   late final SpriteAnimation _idleAnimation;

//   FollowedObject({position})
//       : super(
//             position: position,
//             size: Vector2.all(playerSize),
//             anchor: Anchor.center) {}

//   @override
//   Future<void> onLoad() async {
//     super.onLoad();
//     await _loadAnimations();
//     debugMode = true;
//     add(RectangleHitbox(
//         position: Vector2(hitbox.offsetX, hitbox.offsetY),
//         size: Vector2(hitbox.width, hitbox.height)));
//   }

//   @override
//   void update(double dt) {
//     // movement and gravity -> collision detection -> updateState -> rendering

//     if (isRolling) {
//       angle += 0.05 * (position.x - previousPos.x);
//     }
//     previousPos.x = position.x;
//     previousPos.y = position.y;
//     super.update(dt);
//     _applyGravity(dt);
//     _updatePlayerMovement(dt);
//     _checkCollisions();
//   }

//   void _checkCollisions() {
//     for (final block in collisionBlocks) {
//       if (block.isSlope) {
//         if (checkCollision(this, block)) {
//           final playerX = position.x - (hitbox.width / 2); // center
//           if (velocity.y != 0 || velocity.x != 0) {
//             double m;
//             double n;
//             if (block.rightTop > block.leftTop) {
//               m = playerX + hitbox.width - block.x;
//               n = block.x + block.width - (playerX + hitbox.width);
//             } else {
//               m = playerX - block.x;
//               n = block.x + block.width - playerX;
//             }
//             double leapHeight =
//                 ((m * block.rightTop + n * block.leftTop) / (block.width));
//             velocity.y = 0;
//             velocity.x = 0;
//             position.y =
//                 (block.y + block.height - leapHeight - (hitbox.height / 2));
//             isOnGround = true;
//             break;
//           }
//         }
//       } else if (block.isPlatform) {
//         if (checkCollision(this, block)) {
//           if (velocity.y > 0) {
//             velocity.y = 0;
//             position.y =
//                 block.y - (height - (hitbox.height / 2) - hitbox.offsetY);
//             isOnGround = true;
//             break;
//           }
//         }
//       } else {
//         if (checkCollision(this, block)) {
//           Vector2 temp = Vector2(position.x, position.y);
//           position.y = previousPos.y;
//           if (checkCollision(this, block)) {
//             if (velocity.x > 0) {
//               velocity.x = 0;
//               position.x = block.x - (hitbox.width / 2);
//               position.y = temp.y;
//               continue;
//             }
//             if (velocity.x < 0) {
//               velocity.x = 0;
//               position.x = block.x + block.width + (hitbox.width / 2);
//               position.y = temp.y;
//               continue;
//             }
//           }
//           position.y = temp.y;
//           position.x = previousPos.x;
//           if (checkCollision(this, block)) {
//             if (velocity.y > 0) {
//               velocity.y = 0;
//               position.y = block.y - (height / 2 - hitbox.offsetY);
//               isOnGround = true;
//               position.x = temp.x;
//               continue;
//             }
//             if (velocity.y < 0) {
//               velocity.y = 0;
//               position.y = block.y + block.height + (hitbox.height / 2);
//               position.x = temp.x;
//               continue;
//             }
//           }
//           position.x = temp.x;
//         }
//       }
//     }
//   }

//   void _updatePlayerMovement(double dt) {
//     if (velocity.y > _gravity) isOnGround = false;

//     velocity.x = _moveVelocity * moveDirection;
//     position.x += velocity.x * dt;
//   }

//   void _applyGravity(double dt) {
//     velocity.y += _gravity;
//     velocity.y = velocity.y.clamp(-_jumpPower, _terminalVelocity);
//     position.y += velocity.y * dt;
//     //position = gravity.update(position, velocity, acceleration);
//   }

//   Future<void> _loadAnimations() async {
//     final idleSpriteSheet = SpriteSheet(
//       image: await gameRef.images.load('snowman_idle.png'),
//       srcSize: Vector2(64, 64),
//     );

//     _idleAnimation = idleSpriteSheet.createAnimation(
//       row: 0,
//       loop: true,
//       stepTime: 0.55,
//       to: 2,
//     );
//   }
// }
