import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

class PreviewOptions extends StatelessWidget {
  const PreviewOptions({
    super.key,
    required this.onChangeDevice,
    required this.onRestartApp,
    required this.onChangeOrientation,
  });

  final VoidCallback onChangeOrientation;
  final VoidCallback onRestartApp;
  final ValueChanged<DeviceInfo> onChangeDevice;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          tooltip: 'Alterar orientação',
          onPressed: onChangeOrientation,
          icon: const Icon(Icons.screen_rotation),
        ),
        DeviceSelector(
          onSelected: onChangeDevice,
        ),
        IconButton(
          tooltip: 'Reiniciar aplicativo',
          onPressed: onRestartApp,
          icon: const Icon(Icons.restart_alt),
        ),
      ],
    );
  }
}
