import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'widgets/widgets.dart';

class AppPreviewPage extends StatefulWidget {
  const AppPreviewPage({
    super.key,
    required this.appBuilder,
    this.allowMultipleInstances,
    this.packageName,
  });

  final WidgetBuilder appBuilder;
  final bool? allowMultipleInstances;
  final String? packageName;

  @override
  State<AppPreviewPage> createState() => _AppPreviewPageState();
}

class _AppPreviewPageState extends State<AppPreviewPage> {
  final _apps = <Widget>[];

  @override
  void initState() {
    super.initState();
    _createNewApp();
  }

  void _createNewApp() {
    final instanceId = _apps.length + 1;
    _apps.add(
      AppPreview(
        appBuilder: widget.appBuilder,
        packageName: widget.packageName,
        storageKey: 'app_preview_$instanceId.settings',
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final maximumPreviewWidth = MediaQuery.sizeOf(context).width * 0.8;

    return Scaffold(
      body: DifferentlySizedPageView(
        padding: const EdgeInsets.all(32),
        children: [
          for (final app in _apps)
            _AppContainer(
              packageName: widget.packageName,
              maxWidth: maximumPreviewWidth,
              child: app,
            ),
          if (widget.allowMultipleInstances ?? false)
            _AppContainer(
              maxWidth: maximumPreviewWidth,
              child: _NewInstanceButton(
                onPressed: _createNewApp,
              ),
            ),
        ],
      ),
    );
  }
}

class _AppContainer extends StatelessWidget {
  const _AppContainer({
    required this.maxWidth,
    required this.child,
    this.packageName,
  });

  final double maxWidth;
  final Widget child;
  final String? packageName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      constraints: BoxConstraints(maxWidth: maxWidth),
      // Column usada para alinhamento pois ela não expande
      // horizontalmente, como é feito pelos outros Widgets de alinhamento
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: child),
        ],
      ),
    );
  }
}

class _NewInstanceButton extends StatelessWidget {
  const _NewInstanceButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final device = Devices.ios.iPhone13;

    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.grey.withOpacity(0.5),
            BlendMode.srcIn,
          ),
          child: DeviceFrame(
            device: device,
            screen: const SizedBox.shrink(),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: ElevatedButton(
              onPressed: onPressed,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('Criar nova instância'),
            ),
          ),
        ),
      ],
    );
  }
}
