import 'package:flutter/material.dart';

List animationList = [
  AnimationPage(
    title: 'Fading Grid',
    route: '/fading-grid',
    icon: Icons.grid_view_rounded,
  ),
  AnimationPage(
    title: 'Grid Magnification',
    route: '/grid-magnification',
    icon: Icons.grid_view_rounded,
  ),
  AnimationPage(
    title: '3D Card',
    route: '/3d-card',
    icon: Icons.threed_rotation,
  ),
  AnimationPage(
    title: 'Bouncing DVD',
    route: '/bouncing-dvd',
    icon: Icons.animation,
  ),
  AnimationPage(
    title: 'Clock Loader',
    route: '/clock-loader',
    icon: Icons.access_time_rounded,
  ),
  AnimationPage(
    title: 'Rain',
    route: '/rain',
    icon: Icons.thunderstorm_outlined,
  ),
  AnimationPage(
    title: 'Fractal Pyramid Shader',
    route: '/pyramid-shader',
    icon: Icons.animation,
  ),
  AnimationPage(
    title: 'Metaball FAB',
    route: '/metaball-fab',
    icon: Icons.animation,
  ),
  AnimationPage(
    title: 'Simple Particle System',
    route: '/simple-particle-system',
    icon: Icons.animation,
  ),
  AnimationPage(
    title: 'The Bouncing Ball',
    route: '/bouncing-ball',
    icon: Icons.sports_baseball,
  ),
];

class AnimationPage {
  final String title;
  final String route;
  final IconData icon;

  AnimationPage({required this.title, required this.route, required this.icon});
}
