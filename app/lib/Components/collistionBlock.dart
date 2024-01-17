import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlatform;
  bool isSlope;
  bool isWater;
  int leftTop;
  int rightTop;
  bool isEnd;
  CollisionBlock({
    position,
    size,
    this.isPlatform = false,
    this.isSlope = false,
    this.isWater = false,
    this.isEnd = false,
    this.leftTop = 16,
    this.rightTop = 16,
  }) : super(position: position, size: size) {}
}
