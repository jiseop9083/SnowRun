bool checkCollision(player, block) {
  // 한 가운데가 position
  final hitbox = player.hitbox;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;
  final playerX = player.position.x - (playerWidth / 2);
  final playerY = player.position.y - player.height + hitbox.offsetY;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;


  double fixedY;
  // AABB
  // return (fixedY < blockY + blockHeight &&
  //     playerY + playerHeight > blockY &&
  //     playerX < blockX + blockWidth &&
  //     playerX + playerWidth > blockX);

  // final fixedY = block.isPlatform ? playerY + playerHeight : (block.isSlope ? playerY + playerHeight : playerY);
  if (block.isPlatform){
    fixedY = playerY + playerHeight;
    return (fixedY < blockY + blockHeight &&
            playerY + playerHeight > blockY &&
            playerX < blockX + blockWidth &&
            playerX + playerWidth > blockX);

  }
  else if (block.isSlope){
    fixedY = playerY + playerHeight;
    final m = playerX - blockX;
    final n = blockX + blockWidth - playerX;
    return (playerY < blockY+blockHeight &&
            fixedY > (blockY+blockHeight - ((m * block.rightTop + n * block.leftTop) / (m + n))) &&
            playerX < blockX + blockWidth &&
            playerX + playerWidth > blockX
    );
  }
  else {
    fixedY = playerY;
    return (fixedY < blockY + blockHeight &&
        playerY + playerHeight > blockY &&
        playerX < blockX + blockWidth &&
        playerX + playerWidth > blockX);
  }

}
