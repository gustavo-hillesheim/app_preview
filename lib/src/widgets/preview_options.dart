import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

class PreviewOptions extends StatelessWidget {
  const PreviewOptions({
    super.key,
    required this.onChangeDevice,
    required this.onToggleBrightness,
    required this.onRestartApp,
    required this.onChangeOrientation,
    required this.brightness,
  });

  final VoidCallback onChangeOrientation;
  final VoidCallback onRestartApp;
  final VoidCallback onToggleBrightness;
  final ValueChanged<DeviceInfo> onChangeDevice;
  final Brightness? brightness;

  @override
  Widget build(BuildContext context) {
    return IconTheme.merge(
      data: IconThemeData(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            tooltip: 'Alterar orientação',
            onPressed: onChangeOrientation,
            icon: const Icon(Icons.screen_rotation),
          ),
          IconButton(
            tooltip: 'Alterar tema',
            onPressed: onToggleBrightness,
            icon: Icon(
              brightness == Brightness.light
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
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
      ),
    );
  }
}
