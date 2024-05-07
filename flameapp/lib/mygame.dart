import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';

class MySpriteGame extends Game with TapDetector {
  late SpriteAnimation runningRobot;
  late Sprite pressedButton;
  late Sprite unpressedButton;
  bool isPressed=false;
  final buttonPosition = Vector2(200,120);
  final buttonSize=Vector2(120,30);
  final robotPosition = Vector2(240,50);
  final robotSize=Vector2(48,60);

  @override
  Future<void> onLoad() async {
    runningRobot=await loadSpriteAnimation(
      'robot.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.1,
        textureSize: Vector2(16,18),
      ),
    );
    unpressedButton=await loadSprite(
      'buttons.png',
      srcPosition: Vector2.zero(),
      srcSize: Vector2(60,20),
    );
    pressedButton=await loadSprite(
      'buttons.png',
      srcPosition: Vector2(0,20),
      srcSize: Vector2(60,20),
    );    
  }
  @override
  void onTapDown(TapDownInfo event){
    final buttonArea = buttonPosition & buttonSize;
    isPressed=buttonArea.contains(event.eventPosition.game.toOffset());
  }
  @override
  void onTapUp(TapUpInfo event){
    isPressed=false;
  }
  @override
  void onTapCancel() {
    isPressed=false;
  }

  @override
  void render(Canvas canvas) {
    runningRobot
      .getSprite()
      .render(
        canvas,
        position:robotPosition,
        size: robotSize,
      );
    final button = isPressed ? pressedButton : unpressedButton;
    button.render(
      canvas,
      position: buttonPosition,
      size:buttonSize,
    );
  }
  
  @override
  void update(double dt) {
    if(isPressed) {
      runningRobot.update(dt);
    }
  }
  @override
  Color backgroundColor() => const Color(0xff222222);
}

class MyBoxGame extends Game {
  static const int squareSpeed=400;
  late Rect squarePos;
  int squareDirection=1;
  Future<void> onLoad() async {
    squarePos=Rect.fromLTWH(0, 0, 100, 100);
  }
  static final squarePaint=BasicPalette.white.paint();
  @override
  void render(Canvas canvas) {
    canvas.drawRect(squarePos,squarePaint);
  }
  @override
  void update(double dt) {
    squarePos=squarePos.translate(squareSpeed * squareDirection * dt, 0);
    if(squareDirection==1 && squarePos.right > size.x){
      squareDirection=-1;
    } else if(squareDirection==-1 && squarePos.left<0) {
      squareDirection=1;
    }
  }
}