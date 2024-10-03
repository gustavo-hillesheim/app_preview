import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
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
  late final _devicePreviewStore = DevicePreviewStore(
    defaultDevice: _device,
    storage: DevicePreviewStorage.preferences(),
  );
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
    return ChangeNotifierProvider<DevicePreviewStore>.value(
      value: _devicePreviewStore,
      child: Column(
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
      ),
    );
  }
}

Widget previewAppBuilder(BuildContext context, Widget? child) {
  final isInitializedAndEnabled = context.select(
    (DevicePreviewStore store) => store.state.maybeMap(
      initialized: (initialized) => initialized.data.isEnabled,
      orElse: () => false,
    ),
  );

  if (!isInitializedAndEnabled) {
    return child!;
  }

  final inheritedTheme = Theme.of(context);
  return Theme(
    data: inheritedTheme.copyWith(
      platform: DevicePreview.platform(context),
      visualDensity: DevicePreview.visualDensity(context),
    ),
    child: child!,
  );
}
