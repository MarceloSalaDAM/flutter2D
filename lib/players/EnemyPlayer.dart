import 'package:flame/components.dart';

import '../game/VideoGame.dart';

class EnemyPlayer extends SpriteAnimationComponent with HasGameRef<VideoGame> {
  EnemyPlayer({
    required super.position,
  }) : super(size: Vector2.all(32), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('water_enemy.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );
  }
}
