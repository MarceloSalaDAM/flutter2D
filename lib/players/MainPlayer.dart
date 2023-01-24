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
import '../ux/JoyPad.dart';

class PlayerBody extends BodyComponent<VideoGame> {
  Vector2 position;
  Vector2 size = Vector2(32, 32);
  late MainPlayer mainPlayer;
  int verticalMove = 0;
  int horizontalMove = 0;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;
  double jumpSpeed = 0;
  double iShowDelay = 5;
  bool elementAdded = false;

  PlayerBody({required this.position});

  @override
  Future<void> onLoad() async {
    // TODO: implement onLoad
    await super.onLoad();
    mainPlayer = MainPlayer(position: Vector2(0, 0));
    mainPlayer.size = size;
    add(mainPlayer);
    renderBody = true;
    game.overlays.addEntry(
        'Joypad', (_, game) => Joypad(onDirectionChanged: joypadMoved));
  }

  @override
  Body createBody() {
    // TODO: implement createBody
    BodyDef defCuerpo = BodyDef(
        position: position, type: BodyType.dynamic, fixedRotation: true);
    Body cuerpo = world.createBody(defCuerpo);

    final shape = CircleShape();
    shape.radius = size.x / 2;

    FixtureDef fixtureDef = FixtureDef(
      shape,
      restitution: 0.5,
    );
    cuerpo.createFixture(fixtureDef);
    return cuerpo;
  }

  @override
  void onMount() {
    super.onMount();
    camera.followBodyComponent(this);
  }

  void joypadMoved(Direction direction) {
    if (direction == Direction.none) {
      horizontalMove = 0;
      verticalMove = 0;
    }

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
  void update(double dt) {
    velocity.x = horizontalMove * moveSpeed;
    velocity.y = verticalMove * moveSpeed;
    velocity.y += -1 * jumpSpeed;

    center.add((velocity * dt));

    if (horizontalMove < 0 && mainPlayer.scale.x > 0) {
      mainPlayer.flipHorizontallyAroundCenter();
    } else if (horizontalMove > 0 && mainPlayer.scale.x < 0) {
     mainPlayer.flipHorizontallyAroundCenter();
    }

    if (game.health <= 0) {
      game.setDirection(0, 0);
      removeFromParent();
    }
    super.update(dt);
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
}
