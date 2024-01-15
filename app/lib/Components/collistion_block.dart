import 'package:flame/components.dart';

class ColliisionBlock extends PositionComponent {
  bool isPlatform;
  bool isSlope;
  ColliisionBlock({
    position,
    size,
    this.isPlatform = false,
    this.isSlope = false,
    leftTop = 16,
    rightTop = 16,
  }) : super(position: position, size: size) {
    debugMode = true; // debugMode
  }
}
