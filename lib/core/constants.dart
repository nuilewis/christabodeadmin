import 'package:flutter/material.dart';

///Colours

///----Blues-----///
//const Color cPrimaryColor = Color(0xFFC8C3FF);
// const Color kLightBlue = Color(0xFFC0E8FF);
// const Color kBlueDark = Color(0xFF0755C7);
//
// const Color kBlue = Color(0xFF27A8F8);
// Color kBlue80 = const Color(0xFF27A8F8).withOpacity(.8);
// Color kBlue60 = const Color(0xFF27A8F8).withOpacity(.6);
// Color kBlue40 = const Color(0xFF27A8F8).withOpacity(.4);
// Color kBlue20 = const Color(0xFF27A8F8).withOpacity(.2);
//
// Color kPurple = const Color(0xFF4C14F3);
// Color kPurple80 = const Color(0xFF4C14F3).withOpacity(.8);
// Color kPurple60 = const Color(0xFF4C14F3).withOpacity(.6);
// Color kPurple40 = const Color(0xFF4C14F3).withOpacity(.4);
// Color kPurple20 = const Color(0xFF4C14F3).withOpacity(.2);
//
// const Color kDark = Color(0xFF2D2D2D);
// Color kDark80 = const Color(0xFF2D2D2D).withOpacity(.8);
// Color kDark60 = const Color(0xFF2D2D2D).withOpacity(.6);
// Color kDark40 = const Color(0xFF2D2D2D).withOpacity(.4);
// Color kDark20 = const Color(0xFF2D2D2D).withOpacity(.2);
//
// const Color kCardColorDarkTheme = Color.fromARGB(255, 53, 53, 53);
// const Color kCardColorLightTheme = Color.fromARGB(255, 239, 239, 239);
//
// ///------Fuchsia-------///
// const Color kFuchsiaLight = Color(0xFFFFC1D8);
// const Color kFuchsia = Color(0xFFFC4684);
// Color kFuchsia80 = const Color(0xFFFC4684).withOpacity(.8);
// Color kFuchsia60 = const Color(0xFFFC4684).withOpacity(.6);
// Color kFuchsia40 = const Color(0xFFFC4684).withOpacity(.4);
// Color kFuchsia20 = const Color(0xFFFC4684).withOpacity(.2);
// //const Color kFuchsia80 = Color(0xFFFF7DA9);
//
// ///-------Greens------///
// const Color kGreenLight = Color(0xFFBAF2E4);
//
// const Color kGreen = Color(0xFF20A663);
// Color kGreen80 = const Color(0xFF20A663).withOpacity(.8);
// Color kGreen60 = const Color(0xFF20A663).withOpacity(.6);
// Color kGreen40 = const Color(0xFF20A663).withOpacity(.4);
// Color kGreen20 = const Color(0xFF20A663).withOpacity(.2);
//

//
// ///----TextStyles----///
// const TextStyle kHeading = TextStyle(fontWeight: FontWeight.w600, fontSize: 28);
// const TextStyle kHeadingLight =
//     TextStyle(fontWeight: FontWeight.normal, fontSize: 28);
// const TextStyle kBody = TextStyle(fontWeight: FontWeight.normal, fontSize: 14);
// const TextStyle kBodyBold =
//     TextStyle(fontWeight: FontWeight.w600, fontSize: 14);
// const TextStyle kButtonText =
//     TextStyle(fontWeight: FontWeight.w600, fontSize: 16);
// const TextStyle kFootNote =
//     TextStyle(fontWeight: FontWeight.normal, fontSize: 11);
//
// ///----------Text Form Field styles ---------////
//
// InputDecoration camTextFieldDecoration = InputDecoration(
//   errorStyle: kBody.copyWith(color: kFuchsia),
//   errorBorder: OutlineInputBorder(
//     gapPadding: 4,
//     borderSide: const BorderSide(color: kFuchsia, width: 1),
//     borderRadius: BorderRadius.circular(kDefaultPadding),
//   ),
//   border: OutlineInputBorder(
//     gapPadding: 0,
//     borderSide: BorderSide.none,
//     borderRadius: BorderRadius.circular(kDefaultPadding),
//   ),
//   //isDense: false,
//   filled: true,
//   hintStyle: kBody,
//   fillColor: kLightBlue,
// );
//

///-------DateTime Constants -------////

Map<int, String> monthsOfYear = {
  1: "January",
  2: "February",
  3: "March",
  4: "April",
  5: "May",
  6: "June",
  7: "July",
  8: "August",
  9: "September",
  10: "October",
  11: "November",
  12: "December",
};

///-------Paddings--------///
const double kDefaultPadding = 16.0;
const double kDefaultPadding2x = 32.0;

///------Input Decorations-------///
class AppInputDecoration {
  static InputDecoration inputDecoration(BuildContext context) {
    return InputDecoration(
        errorStyle: AppTextStyles.bodyMedium
            .copyWith(color: Theme.of(context).colorScheme.error),
        errorBorder: OutlineInputBorder(
          gapPadding: 4,
          borderSide:
          BorderSide(color: Theme.of(context).colorScheme.error, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          gapPadding: 0,
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          gapPadding: 0,
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBorder: OutlineInputBorder(
          gapPadding: 0,
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          gapPadding: 0,
          borderSide: const BorderSide(width: 1, color: AppColours.blue60),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        isDense: true,
        fillColor: Theme.of(context).cardColor,
        hintStyle:
        AppTextStyles.bodyMedium.copyWith(color: AppColours.neutral50),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColours.black));
  }
}

///------Colours-------///
class AppColours {
  static const Color black = Color(0xFF1C1A22);
  static const Color white = Color(0xFFFFFBFF);

  ///-----------Purple---------///
  static const Color blueSeed = Color(0xFF001B3E);
  static const Color blue10 = Color(0xFF002F64);
  static const Color blue20 = Color(0xFF002F64);
  static const Color blue30 = Color(0xFF00458D);
  static const Color blue40 = Color(0xFF005DB9);
  static const Color blue50 = Color(0xFF0075E6);
  static const Color blue60 = Color(0xFF4090FF);
  static const Color blue70 = Color(0xFF7BACFF);
  static const Color blue80 = Color(0xFFAAC7FF);
  static const Color blue90 = Color(0xFFD6E3FF);
  static const Color blue95 = Color(0xFFECF0FF);
  static const Color blue99 = Color(0xFFFDFBFF);

  ///-----------Green---------///
  static const Color greenSeed = Color(0xFF0DCC70);
  static const Color green10 = Color(0xFF00210D);
  static const Color green20 = Color(0xFF00391B);
  static const Color green30 = Color(0xFF005229);
  static const Color green40 = Color(0xFF006D39);
  static const Color green50 = Color(0xFF008949);
  static const Color green60 = Color(0xFF00A65A);
  static const Color green70 = Color(0xFF00C46B);
  static const Color green80 = Color(0xFF3AE283);
  static const Color green90 = Color(0xFF5FFF9C);
  static const Color green95 = Color(0xFFC3FFCF);
  static const Color green99 = Color(0xFFF5FFF3);

  ///-----------Yellow---------///
  static const Color yellowSeed = Color(0xFFFECB48);
  static const Color yellow10 = Color(0xFF251A00);
  static const Color yellow20 = Color(0xFF3F2E00);
  static const Color yellow30 = Color(0xFF5A4300);
  static const Color yellow40 = Color(0xFF775A00);
  static const Color yellow50 = Color(0xFF967200);
  static const Color yellow60 = Color(0xFFB58A00);
  static const Color yellow70 = Color(0xFFD3A521);
  static const Color yellow80 = Color(0xFFF1C03D);
  static const Color yellow90 = Color(0xFFFFDF99);
  static const Color yellow95 = Color(0xFFFFEFD2);
  static const Color yellow99 = Color(0xFFFFFBFF);

  ///-----------Red---------///
  static const Color redSeed = Color(0xFFFF4C4C);
  static const Color red10 = Color(0xFF410004);
  static const Color red20 = Color(0xFF68000B);
  static const Color red30 = Color(0xFF930014);
  static const Color red40 = Color(0xFFBB1623);
  static const Color red50 = Color(0xFFDF3438);
  static const Color red60 = Color(0xFFFF5352);
  static const Color red70 = Color(0xFFFF8982);
  static const Color red80 = Color(0xFFFFB3AE);
  static const Color red90 = Color(0xFFFFDAD7);
  static const Color red95 = Color(0xFFFFEDEB);
  static const Color red99 = Color(0xFFFFFBFF);

  ///-----------Neutral---------///
  static const Color neutral10 = Color(0xFF1A1B1E);
  static const Color neutral20 = Color(0xFF313033);
  static const Color neutral30 = Color(0xFF48464A);
  static const Color neutral40 = Color(0xFF605D62);
  static const Color neutral50 = Color(0xFF79767A);
  static const Color neutral60 = Color(0xFF938F94);
  static const Color neutral70 = Color(0xFFAEAAAF);
  static const Color neutral80 = Color(0xFFCAC4CF);
  static const Color neutral90 = Color(0xFFE6E1E6);
  static const Color neutral95 = Color(0xFFF4EFF4);
  static const Color neutral99 = Color(0xFFFFFBFF);
}

///------Text Styles-------///
class AppTextStyles {
  ///---Display---//


  static TextStyle displayLarge = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 57,
    height: 1,
  );

  static TextStyle displayLargeAlt = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 57,
    height: 1,
    fontFamily: 'Gloock',
  );


  static TextStyle displayMedium = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 45,
    height: 1,
  );

  static TextStyle displayMediumAlt = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 45,
    height: 1,
    fontFamily: 'Gloock',
  );


  static TextStyle displaySmall = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 36,
    height: 1,
  );
  static TextStyle displaySmallAlt = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 36,
    height: 1,
    fontFamily: 'Gloock',
  );



  ///---Headline---///
  static TextStyle headlineLarge = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 32,
    height: 1,
  );
  static TextStyle headlineLargeAlt = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 32,
    height: 1,
    fontFamily: 'Gloock',
  );
  static TextStyle headlineMedium = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 28,
    height: 1,
  );
  static TextStyle headlineMediumAlt = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 28,
    height: 1,
    fontFamily: 'Gloock',);
  static TextStyle headlineSmall = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 24,
    height: 1,
  );
  static TextStyle headlineSmallAlt = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 24,
    height: 1,
    fontFamily: 'Gloock',);

  ///---Title---///
  static TextStyle titleLargeBold = const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 22,
    height: 1,
  );
  static TextStyle titleLarge = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 22,
    height: 1,
  );

  static TextStyle titleMediumBold = const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 16,
    height: 1,
  );
  static TextStyle titleMedium = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 1,
  );

  static TextStyle titleSmallBold = const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 14,
    height: 1,
  );
  static TextStyle titleSmall = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    height: 1,
  );

  ///---Body---///
  static TextStyle bodyLargeBold = const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 16,
    height: 1,
  );
  static TextStyle bodyLarge = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 1,
  );

  static TextStyle bodyMediumBold = const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 14,
  );
  static TextStyle bodyMedium = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
  );

  static TextStyle bodySmallBold = const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 12,
    height: 1,
  );
  static TextStyle bodySmall = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    height: 1,
  );
}
