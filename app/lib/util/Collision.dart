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

  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;
  // AABB
  return (fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      playerX < blockX + blockWidth &&
      playerX + playerWidth > blockX);
}
