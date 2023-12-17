import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';

// ThemeData lightThemeData(BuildContext context) {
//   return ThemeData(
//     useMaterial3: true,
//     appBarTheme: appBarTheme,
//     primaryColor: kPurple80,
//     scaffoldBackgroundColor: Colors.white,
//     iconTheme: IconThemeData(color: kDark40),
//     primaryIconTheme: IconThemeData(color: kDark40),
//     cardTheme: CardTheme(
//       color: kCardColorLightTheme,
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(kDefaultPadding),
//       ),
//     ),
//     fontFamily: 'Poppins',
//     textTheme: TextTheme(
//       bodyLarge: kBodyBold.copyWith(color: kDark),
//       bodyMedium: kBody.copyWith(color: kDark),
//       displayLarge: kHeading.copyWith(color: kDark),
//       displayMedium: kHeadingLight.copyWith(color: kDark),
//     ),
//     colorScheme: ColorScheme.fromSeed(
//         seedColor: kPurple,
//         brightness: Brightness.light,
//         primary: kPurple80,
//         secondary: kGreen),
//   );
// }
//
// ///Dark Theme
//
// ThemeData darkThemeData(BuildContext context) {
//   return ThemeData(
//       appBarTheme: appBarTheme,
//       scaffoldBackgroundColor: Colors.black,
//       primaryColor: kPurple,
//       iconTheme: IconThemeData(color: Colors.white.withOpacity(.6)),
//       primaryIconTheme: IconThemeData(color: Colors.white.withOpacity(.6)),
//       cardTheme: CardTheme(
//         color: kCardColorDarkTheme,
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(kDefaultPadding),
//         ),
//       ),
//       fontFamily: 'Poppins',
//       textTheme: TextTheme(
//         bodyLarge: kBodyBold.copyWith(color: Colors.white),
//         bodyMedium: kBody.copyWith(color: Colors.white),
//         displayLarge: kHeading.copyWith(color: Colors.white),
//         displayMedium: kHeadingLight.copyWith(color: Colors.white),
//       ),
//       cardColor: kCardColorDarkTheme,
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: kPurple80,
//         brightness: Brightness.dark,
//         primary: kPurple80,
//         secondary: kGreen,
//       ));
// }
//
// AppBarTheme appBarTheme = const AppBarTheme(
//   backgroundColor: Colors.transparent,
//   foregroundColor: Colors.transparent,
//   surfaceTintColor: Colors.transparent,
//   systemOverlayStyle: SystemUiOverlayStyle.light,
//   elevation: 0,
// );
//




class AppThemeData {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColours.blueSeed,
    primaryColorLight: AppColours.blue60,
    primaryColorDark: AppColours.blue30,
    scaffoldBackgroundColor: AppColours.white,
    iconTheme: const IconThemeData(color: AppColours.black),
    primaryIconTheme: const IconThemeData(color: AppColours.black),
    cardTheme: CardTheme(
      color: AppColours.blue95,
      elevation: 0,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      )


    ),
    fontFamily: 'Plus Jakarta Sans',
    textTheme: TextTheme(
      displayLarge:
      AppTextStyles.displayLargeAlt.copyWith(color: AppColours.black),
      displayMedium:
      AppTextStyles.displayMediumAlt.copyWith(color: AppColours.black),
      displaySmall:
      AppTextStyles.displaySmallAlt.copyWith(color: AppColours.black),

      ///
      headlineLarge:
      AppTextStyles.headlineLargeAlt.copyWith(color: AppColours.black),
      headlineSmall:
      AppTextStyles.headlineSmallAlt.copyWith(color: AppColours.black),
      headlineMedium: AppTextStyles.headlineMediumAlt
          .copyWith(color: AppColours.black),

      ///
      titleLarge:
      AppTextStyles.titleLarge.copyWith(color: AppColours.black),
      titleMedium:
      AppTextStyles.titleMedium.copyWith(color: AppColours.black),
      titleSmall:
      AppTextStyles.titleSmall.copyWith(color: AppColours.black),

      ///
      bodyLarge:
      AppTextStyles.bodyLarge.copyWith(color: AppColours.black),
      bodyMedium:
      AppTextStyles.bodyMedium.copyWith(color: AppColours.black),
      bodySmall:
      AppTextStyles.bodySmall.copyWith(color: AppColours.black),
    ),
    appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        backgroundColor: Colors.transparent),
    cardColor: AppColours.blue95,
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        fixedSize: MaterialStatePropertyAll<Size>(Size.fromHeight(52)),
        padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 16)),
        elevation: MaterialStatePropertyAll<double>(0),
      ),
    ),
    chipTheme: ChipThemeData(
      labelStyle:
      AppTextStyles.bodyMedium.copyWith(color: AppColours.blue10),
      elevation: 0,
      selectedColor: AppColours.blue90,
      backgroundColor: AppColours.neutral95,
      side: BorderSide.none,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(32)),
    ),
    sliderTheme: const SliderThemeData(
        activeTickMarkColor: AppColours.blue40,
        inactiveTrackColor: AppColours.neutral90,
        trackHeight: 4,
        trackShape: RoundedRectSliderTrackShape(),
        thumbShape: RoundSliderThumbShape(
          elevation: 0,
          enabledThumbRadius: 18,
          disabledThumbRadius: 4,
          pressedElevation: 0,
        ),
        thumbColor: AppColours.white,
        overlayColor: Colors.transparent,
        overlayShape: RoundSliderOverlayShape(overlayRadius: 0)),
    switchTheme: SwitchThemeData(
      thumbColor: const MaterialStatePropertyAll<Color>(AppColours.white),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColours.blue40;
        }
        return AppColours.blue90;
      }),
      trackOutlineColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColours.blue40;
        }
        return AppColours.blue90;
      }),
      trackOutlineWidth: const MaterialStatePropertyAll<double>(0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppColours.blueSeed,
      primary: AppColours.blue40,
      onPrimary: AppColours.white,
      primaryContainer: AppColours.blue90,
      onPrimaryContainer: AppColours.blue10,
      error: AppColours.red50,
      onError: AppColours.white,
      errorContainer: AppColours.red90,
      onErrorContainer: AppColours.red10,
    ),
  );

  ///--------Dark Theme-------///
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColours.blue70,
    primaryColorLight: AppColours.blue90,
    primaryColorDark: AppColours.blue70,
    scaffoldBackgroundColor: AppColours.black,
    iconTheme: const IconThemeData(color: AppColours.white),
    primaryIconTheme: const IconThemeData(color: AppColours.white),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColours.blue10;
        }
        return AppColours.neutral70;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColours.blue70;
        }
        return AppColours.neutral20;
      }),
      trackOutlineColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColours.blue70;
        }
        return AppColours.neutral20;
      }),
      trackOutlineWidth: const MaterialStatePropertyAll<double>(0),
    ),
    cardTheme: CardTheme(
      color: AppColours.neutral20,
      elevation: 0,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    fontFamily: 'Plus Jakarta Sans',
    textTheme: TextTheme(
      displayLarge:
      AppTextStyles.displayLargeAlt.copyWith(color: AppColours.white),
      displayMedium:
      AppTextStyles.displayMediumAlt.copyWith(color: AppColours.white),
      displaySmall:
      AppTextStyles.displaySmallAlt.copyWith(color: AppColours.white),

      ///
      headlineLarge:
      AppTextStyles.headlineLargeAlt.copyWith(color: AppColours.white),
      headlineSmall:
      AppTextStyles.headlineSmallAlt.copyWith(color: AppColours.white),
      headlineMedium: AppTextStyles.headlineMediumAlt
          .copyWith(color: AppColours.white),

      ///
      titleLarge:
      AppTextStyles.titleLarge.copyWith(color: AppColours.white),
      titleMedium:
      AppTextStyles.titleMedium.copyWith(color: AppColours.white),
      titleSmall:
      AppTextStyles.titleSmall.copyWith(color: AppColours.white),

      ///
      bodyLarge:
      AppTextStyles.bodyLarge.copyWith(color: AppColours.white),
      bodyMedium:
      AppTextStyles.bodyMedium.copyWith(color: AppColours.white),
      bodySmall:
      AppTextStyles.bodySmall.copyWith(color: AppColours.white),
    ),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
    cardColor: AppColours.neutral20,
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        fixedSize: MaterialStatePropertyAll<Size>(Size.fromHeight(52)),
        padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 16)),
        elevation: MaterialStatePropertyAll<double>(0),
      ),
    ),
    chipTheme: ChipThemeData(
      elevation: 0,
      selectedColor: AppColours.blue70,
      backgroundColor: AppColours.neutral20,
      side: BorderSide.none,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(32)),
    ),
    sliderTheme: const SliderThemeData(
        activeTickMarkColor: AppColours.blue40,
        inactiveTrackColor: AppColours.neutral90,
        trackHeight: 4,
        trackShape: RoundedRectSliderTrackShape(),
        thumbShape: RoundSliderThumbShape(
          elevation: 0,
          enabledThumbRadius: 18,
          disabledThumbRadius: 4,
          pressedElevation: 0,
        ),
        thumbColor: AppColours.white,
        overlayColor: Colors.transparent,
        overlayShape: RoundSliderOverlayShape(overlayRadius: 0)),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: AppColours.blueSeed,
      primary: AppColours.blue70,
      onPrimary: AppColours.blue10,
      primaryContainer: AppColours.blue10,
      onPrimaryContainer: AppColours.blue95,
      error: AppColours.red60,
      onError: AppColours.white,
      errorContainer: AppColours.red10,
      onErrorContainer: AppColours.red90,
    ),
  );
}
