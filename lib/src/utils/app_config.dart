import 'package:flutter/material.dart';

class AppConfig {
  static const Color primaryColor = const Color(0xffFF9900);
  static const Color primaryButtonColor = const Color(0xffFF9900);
  static const Color primaryColorDark = const Color(0xff2B265C);
  static const Color primaryColorLight = const Color(0xff61648C);
  static const Color primaryBackgroundColor = const Color(0xffF5F6F8);
  static const Color landingPageBackgroundColor = const Color(0xffFBFBFB);

  static const Color white = Colors.white;
  static const Color formFieldBackground = const Color(0xff96EDC6);
  static const Color grey = const Color(0xffC4C4C4);
  static const Color shadow = const Color(0xffE7EAF0);

  static const LinearGradient themeGradient = const LinearGradient(
    colors: colors,
  );

  static const Color hintTextColor = const Color(0xff707070);
  static const Color textFieldFillColor = const Color(0xffF8F8F8);

  static const Color primaryTextColor = const Color(0xff353535);

  static BoxShadow boxShadow = const BoxShadow(
    color: AppConfig.shadow,
    blurRadius: 15.0,
    offset: Offset(0.0, 8.0),
  );
  static const BoxShadow boxShadowTheme = const BoxShadow(
    color: const Color(0x65ff9e20),
    offset: const Offset(0, 5),
    blurRadius: 10,
  );
  static const BoxShadow boxShadowTile = const BoxShadow(
    color: AppConfig.shadow,
    offset: const Offset(0, 1),
    blurRadius: 4,
  );
  static const List<Color> colors = <Color>[
    primaryColorDark,
    primaryColor,
  ];

  static const Color titleFontColor = Colors.white;
  static const Color titleBlueFontColor = const Color(0xff005683);
  static const Color scaffoldBackgroundColor = Colors.white;
  static const Color labelBlueTextColor = const Color(0xff3044B5);
  static const Color blueUnderlineColor = const Color(0xff64CEE8);
  static const Color blueBottomNavigationColor = const Color(0xff64CEE8);
  static const Color bottomNavigationSelectedColor = const Color(0xffFF9900);
  static const Color bottomNavigationUnSelectedColor = const Color(0xff9D9D9D);
  static const Color orangeTextColor = const Color(0xffF96302);
  static const Color buttonSubtitleTextColor = const Color(0xffF7F4EF);
  static const Color lightFontColor = Color.fromRGBO(247, 244, 239, 0.5);
  static const Color darkFontColor = Color.fromRGBO(55, 55, 55, 1);
  static const Color darkFontColorWithOpacity = Color.fromRGBO(55, 55, 55, 0.7);
  static const Color darkRatingTextColor =const Color(0xff373737);
  static const Color starRatingColor =const Color(0xffECD35E);
  static const Color darkIconColor =const Color(0xff4D4E4E);
  static const Color detailsTextColor =const Color(0xff302B27);
  static const Color blueCircleColor =const Color(0xff64CEE8);
  static const Color textFieldTitleColor =const Color(0xff626263);
}
