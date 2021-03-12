import 'package:flutter/material.dart';

ButtonStyle orangeButtonStyle(ThemeData? theme) {
  return ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((value) {
    return theme!.accentColor;
  }));
}
