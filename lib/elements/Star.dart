import 'dart:html';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../game/VideoGame.dart';

class Star extends SpriteComponent with HasGameRef<VideoGame> {
  Star({
    required super.position,
  }) : super(size: Vector2.all(32), anchor: Anchor.bottomCenter);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    final platformImage = game.images.fromCache('star.png');
    sprite = Sprite(platformImage);

    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.health <= 0) {
      removeFromParent();
    }
  }
}
