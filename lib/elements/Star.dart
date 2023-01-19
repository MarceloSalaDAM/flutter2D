import 'dart:html';

import 'package:flame/components.dart';

import '../game/VideoGame.dart';

class Star extends PositionComponent with HasGameRef<VideoGame> {
  Star({
    required Vector2 position,
  }) : super(position: position);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    SpriteComponent starComponent = SpriteComponent.fromImage(
        game.images.fromCache('star.png'),
        size: Vector2.all(32), anchor: Anchor.bottomCenter);

    add(starComponent);
  }
}
