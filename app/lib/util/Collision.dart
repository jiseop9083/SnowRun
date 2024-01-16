bool checkCollision(player, block) {
  // player.position.x: center of player
  // player.position.y: bottom of player
  final hitbox = player.hitbox;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;
  final playerX = player.position.x - (playerWidth / 2);
  final playerY = player.position.y - (playerHeight / 2);

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

  if (block.isPlatform) {
    fixedY = playerY + playerHeight;
    return (fixedY < blockY + blockHeight &&
        playerY + playerHeight > blockY &&
        playerX < blockX + blockWidth &&
        playerX + playerWidth > blockX);
  } else if (block.isSlope) {
    fixedY = playerY + playerHeight;
    double m;
    double n;
    if (block.rightTop > block.leftTop) {
      m = playerX + playerWidth - blockX;
      n = blockX + blockWidth - (playerX + playerWidth);
    } else {
      m = playerX - blockX;
      n = blockX + blockWidth - playerX;
    }
    return (playerY < blockY + blockHeight &&
        playerY + playerHeight >
            (blockY +
                blockHeight -
                ((m * block.rightTop + n * block.leftTop) / (m + n))) &&
        playerX < blockX + blockWidth &&
        playerX + playerWidth > blockX);
  } else {
    fixedY = playerY;
    return (fixedY < blockY + blockHeight &&
        playerY + playerHeight > blockY &&
        playerX < blockX + blockWidth &&
        playerX + playerWidth > blockX);
  }
}
