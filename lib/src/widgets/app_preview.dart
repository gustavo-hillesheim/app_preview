import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

class AppPreview extends StatefulWidget {
  const AppPreview({
    super.key,
    required this.appBuilder,
  });

  final WidgetBuilder appBuilder;

  @override
  State<AppPreview> createState() => _AppPreviewState();
}

class _AppPreviewState extends State<AppPreview> {
  Key _appKey = UniqueKey();
  DeviceInfo _device = Devices.ios.iPhone13ProMax;
  Orientation _orientation = Orientation.portrait;
  double? _optionsWidth;

  void _restartApp() {
    setState(() {
      _appKey = UniqueKey();
    });
  }

  void _changeDevice(DeviceInfo device) {
    setState(() {
      _device = device;
    });
  }

  void _changeOrientation() {
    setState(() {
      _orientation = _orientation == Orientation.portrait
          ? Orientation.landscape
          : Orientation.portrait;
    });
  }

  void _updateOptionsWidth(Size size) {
    setState(() {
      _optionsWidth = size.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _optionsWidth,
          child: PreviewOptions(
            onChangeDevice: _changeDevice,
            onRestartApp: _restartApp,
            onChangeOrientation: _changeOrientation,
          ),
        ),
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints.loose(_device.frameSize),
            child: SizeChangeDetector(
              onSizeChanged: _updateOptionsWidth,
              child: DeviceFrame(
                device: _device,
                orientation: _orientation,
                screen: KeyedSubtree(
                  key: _appKey,
                  child: widget.appBuilder(context),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
