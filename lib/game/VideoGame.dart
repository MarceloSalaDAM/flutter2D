import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../players/MainPlayer.dart';

class VideoGame extends FlameGame {
  VideoGame();

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
    ]);

    TiledComponent mapComponent =
    await TiledComponent.load('scene.tmx', Vector2(32,32));
    add(mapComponent);

    MainPlayer mainPlayer = MainPlayer(position: Vector2(200, 200));
    add(mainPlayer);
  }
}
