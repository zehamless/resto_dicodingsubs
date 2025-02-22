import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/provider/style/theme_provider.dart';

class ThemeChanger extends StatelessWidget {
  final bool label;

  const ThemeChanger({super.key, this.label = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final icon = Icon(
          themeProvider.themeMode == ThemeMode.light
              ? Icons.dark_mode
              : Icons.light_mode,
        );
        final text = Text(
          themeProvider.themeMode == ThemeMode.light ? 'Light' : 'Dark',
        );

        return InkWell(
          onTap: themeProvider.toggleTheme,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                icon,
                if (label) ...[
                  const SizedBox(width: 8),
                  text,
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
