import 'package:flutter/material.dart';

void showSnachBarMsg(String msg, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
