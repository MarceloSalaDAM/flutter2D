import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../game/VideoGame.dart';

class SceneBody extends BodyComponent<VideoGame> {
  TiledObject tiledBody;

  SceneBody({required this.tiledBody});

  @override
  Future<void> onLoad() {
    // TODO: implement onLoad
    renderBody = true;
    return super.onLoad();
  }

  @override
  Body createBody() {
    late FixtureDef fixtureDef;

    ChainShape shape = ChainShape();
    List<Vector2> vertices = [];

    for (final point in tiledBody.polygon) {
      shape.vertices.add(Vector2(point.x, point.y));
    }
    Point point0 = tiledBody.polygon[0];
    shape.vertices.add(Vector2(point0.x, point0.y));

    fixtureDef = FixtureDef(shape);

    BodyDef definicionCuerpo = BodyDef(
        position: Vector2(tiledBody.x, tiledBody.y), type: BodyType.static);
    Body cuerpo = world.createBody(definicionCuerpo);

    //FixtureDef fixtureDef=FixtureDef(shape);
    cuerpo.createFixture(fixtureDef);
    return cuerpo;
  }
}
