import 'package:flutter/material.dart';
import 'package:orison/src/utils/app_config.dart';

class RaisedAppButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;
  final double radius;
  final bool shadow;
  final Color color;
  final BoxShadow shadowTheme;

  const RaisedAppButton({
    Key key,
    @required this.child,
    this.gradient,
    this.width = double.maxFinite,
    this.height = 46.0,
    this.shadow = true,
    this.shadowTheme = AppConfig.boxShadowTheme,
    this.color = AppConfig.primaryColor,
    @required this.onPressed,
    this.radius = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        boxShadow: shadow ? [shadowTheme] : null,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: onPressed,
              child: Center(
                child: child,
              )),
        ),
      ),
    );
  }
}
