import 'package:flutter/material.dart';
import 'package:helloapp/mygame.dart';
import 'package:flame/game.dart';
void main() {
  final myGame=MySpriteGame();
  runApp(
    GameWidget(
      game: myGame,
    )
  );
}


