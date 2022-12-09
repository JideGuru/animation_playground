import 'package:animation_playground/animations/grid_magnification/fading_grid.dart';
import 'package:animation_playground/animations/grid_magnification/grid_magnification.dart';
import 'package:flutter/cupertino.dart';

List animationList = [
  AnimationPage(title: 'Fading Grid', page: FadingGrid()),
  AnimationPage(title: 'Grid Magnification', page: GridMagnification()),
];

class AnimationPage {
  final String title;
  final Widget page;

  AnimationPage({required this.title, required this.page});
}
