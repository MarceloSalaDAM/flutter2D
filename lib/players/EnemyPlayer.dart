import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../game/VideoGame.dart';

class EnemyPlayer extends SpriteAnimationComponent with HasGameRef<VideoGame> {
  EnemyPlayer({
    required super.position,
  }) : super(size: Vector2.all(32), anchor: Anchor.bottomCenter);

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

    add(RectangleHitbox()..collisionType = CollisionType.passive);
    add(
      MoveEffect.by(
        Vector2(-0.5 * size.x, 1),
        EffectController(
          duration: 0.75,
          alternate: true,
          infinite: true,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.health <= 0) {
      removeFromParent();
    }
  }
}
