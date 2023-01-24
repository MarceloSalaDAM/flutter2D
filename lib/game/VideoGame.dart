import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_game/players/EnemyPlayer.dart';

import '../elements/Star.dart';
import '../main.dart';
import '../overlays/Hud.dart';
import '../players/MainPlayer.dart';
import '../ux/JoyPad.dart';

class VideoGame extends Forge2DGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late TiledComponent mapComponent;
  late PlayerBody _mainBody;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;
  int horizontalMove = 0;
  int verticalMove = 0;
  int starsCollected = 0;
  int health = 3;

  List<PositionComponent> visualObjects = [];

  VideoGame() : super(gravity: Vector2(0, 9.8), zoom: 1);

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

    mapComponent = await TiledComponent.load('scene.tmx', Vector2(32, 32));
    add(mapComponent);
    //initializeGame(true);
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
    if (health <= 0) {
      overlays.add('GameOver');
    }
    super.update(dt);
  }

  void setDirection(int horizontalMove, int verticalMove) {
    this.horizontalMove = horizontalMove;
    this.verticalMove = verticalMove;
  }

  Future<void> initializeGame(bool loadHud) async {
    visualObjects.clear();
    mapComponent.position = Vector2(0, 0);

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

    _mainBody = PlayerBody(
        position: Vector2(main!.objects.first.x, main!.objects.first.y));
    add(_mainBody);

    if (loadHud) {
      add(Hud());
    }
  }

  void reset() {
    starsCollected = 0;
    health = 3;
    initializeGame(false);
  }

  void joypadMoved(Direction direction) {
    //print("JOYPAD EN MOVIMIENTO:   ---->  "+direction.toString());

    horizontalMove = 0;
    verticalMove = 0;

    if (direction == Direction.left) {
      horizontalMove = -1;
    } else if (direction == Direction.right) {
      horizontalMove = 1;
    }

    if (direction == Direction.up) {
      verticalMove = -1;
    } else if (direction == Direction.down) {
      verticalMove = 1;
    }

    _mainBody.mainPlayer.horizontalMove = horizontalMove;
  }
}
