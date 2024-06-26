import 'package:app/config/app_localization.dart';
import 'package:flutter/material.dart';

mixin AppUtil {
  String localize(String key) {
    return AppLocalization.current.localize(key);
  }

  double sizeWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double sizeHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  Future<void> pushPage(BuildContext context, Widget className) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => className,
        ));
  }

  Future<void> pushReplacement(BuildContext context, Widget className) {
    return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => className,
        ));
  }

  Future<void> pushRemoveUntil(BuildContext context, Widget className) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => className,
      ),
      (route) => false,
    );
  }

  void popUntilFirstRoute(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void popPage(BuildContext context, {dynamic result}) {
    Navigator.pop(context, result);
  }

  void unfocusInput(BuildContext context) {
    final focusScope = FocusScope.of(context);
    if (focusScope.hasFocus) focusScope.unfocus();
  }
}
