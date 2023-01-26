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
    icon: Icons.disc_full,
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
    title: 'Loader XLVII',
    route: '/loader-xlvii',
    icon: Icons.face,
  ),
  AnimationPage(
    title: 'Circle Menu',
    route: '/circle-menu',
    icon: Icons.menu_open,
  ),
  AnimationPage(
    title: 'Fireworks',
    route: '/fireworks',
    icon: Icons.celebration,
  ),
];

class AnimationPage {
  final String title;
  final String route;
  final IconData icon;

  AnimationPage({required this.title, required this.route, required this.icon});
}
