import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../package_asset_bundle.dart';
import 'widgets.dart';

class AppPreview extends StatefulWidget {
  const AppPreview({
    super.key,
    required this.appBuilder,
    this.packageName,
    this.storageKey,
  });

  final WidgetBuilder appBuilder;
  final String? packageName;
  final String? storageKey;

  @override
  State<AppPreview> createState() => _AppPreviewState();
}

class _AppPreviewState extends State<AppPreview> {
  Key _appKey = UniqueKey();
  late final _devicePreviewStore = DevicePreviewStore(
    defaultDevice: Devices.ios.iPhone13ProMax,
    storage: DevicePreviewStorage.preferences(
      preferenceKey: widget.storageKey ?? 'app_preview.settings',
    ),
  );
  Orientation _orientation = Orientation.portrait;
  double? _optionsWidth;

  @override
  void initState() {
    super.initState();
    _devicePreviewStore.initialize();
  }

  void _restartApp() {
    setState(() {
      _appKey = UniqueKey();
    });
  }

  void _changeDevice(DeviceInfo device) {
    _devicePreviewStore.selectDevice(device.identifier);
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
      child: Builder(builder: (context) {
        final isInitializedAndEnabled = context.select(
          (DevicePreviewStore store) => store.isInitialized,
        );
        if (!isInitializedAndEnabled) {
          return const SizedBox.shrink();
        }

        final selectedDevice = context.select(
          (DevicePreviewStore store) => store.deviceInfo,
        );

        Widget preview = Column(
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
                constraints: BoxConstraints.loose(selectedDevice.frameSize),
                child: SizeChangeDetector(
                  onSizeChanged: _updateOptionsWidth,
                  child: DeviceFrame(
                    device: selectedDevice,
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

        final packageName = widget.packageName;
        if (packageName != null && packageName.isNotEmpty) {
          preview = DefaultAssetBundle(
            bundle: PackageAssetBundle(packageName: packageName),
            child: preview,
          );
        }

        return preview;
      }),
    );
  }
}

Widget previewAppBuilder(BuildContext context, Widget? child) {
  final isInitializedAndEnabled = context.select(
    (DevicePreviewStore store) => store.isInitialized,
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

extension on DevicePreviewStore {
  bool get isInitialized => state.maybeMap(
        initialized: (initialized) => initialized.data.isEnabled,
        orElse: () => false,
      );
}
