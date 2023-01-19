import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../game/VideoGame.dart';

class MainPlayer extends SpriteAnimationComponent
    with HasGameRef<VideoGame>, KeyboardHandler {
  MainPlayer({
    required super.position,
  }) : super(size: Vector2.all(32), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    return true;
  }
}
