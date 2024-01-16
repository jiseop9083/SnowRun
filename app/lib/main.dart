import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'package:app/game_screen.dart';
import 'package:app/Intro.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  SnowManGame game = SnowManGame(tileSize: 64);
  runApp(MaterialApp(
    home: GameIntro(),
  ));

  // runApp(GameWidget(game: kDebugMode ? SnowManGame(tileSize: 64) : game));
}
