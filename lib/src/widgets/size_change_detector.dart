import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SizeChangeDetector extends StatefulWidget {
  const SizeChangeDetector({
    super.key,
    required this.child,
    required this.onSizeChanged,
  });

  final Widget child;
  final ValueChanged<Size> onSizeChanged;

  @override
  State<SizeChangeDetector> createState() => _SizeChangeDetectorState();
}

class _SizeChangeDetectorState extends State<SizeChangeDetector>
    with AutomaticKeepAliveClientMixin {
  Size? _lastSize;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scheduleNotifySize();
  }

  void _scheduleNotifySize() {
    SchedulerBinding.instance.addPostFrameCallback((_) => _notifySize());
  }

  void _notifySize() {
    if (mounted) {
      final renderObject = context.findRenderObject();
      if (renderObject is RenderBox) {
        if (renderObject.size != _lastSize) {
          _lastSize = renderObject.size;
          widget.onSizeChanged(renderObject.size);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        _scheduleNotifySize();
        return false;
      },
      child: SizeChangedLayoutNotifier(
        child: widget.child,
      ),
    );
  }
}
