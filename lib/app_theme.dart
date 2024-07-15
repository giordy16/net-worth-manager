import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff000000),
      surfaceTint: Color(0xff5e5e5e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff262626),
      onPrimaryContainer: Color(0xffb1b1b1),
      secondary: Color(0xff5d5f5f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffffff),
      onSecondaryContainer: Color(0xff575859),
      tertiary: Color(0xff00429e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff2565d7),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xfff9f9f9),
      onBackground: Color(0xff1b1b1b),
      surface: Color(0xfff9f9f9),
      onSurface: Color(0xff1b1b1b),
      surfaceVariant: Color(0xffebe0e1),
      onSurfaceVariant: Color(0xff4c4546),
      outline: Color(0xff7e7576),
      outlineVariant: Color(0xffcfc4c5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030),
      inverseOnSurface: Color(0xfff1f1f1),
      inversePrimary: Color(0xffc6c6c6),
      primaryFixed: Color(0xffe2e2e2),
      onPrimaryFixed: Color(0xff1b1b1b),
      primaryFixedDim: Color(0xffc6c6c6),
      onPrimaryFixedVariant: Color(0xff474747),
      secondaryFixed: Color(0xffe2e2e2),
      onSecondaryFixed: Color(0xff1a1c1c),
      secondaryFixedDim: Color(0xffc6c6c7),
      onSecondaryFixedVariant: Color(0xff454747),
      tertiaryFixed: Color(0xffd9e2ff),
      onTertiaryFixed: Color(0xff001945),
      tertiaryFixedDim: Color(0xffb0c6ff),
      onTertiaryFixedVariant: Color(0xff00419c),
      surfaceDim: Color(0xffdadada),
      surfaceBright: Color(0xfff9f9f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f3),
      surfaceContainer: Color(0xffeeeeee),
      surfaceContainerHigh: Color(0xffe8e8e8),
      surfaceContainerHighest: Color(0xffe2e2e2),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff000000),
      surfaceTint: Color(0xff5e5e5e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff262626),
      onPrimaryContainer: Color(0xffdcdcdc),
      secondary: Color(0xff414343),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff737575),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003e95),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff2565d7),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfff9f9f9),
      onBackground: Color(0xff1b1b1b),
      surface: Color(0xfff9f9f9),
      onSurface: Color(0xff1b1b1b),
      surfaceVariant: Color(0xffebe0e1),
      onSurfaceVariant: Color(0xff484142),
      outline: Color(0xff655d5e),
      outlineVariant: Color(0xff81787a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030),
      inverseOnSurface: Color(0xfff1f1f1),
      inversePrimary: Color(0xffc6c6c6),
      primaryFixed: Color(0xff747474),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff5c5c5c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff737575),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff5a5c5c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff336fe2),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff0155c7),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdadada),
      surfaceBright: Color(0xfff9f9f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f3),
      surfaceContainer: Color(0xffeeeeee),
      surfaceContainerHigh: Color(0xffe8e8e8),
      surfaceContainerHighest: Color(0xffe2e2e2),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff000000),
      surfaceTint: Color(0xff5e5e5e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff262626),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff202323),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff414343),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff001f53),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff003e95),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfff9f9f9),
      onBackground: Color(0xff1b1b1b),
      surface: Color(0xfff9f9f9),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xffebe0e1),
      onSurfaceVariant: Color(0xff282224),
      outline: Color(0xff484142),
      outlineVariant: Color(0xff484142),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030),
      inverseOnSurface: Color(0xffffffff),
      inversePrimary: Color(0xffececec),
      primaryFixed: Color(0xff434343),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff2d2d2d),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff414343),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2b2d2d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff003e95),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff002968),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdadada),
      surfaceBright: Color(0xfff9f9f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f3),
      surfaceContainer: Color(0xffeeeeee),
      surfaceContainerHigh: Color(0xffe8e8e8),
      surfaceContainerHighest: Color(0xffe2e2e2),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc6c6c6),
      surfaceTint: Color(0xffc6c6c6),
      onPrimary: Color(0xff303030),
      primaryContainer: Color(0xff000000),
      onPrimaryContainer: Color(0xff969696),
      secondary: Color(0xffffffff),
      onSecondary: Color(0xff2f3131),
      secondaryContainer: Color(0xffd4d4d4),
      onSecondaryContainer: Color(0xff3e4040),
      tertiary: Color(0xffb0c6ff),
      onTertiary: Color(0xff002c6f),
      tertiaryContainer: Color(0xff004cb3),
      onTertiaryContainer: Color(0xfff1f3ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      background: Color(0xFF0D1014),
      onBackground: Color(0xffe2e2e2),
      surface: Color(0xFF0D1014),
      onSurface: Color(0xffe2e2e2),
      surfaceVariant: Color(0xff4c4546),
      onSurfaceVariant: Color(0xffcfc4c5),
      outline: Color(0xff988e90),
      outlineVariant: Color(0xff4c4546),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e2),
      inverseOnSurface: Color(0xff303030),
      inversePrimary: Color(0xff5e5e5e),
      primaryFixed: Color(0xffe2e2e2),
      onPrimaryFixed: Color(0xff1b1b1b),
      primaryFixedDim: Color(0xffc6c6c6),
      onPrimaryFixedVariant: Color(0xff474747),
      secondaryFixed: Color(0xffe2e2e2),
      onSecondaryFixed: Color(0xff1a1c1c),
      secondaryFixedDim: Color(0xffc6c6c7),
      onSecondaryFixedVariant: Color(0xff454747),
      tertiaryFixed: Color(0xffd9e2ff),
      onTertiaryFixed: Color(0xff001945),
      tertiaryFixedDim: Color(0xffb0c6ff),
      onTertiaryFixedVariant: Color(0xff00419c),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff393939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1b1b1b),
      surfaceContainer: Color(0xff1f1f1f),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353535),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcbcbcb),
      surfaceTint: Color(0xffc6c6c6),
      onPrimary: Color(0xff161616),
      primaryContainer: Color(0xff919191),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffffff),
      onSecondary: Color(0xff2f3131),
      secondaryContainer: Color(0xffd4d4d4),
      onSecondaryContainer: Color(0xff1e2020),
      tertiary: Color(0xffb7caff),
      onTertiary: Color(0xff00143b),
      tertiaryContainer: Color(0xff578cff),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff131313),
      onBackground: Color(0xffe2e2e2),
      surface: Color(0xff131313),
      onSurface: Color(0xfffbfbfb),
      surfaceVariant: Color(0xff4c4546),
      onSurfaceVariant: Color(0xffd3c8c9),
      outline: Color(0xffaaa0a2),
      outlineVariant: Color(0xff8a8182),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e2),
      inverseOnSurface: Color(0xff2a2a2a),
      inversePrimary: Color(0xff484848),
      primaryFixed: Color(0xffe2e2e2),
      onPrimaryFixed: Color(0xff111111),
      primaryFixedDim: Color(0xffc6c6c6),
      onPrimaryFixedVariant: Color(0xff363636),
      secondaryFixed: Color(0xffe2e2e2),
      onSecondaryFixed: Color(0xff0f1112),
      secondaryFixedDim: Color(0xffc6c6c7),
      onSecondaryFixedVariant: Color(0xff343637),
      tertiaryFixed: Color(0xffd9e2ff),
      onTertiaryFixed: Color(0xff000f30),
      tertiaryFixedDim: Color(0xffb0c6ff),
      onTertiaryFixedVariant: Color(0xff00327b),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff393939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1b1b1b),
      surfaceContainer: Color(0xff1f1f1f),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353535),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffbfbfb),
      surfaceTint: Color(0xffc6c6c6),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffcbcbcb),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffffff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffd4d4d4),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffcfaff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffb7caff),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff131313),
      onBackground: Color(0xffe2e2e2),
      surface: Color(0xff131313),
      onSurface: Color(0xffffffff),
      surfaceVariant: Color(0xff4c4546),
      onSurfaceVariant: Color(0xfffff9f9),
      outline: Color(0xffd3c8c9),
      outlineVariant: Color(0xffd3c8c9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e2),
      inverseOnSurface: Color(0xff000000),
      inversePrimary: Color(0xff2a2a2a),
      primaryFixed: Color(0xffe7e7e7),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffcbcbcb),
      onPrimaryFixedVariant: Color(0xff161616),
      secondaryFixed: Color(0xffe6e7e7),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffcacbcb),
      onSecondaryFixedVariant: Color(0xff141717),
      tertiaryFixed: Color(0xffe0e6ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffb7caff),
      onTertiaryFixedVariant: Color(0xff00143b),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff393939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1b1b1b),
      surfaceContainer: Color(0xff1f1f1f),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353535),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary, 
    required this.surfaceTint, 
    required this.onPrimary, 
    required this.primaryContainer, 
    required this.onPrimaryContainer, 
    required this.secondary, 
    required this.onSecondary, 
    required this.secondaryContainer, 
    required this.onSecondaryContainer, 
    required this.tertiary, 
    required this.onTertiary, 
    required this.tertiaryContainer, 
    required this.onTertiaryContainer, 
    required this.error, 
    required this.onError, 
    required this.errorContainer, 
    required this.onErrorContainer, 
    required this.background, 
    required this.onBackground, 
    required this.surface, 
    required this.onSurface, 
    required this.surfaceVariant, 
    required this.onSurfaceVariant, 
    required this.outline, 
    required this.outlineVariant, 
    required this.shadow, 
    required this.scrim, 
    required this.inverseSurface, 
    required this.inverseOnSurface, 
    required this.inversePrimary, 
    required this.primaryFixed, 
    required this.onPrimaryFixed, 
    required this.primaryFixedDim, 
    required this.onPrimaryFixedVariant, 
    required this.secondaryFixed, 
    required this.onSecondaryFixed, 
    required this.secondaryFixedDim, 
    required this.onSecondaryFixedVariant, 
    required this.tertiaryFixed, 
    required this.onTertiaryFixed, 
    required this.tertiaryFixedDim, 
    required this.onTertiaryFixedVariant, 
    required this.surfaceDim, 
    required this.surfaceBright, 
    required this.surfaceContainerLowest, 
    required this.surfaceContainerLow, 
    required this.surfaceContainer, 
    required this.surfaceContainerHigh, 
    required this.surfaceContainerHighest, 
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
