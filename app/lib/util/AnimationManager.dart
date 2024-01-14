// import 'package:flame/game.dart';
// import 'package:flame/sprite.dart';

// class AnimationManager {
//   static final AnimationManager _instance = AnimationManager._internal();
//   final double _animationSpeed = 0.55;
//   late final SpriteAnimation _idleAnimation;
//   AnimationManager._internal();

//   factory AnimationManager() {
//     return _instance;
//   }
// // 
//   SpriteAnimation getAnimations(SpriteSheet spriteSheet, String name) {
//     _idleAnimation = spriteSheet.createAnimation(
//       row: 0,
//       loop: true,
//       stepTime: _animationSpeed,
//       to: 2,
//     );
//     return _idleAnimation;
//   }
// }
