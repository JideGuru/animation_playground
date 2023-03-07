import 'package:animation_playground/list_page.dart';
import 'package:animation_playground/shaders/barrel.dart';
import 'package:flutter/material.dart';

import 'animations/card/barrel.dart';
import 'animations/coding_train_challenges/barrel.dart';
import 'animations/grid_magnification/barrel.dart';
import 'animations/loaders/barrel.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => const ListPage(),
  '/fading-grid': (context) => const FadingGrid(),
  '/grid-magnification': (context) => const GridMagnification(),
  '/3d-card': (context) => const ThreeDimensionalCard(),
  '/bouncing-dvd': (context) => const BouncingDVD(),
  '/clock-loader': (context) => const ClockLoader(),
  '/rain': (context) => const RainAnimation(),
  '/pyramid-shader': (context) => const PyramidShader(),
  '/metaball-fab': (context) => const MetaballFAB(),
  '/simple-particle-system': (context) => const SimpleParticleSystem(),
  '/bouncing-ball': (context) => const BouncingBall(),
  '/particle-system-with-emitters': (context) =>
      const ParticleSystemWithEmitters(),
  '/painting-with-pixels': (context) => const PaintingWithPixels(),
};
