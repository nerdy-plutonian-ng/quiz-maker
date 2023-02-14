import 'package:flutter/material.dart';

class AppNavItem {
  final String id;
  final String title;
  final String? description;
  final IconData? iconData;
  final String? destination;

  const AppNavItem(
      {required this.id,
      required this.title,
      this.description,
      this.iconData,
      this.destination});
}
