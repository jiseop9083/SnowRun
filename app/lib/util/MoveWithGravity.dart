// import 'package:flame/game.dart';
// import 'dart:math';

// class MoveWithGravity {
//   static final MoveWithGravity _instance = MoveWithGravity._internal();
//   static const double gravity = 0.1;
//   static const double resistance = 0.1;
//   MoveWithGravity._internal();

//   factory MoveWithGravity() {
//     return _instance;
//   }

//   Vector2 update(Vector2 position, Vector2 velocity, Vector2 acceleration) {
//     velocity.x = velocity.x > 0
//         ? max(velocity.x - resistance, 0)
//         : min(velocity.x + resistance, 0);
//     velocity.y = velocity.y + gravity;
//     // temp
//     if (position.y + velocity.y > 240) {
//       position.y = 240;
//       velocity.y = 0;
//       acceleration.y = 0;
//       return Vector2(position.x + velocity.x, position.y);
//     }
//     return Vector2(position.x + velocity.x, position.y + velocity.y);
//   }
// }
