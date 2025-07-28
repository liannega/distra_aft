// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
  MODO DE USO
  En cualquier parte donde tengas acceso al contexto puedes hacer uso de todos estos get
  Ejemplo:
  - context.colorScheme.primary
  - context.primary
  - context.size.width
  - context.width
  - context.isDarkMode
*/

extension CustomContext on BuildContext {
  //* Colors
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Color get primary => colorScheme.primary;
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimary => colorScheme.onPrimary;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;
  Color get secondary => colorScheme.secondary;
  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get onSecondary => colorScheme.onSecondary;
  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;
  Color get tertiary => colorScheme.tertiary;
  Color get tertiaryContainer => colorScheme.tertiaryContainer;
  Color get onTertiary => colorScheme.onTertiary;
  Color get onTertiaryContainer => colorScheme.onTertiaryContainer;
  Color get background => colorScheme.surface;
  Color get error => colorScheme.error;
  Color get errorContainer => colorScheme.errorContainer;
  Color get onError => colorScheme.onError;
  Color get onErrorContainer => colorScheme.onErrorContainer;
  Color get surface => colorScheme.surface;
  Color get onSurface => colorScheme.onSurface;
  Color get surfaceTint => colorScheme.surfaceTint;
  Color get surfaceVariant => colorScheme.surfaceContainerHighest;
  Brightness get brightness => colorScheme.brightness;
  bool get isLightMode => brightness == Brightness.light;
  bool get isDarkMode => brightness == Brightness.dark;

  //* Size
  Size get size => MediaQuery.sizeOf(this);
  double get width => size.width;
  double get height => size.height;

  //* TextTheme
  TextTheme get textTheme => Theme.of(this).textTheme; //Weight  Size  Spacing
  TextStyle get displayLarge => textTheme.displayLarge!; //57      64    0
  TextStyle get displayMedium => textTheme.displayMedium!; //45      52    0
  TextStyle get displaySmall => textTheme.displaySmall!; //36      44    0
  TextStyle get headlineLarge => textTheme.headlineLarge!; //32      40    0
  TextStyle get headlineMedium => textTheme.headlineMedium!; //28      36    0
  TextStyle get headlineSmall => textTheme.headlineSmall!; //24      32    0
  TextStyle get titleLarge => textTheme.titleLarge!; //22      28    0
  TextStyle get titleMedium => textTheme.titleMedium!; //16      24    0.15
  TextStyle get titleSmall => textTheme.titleSmall!; //14      20    0.1
  TextStyle get labelLarge => textTheme.labelLarge!; //14      20    0.1
  TextStyle get labelMedium => textTheme.labelMedium!; //12      16    0.5
  TextStyle get labelSmall => textTheme.labelSmall!; //11      16    0.5
  TextStyle get bodyLarge => textTheme.bodyLarge!; //16      24    0.15
  TextStyle get bodyMedium => textTheme.bodyMedium!; //14      20    0.25
  TextStyle get bodySmall => textTheme.bodySmall!; //12      16    0.4

  //* Position Global from current widget
  Rect? get currentWidgetPosition {
    final renderObject = findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }

  //* Width and Height from current widget
  double get currentWidgetWidth => currentWidgetPosition?.width ?? 0;
  double get currentWidgetHeight => currentWidgetPosition?.height ?? 0;

  //* Get all color scheme widget
  Widget get getAllColor {
    List<String> names = [
      "primary",
      "primaryContainer",
      "onPrimary",
      "onPrimaryContainer",
      "secondary",
      "secondaryContainer",
      "onSecondary",
      "onSecondaryContainer",
      "tertiary",
      "tertiaryContainer",
      "onTertiary",
      "onTertiaryContainer",
      "error",
      "errorContainer",
      "onError",
      "onErrorContainer",
      "background",
      "surface",
      "onSurface",
      "surfaceTint",
      "surfaceVariant",
    ];
    List<Color> colors = [
      primary,
      primaryContainer,
      onPrimary,
      onPrimaryContainer,
      secondary,
      secondaryContainer,
      onSecondary,
      onSecondaryContainer,
      tertiary,
      tertiaryContainer,
      onTertiary,
      onTertiaryContainer,
      error,
      errorContainer,
      onError,
      onErrorContainer,
      background,
      surface,
      onSurface,
      surfaceTint,
      surfaceVariant,
    ];
    int index = 0;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ...names.map((name) {
            final color = colors[index++ % colors.length];
            String colorCode =
                "#${color.value.toRadixString(16).padLeft(8, '0')}";
            // String colorCode = color.toString();
            // colorCode = colorCode.substring(6, colorCode.length - 1);
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(width: 1, color: Color(0xfff1f1f1)),
                ),
              ),
              title: Text(name),
              subtitle: Text(colorCode),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: colorCode));
                ScaffoldMessenger.of(this)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      content: Text("Color $colorCode copiado al portapapeles"),
                      backgroundColor: secondary,
                    ),
                  );
              },
            );
          }),
        ],
      ),
    );
  }
}
