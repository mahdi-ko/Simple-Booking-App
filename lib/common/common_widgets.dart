import 'package:flutter/material.dart';

ButtonStyle orangeButtonStyle(ThemeData? theme) {
  return ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((value) {
    return theme!.accentColor;
  }));
}
class HeaderText extends StatelessWidget {
  final String text;
  final ThemeData theme;
  const HeaderText(this.text, this.theme);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(text,
          style: theme.textTheme.headline5?.copyWith(shadows: [
            Shadow(
              color: Colors.grey.shade400,
              offset: Offset(2, 1.5),
            )
          ])),
    );
  }
}