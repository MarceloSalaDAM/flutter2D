import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/players/EnemyPlayer.dart';
import 'package:forge2d/src/dynamics/body.dart';

import '../elements/Star.dart';
import '../game/VideoGame.dart';

class PlayerBody extends BodyComponent<VideoGame> {
  Vector2 position;

  PlayerBody({required this.position});
  late MainPlayer _mainPlayer;

  @override
  Future<void> onLoad() async {
    // TODO: implement onLoad
    await super.onLoad();
    _mainPlayer=MainPlayer(position: position);
    add(_mainPlayer);
  }

  @override
  Body createBody() {
    // TODO: implement createBody
    BodyDef defCuerpo = BodyDef(position: position, type: BodyType.dynamic);
    Body cuerpo = world.createBody(defCuerpo);
    return cuerpo;
  }
}

class MainPlayer extends SpriteAnimationComponent
    with HasGameRef<VideoGame>, KeyboardHandler, CollisionCallbacks {
  MainPlayer({
    required super.position,
  }) : super(size: Vector2.all(32), anchor: Anchor.center);

  int horizontalMove = 0;
  int verticalMove = 0;

  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;

  late CircleHitbox hitbox;

  bool hitByEnemy = false;

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
    hitbox = CircleHitbox();
    add(hitbox);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMove = 0;
    verticalMove = 0;

    if ((keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft))) {
      horizontalMove = -1;
    } else if ((keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight))) {
      horizontalMove = 1;
    }

    if ((keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp))) {
      verticalMove = -1;
    } else if ((keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown))) {
      verticalMove = 1;
    }

    game.setDirection(horizontalMove, verticalMove);

    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Star) {
      other.removeFromParent();
      game.starsCollected++;
    }

    if (other is EnemyPlayer) {
      hit();
    }
    super.onCollision(intersectionPoints, other);
  }

  void hit() {
    if (!hitByEnemy) {
      hitByEnemy = true;

      add(
        OpacityEffect.fadeOut(
          EffectController(
            alternate: true,
            duration: 0.1,
            repeatCount: 4,
          ),
        )..onComplete = () {
            hitByEnemy = false;
          },
      );
      game.health--;
    }
  }

  @override
  void update(double dt) {
    /* velocity.x = horizontalMove * moveSpeed;
    velocity.y = verticalMove * moveSpeed;
    game.mapComponent.position -= velocity * dt;*/

    if (horizontalMove < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalMove > 0 && scale.x < 0) {
      flipHorizontally();
    }

    if (game.health <= 0) {
      game.setDirection(0, 0);
      removeFromParent();
    }
    super.update(dt);
  }
}
