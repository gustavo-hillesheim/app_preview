import 'dart:math';

import 'package:app_preview/app_preview.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class AppPreviewPage<T> extends StatefulWidget {
  const AppPreviewPage({
    super.key,
    required this.appBuilder,
    this.initialVariation,
    this.availableVariations,
    this.allowMultipleInstances,
    this.packageName,
    this.isolateAppInstances,
  });

  final PreviewBuilder<T> appBuilder;
  final PreviewVariation<T>? initialVariation;
  final List<PreviewVariation<T>>? availableVariations;
  final bool? allowMultipleInstances;
  final String? packageName;
  final bool? isolateAppInstances;

  @override
  State<AppPreviewPage> createState() => _AppPreviewPageState<T>();
}

class _AppPreviewPageState<T> extends State<AppPreviewPage<T>> {
  final _appInstances = <_AppInstance<T>>[];
  int _ids = 0;

  @override
  void initState() {
    super.initState();
    _createNewApp(widget.initialVariation);
  }

  void _createNewApp(PreviewVariation<T>? variation) {
    setState(() {
      final id = Random().nextDouble().toString().split('.').last;
      final storageKey = 'app_preview_${_ids++}.settings';
      _appInstances.add(_AppInstance(
        id: id,
        storageKey: storageKey,
        variation: variation,
      ));
    });
  }

  void _removeInstanceById(String id) {
    setState(() {
      _appInstances.removeWhere((i) => i.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final maximumPreviewWidth = MediaQuery.sizeOf(context).width * 0.8;

    return Scaffold(
      body: DifferentlySizedPageView(
        padding: const EdgeInsets.all(32),
        items: [
          for (final instance in _appInstances)
            DifferentlySizedPageViewItem(
              key: ValueKey(instance.id),
              child: _AppContainer(
                packageName: widget.packageName,
                maxWidth: maximumPreviewWidth,
                child: AppPreview<T>(
                  key: ValueKey(instance.id),
                  appBuilder: widget.appBuilder,
                  variation: instance.variation,
                  availableVariations: widget.availableVariations,
                  packageName: widget.packageName,
                  storageKey: instance.storageKey,
                  isolateAppInstances: widget.isolateAppInstances,
                  onDeleteInstance: _appInstances.length > 1
                      ? () => _removeInstanceById(instance.id)
                      : null,
                ),
              ),
            ),
          if (widget.allowMultipleInstances ?? false)
            DifferentlySizedPageViewItem(
              child: _AppContainer(
                maxWidth: maximumPreviewWidth,
                child: _NewInstanceButton(
                  onPressed: () => _createNewApp(null),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AppInstance<T> {
  const _AppInstance({
    required this.id,
    required this.storageKey,
    required this.variation,
  });

  final String id;
  final String storageKey;
  final PreviewVariation<T>? variation;
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
    final colors = Theme.of(context).colorScheme;

    return DeviceFrame(
      device: device,
      screen: Material(
        color: colors.inverseSurface.withAlpha(25),
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                const Icon(Icons.add),
                Text(
                  'Criar nova instância',
                  style: TextStyle(color: colors.onSurface),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
