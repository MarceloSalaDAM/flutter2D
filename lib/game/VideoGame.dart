import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_game/players/EnemyPlayer.dart';

import '../elements/Star.dart';
import '../players/MainPlayer.dart';

class VideoGame extends FlameGame with HasKeyboardHandlerComponents {
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
        await TiledComponent.load('scene.tmx', Vector2(32, 32));
    add(mapComponent);

    ObjectGroup? estrellas =
        mapComponent.tileMap.getLayer<ObjectGroup>("stars");

    ObjectGroup? enemigos = mapComponent.tileMap.getLayer<ObjectGroup>("gotas");
    ObjectGroup? main = mapComponent.tileMap.getLayer<ObjectGroup>("initial");

    for (final enemigo in enemigos!.objects) {
      // print("------------" + estrella.x.toString()+"//"+ estrella.y.toString());
      EnemyPlayer enemyPlayer =
          EnemyPlayer(position: Vector2(enemigo.x, enemigo.y));
      add(enemyPlayer);
    }
    for (final estrella in estrellas!.objects) {
      // print("------------" + estrella.x.toString()+"//"+ estrella.y.toString());
      Star starMap = Star(position: Vector2(estrella.x, estrella.y));
      add(starMap);
    }

    MainPlayer mainPlayer = MainPlayer(
        position: Vector2(main!.objects.first.x, main!.objects.first.y));
    add(mainPlayer);
  }

  Color backgroundColor() {
    return const Color.fromRGBO(0, 255, 129, 0.30);
  }
}
