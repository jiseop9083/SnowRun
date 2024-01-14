import 'package:flutter/material.dart';
import 'package:app/game_screen.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  SnowManGame game = SnowManGame();
  runApp(GameWidget(game: game));
}
