import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

GetSnackBar alert(String message, Color color, int duration) {
  return GetSnackBar(
    message: message,
    isDismissible: true,
    backgroundColor: color,
    duration: Duration(seconds: duration),
  );
}
