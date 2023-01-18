import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

import 'game/VideoGame.dart';

/*void main() {
  final game = VideoGame();
  runApp(GameWidget(game: game));
}*/

void main() {
  runApp(
    const GameWidget<VideoGame>.controlled(
      gameFactory: VideoGame.new,
    ),
  );
}