import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

class DeviceSelector extends StatelessWidget {
  const DeviceSelector({
    super.key,
    required this.onSelected,
  });

  final ValueChanged<DeviceInfo> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<DeviceInfo>(
      constraints: const BoxConstraints.expand(height: 400),
      onSelected: onSelected,
      itemBuilder: (_) => [
        _buildSeparator('iOS'),
        ..._buildItems(Devices.ios.all),
        _buildSeparator('Android'),
        ..._buildItems(Devices.android.all),
      ],
      tooltip: 'Alterar dispositivo',
      icon: const Icon(Icons.devices),
    );
  }

  PopupMenuItem<DeviceInfo> _buildSeparator(String title) {
    return PopupMenuItem(
      enabled: false,
      child: Text(title),
    );
  }

  Iterable<PopupMenuItem<DeviceInfo>> _buildItems(List<DeviceInfo> devices) {
    return devices.map(
      (d) => PopupMenuItem<DeviceInfo>(
        value: d,
        child: Text(d.name),
      ),
    );
  }
}
