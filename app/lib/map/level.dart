import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'package:app/Components/collistion_block.dart';
import 'package:app/Components/Player.dart';

class Level extends World {
  late Player player;
  Level({required this.player});
  late TiledComponent level;
  List<ColliisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('Level-01.tmx', Vector2.all(16));
    print('ddd');
    add(level);
    final metaDataLayer = level.tileMap.getLayer<ObjectGroup>('Metadata');
    for (final metaData in metaDataLayer!.objects) {
      switch (metaData.class_) {
        case 'Player':
          player.position = Vector2(metaData.x, metaData.y);
          add(player);
          break;
      }
    }

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer!.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = ColliisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          case 'Slope':
            final properties = collision.properties;
            final IntProperty leftProperty =
                properties['leftTop'] as IntProperty;
            int leftTop = leftProperty.value;
            final IntProperty rightProperty =
                properties['rightTop'] as IntProperty;
            int rightTop = rightProperty.value;
            final block = ColliisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height),
                isPlatform: false,
                isSlope: true,
                leftTop: leftTop,
                rightTop: rightTop);
            collisionBlocks.add(block);
            add(block);
            break;
          default: //normal block
            final block = ColliisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height),
                isPlatform: false);
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
    return super.onLoad();
  }
}
