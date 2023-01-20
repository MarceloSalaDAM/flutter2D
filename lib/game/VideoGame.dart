import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_game/players/EnemyPlayer.dart';

import '../elements/Star.dart';
import '../main.dart';
import '../overlays/Hud.dart';
import '../players/MainPlayer.dart';

class VideoGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late TiledComponent mapComponent;

  int horizontalMove = 0;
  int verticalMove = 0;

  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;

  int starsCollected = 0;
  int health = 3;

  List<PositionComponent> visualObjects = [];

  late MainPlayer _mainPlayer;

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
    initializeGame(true);
  }

  Color backgroundColor() {
    return const Color.fromRGBO(0, 255, 129, 0.30);
  }

  @override
  void update(double dt) {
    velocity.x = horizontalMove * moveSpeed;
    velocity.y = verticalMove * moveSpeed;
    mapComponent.position -= velocity * dt;
    for (final visualObj in visualObjects) {
      visualObj.position -= velocity * dt;
    }
    super.update(dt);
  }

  void setDirection(int horizontalMove, int verticalMove) {
    this.horizontalMove = horizontalMove;
    this.verticalMove = verticalMove;
  }

  Future<void> initializeGame(bool loadHud) async {
    mapComponent = await TiledComponent.load('scene.tmx', Vector2(32, 32));
    add(mapComponent);

    ObjectGroup? estrellas =
        mapComponent.tileMap.getLayer<ObjectGroup>("stars");

    ObjectGroup? enemigos = mapComponent.tileMap.getLayer<ObjectGroup>("gotas");
    ObjectGroup? main = mapComponent.tileMap.getLayer<ObjectGroup>("initial");

    for (final enemigo in enemigos!.objects) {
      // print("------------" + estrella.x.toString()+"//"+ estrella.y.toString());
      EnemyPlayer enemyPlayer =
          EnemyPlayer(position: Vector2(enemigo.x, enemigo.y));

      visualObjects.add(enemyPlayer);
      add(enemyPlayer);
    }
    for (final estrella in estrellas!.objects) {
      // print("------------" + estrella.x.toString()+"//"+ estrella.y.toString());
      Star starMap = Star(position: Vector2(estrella.x, estrella.y));
      visualObjects.add(starMap);
      add(starMap);
    }

    _mainPlayer = MainPlayer(
        position: Vector2(main!.objects.first.x, main!.objects.first.y));
    add(_mainPlayer);

    if (loadHud) {
      add(Hud());
    }
  }

  void reset() {
    starsCollected = 0;
    health = 3;
    initializeGame(false);
  }
}
