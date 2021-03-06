import 'dart:math';
import 'dart:ui';

import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/bonfire.dart';
import 'package:bonfire/map/map_paint.dart';
import 'package:bonfire/util/assets_loader.dart';
import 'package:bonfire/util/controlled_update_animation.dart';
import 'package:bonfire/util/vector2rect.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Tile extends GameComponent {
  Sprite? _sprite;
  ControlledUpdateAnimation? _animation;
  final double width;
  final double height;
  final String? type;
  late Vector2 _positionText;
  Paint? _paintText;
  final _loader = AssetsLoader();

  Tile(
    String spritePath,
    Vector2 position, {
    this.width = 32,
    this.height = 32,
    this.type,
  }) {
    this.position = generateRectWithBleedingPixel(position, width, height);
    if (spritePath.isNotEmpty) {
      Sprite.load(spritePath).then((value) => _sprite = value);
    }

    _positionText = position;
  }

  Tile.fromSprite(
    Future<Sprite> sprite,
    Vector2 position, {
    this.width = 32,
    this.height = 32,
    this.type,
    double offsetX = 0,
    double offsetY = 0,
  }) {
    _loader.add(AssetToLoad(sprite, (value) => this._sprite = value));
    this.position = generateRectWithBleedingPixel(position, width, height,
        offsetX: offsetX, offsetY: offsetY);

    _positionText = position;
  }

  Tile.fromAnimation(
    ControlledUpdateAnimation animation,
    Vector2 position, {
    this.width = 32,
    this.height = 32,
    this.type,
  }) {
    this._animation = animation;
    this.position = generateRectWithBleedingPixel(position, width, height);

    _positionText = position;
  }

  @override
  void render(Canvas canvas) {
    _animation?.render(canvas, position);
    _sprite?.renderFromVector2Rect(
      canvas,
      position,
      overridePaint: MapPaint.instance.paint,
    );

    if (gameRef.constructionMode && isVisibleInCamera()) {
      _drawGrid(canvas);
    }
    super.render(canvas);
  }

  void _drawGrid(Canvas canvas) {
    if (_paintText == null) {
      _paintText = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
    }
    canvas.drawRect(
      position.rect,
      _paintText!
        ..color = gameRef.constructionModeColor ?? Colors.cyan.withOpacity(0.5),
    );
    if (_positionText.x % 2 == 0) {
      TextConfig(
        fontSize: width / 3.5,
      )
          .withColor(
            gameRef.constructionModeColor ?? Colors.cyan.withOpacity(0.5),
          )
          .render(
            canvas,
            '${_positionText.x.toInt()}:${_positionText.y.toInt()}',
            Vector2(position.rect.left + 2, position.rect.top + 2),
          );
    }
  }

  Vector2Rect generateRectWithBleedingPixel(
    Vector2 position,
    double width,
    double height, {
    double offsetX = 0,
    double offsetY = 0,
  }) {
    double sizeMax = max(width, height);
    double bleendingPixel = sizeMax * 0.04;
    if (bleendingPixel > 3) {
      bleendingPixel = 3;
    }
    return Rect.fromLTWH(
      (position.x * width) -
          (position.x % 2 == 0 ? (bleendingPixel / 2) : 0) +
          offsetX,
      (position.y * height) -
          (position.y % 2 == 0 ? (bleendingPixel / 2) : 0) +
          offsetY,
      width + (position.x % 2 == 0 ? bleendingPixel : 0),
      height + (position.y % 2 == 0 ? bleendingPixel : 0),
    ).toVector2Rect();
  }

  @override
  void update(double dt) {
    _animation?.update(dt);
    super.update(dt);
  }

  @override
  Future<void> onLoad() async {
    await _loader.load();
    await _animation?.onLoad();
  }
}
