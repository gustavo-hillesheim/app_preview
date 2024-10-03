import 'dart:ui';

import 'package:flutter/material.dart';

class PreviewScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        ...super.dragDevices,
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
      };
}
