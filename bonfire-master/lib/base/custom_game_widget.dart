import 'package:bonfire/util/mixins/pointer_detector.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// Widget used to run the Game
/// This widget also is responsible in capture gesture with `Listener`
class CustomGameWidget<T extends Game> extends StatelessWidget {
  /// instance of the game
  final T game;

  final Map<String, OverlayWidgetBuilder<T>>? overlayBuilderMap;

  final List<String>? initialActiveOverlays;

  const CustomGameWidget({
    Key? key,
    required this.game,
    this.overlayBuilderMap,
    this.initialActiveOverlays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Listener(
        onPointerDown: game is PointerDetector
            ? (PointerDownEvent d) => (game as PointerDetector).onPointerDown(d)
            : null,
        onPointerMove: game is PointerDetector
            ? (PointerMoveEvent d) => (game as PointerDetector).onPointerMove(d)
            : null,
        onPointerUp: game is PointerDetector
            ? (PointerUpEvent d) => (game as PointerDetector).onPointerUp(d)
            : null,
        onPointerCancel: game is PointerDetector
            ? (PointerCancelEvent d) =>
                (game as PointerDetector).onPointerCancel(d)
            : null,
        child: GameWidget(
          game: game,
          overlayBuilderMap: overlayBuilderMap,
          initialActiveOverlays: initialActiveOverlays,
        ),
      ),
    );
  }
}
