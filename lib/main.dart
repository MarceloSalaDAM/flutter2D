import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game/widgets/GameOverMenu.dart';
import 'package:flutter_game/widgets/Menu.dart';

import 'game/VideoGame.dart';

/*void main() {
  final game = VideoGame();
  runApp(GameWidget(game: game));
}*/

void main() {
  runApp(
    GameWidget<VideoGame>.controlled(
      gameFactory: VideoGame.new,
      overlayBuilderMap: {
        'MainMenu': (_, game) => Menu(game: game),
        'GameOver': (_, game) => GameOverMenu(game: game),
        //'Joypad': (_, game) => Joypad(onDirectionChanged: game.joypadMoved),
      },
      initialActiveOverlays: const ['MainMenu'],
    ),
  );
}
