import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlatform;
  bool isSlope;
  int leftTop;
  int rightTop;
  CollisionBlock({
    position,
    size,
    this.isPlatform = false,
    this.isSlope = false,
    this.leftTop = 16,
    this.rightTop = 16,
  }) : super(position: position, size: size) {
    debugMode = true; // debugMode
  }
}
