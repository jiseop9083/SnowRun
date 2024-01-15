import 'package:flame/components.dart';

class ColliisionBlock extends PositionComponent {
  bool isPlatform;
  ColliisionBlock({
    position,
    size,
    this.isPlatform = false,
  }) : super(position: position, size: size) {
    debugMode = true; // debugMode
  }
}
