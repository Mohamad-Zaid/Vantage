import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vantage/core/theme/vantage_colors.dart';

// Full-screen success animation: stays on top through [onComplete], then removes after two frames so the next route can commit without flashing the old screen.
class VantageSuccessBurstOverlay extends StatefulWidget {
  const VantageSuccessBurstOverlay._({
    required this.origin,
    required this.onSequenceComplete,
  });

  final Offset origin;
  final VoidCallback onSequenceComplete;

  // [origin] must be in the root overlay’s coordinate space (not screen-global).
  static Offset originInOverlayForButton(
    BuildContext context, {
    required GlobalKey buttonKey,
    required Offset fallback,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    final buttonBox =
        buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (overlayBox == null ||
        !overlayBox.hasSize ||
        buttonBox == null ||
        !buttonBox.hasSize) {
      return fallback;
    }
    final global = buttonBox.localToGlobal(
      Offset(buttonBox.size.width / 2, buttonBox.size.height / 2),
    );
    return overlayBox.globalToLocal(global);
  }

  static void show(
    BuildContext context, {
    required Offset origin,
    required VoidCallback onComplete,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry entry;
    void onSequenceComplete() {
      onComplete();
      // Two frames: first commits navigation, second removes overlay to avoid a one-frame flash of the previous page.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          entry.remove();
        });
      });
    }

    entry = OverlayEntry(
      builder: (ctx) => VantageSuccessBurstOverlay._(
        origin: origin,
        onSequenceComplete: onSequenceComplete,
      ),
    );
    overlay.insert(entry);
  }

  @override
  State<VantageSuccessBurstOverlay> createState() =>
      _VantageSuccessBurstOverlayState();
}

class _VantageSuccessBurstOverlayState extends State<VantageSuccessBurstOverlay>
    with TickerProviderStateMixin {
  static const _circleDuration = Duration(milliseconds: 520);
  static const _checkDuration = Duration(milliseconds: 480);
  static const _holdAfterCheck = Duration(milliseconds: 1000);

  late final AnimationController _circleController;
  late final AnimationController _checkController;
  late final Animation<double> _circleScale;
  late final Animation<double> _checkProgress;

  @override
  void initState() {
    super.initState();
    _circleController = AnimationController(
      vsync: this,
      duration: _circleDuration,
    );
    _checkController = AnimationController(
      vsync: this,
      duration: _checkDuration,
    );
    _circleScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _circleController,
        curve: Curves.easeOutCubic,
      ),
    );
    _checkProgress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _checkController,
        curve: Curves.easeOutCubic,
      ),
    );
    _run();
  }

  Future<void> _run() async {
    await _circleController.forward();
    if (!mounted) return;
    await _checkController.forward();
    if (!mounted) return;
    await Future<void>.delayed(_holdAfterCheck);
    if (!mounted) return;
    widget.onSequenceComplete();
  }

  @override
  void dispose() {
    _circleController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final primary = VantageColors.primary;
    final diameter = math.max(size.width, size.height) * 2.6;
    final r = diameter / 2;
    final left = widget.origin.dx - r;
    final top = widget.origin.dy - r;

    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: left,
            top: top,
            width: diameter,
            height: diameter,
            child: AnimatedBuilder(
              animation: _circleController,
              builder: (context, _) {
                return ScaleTransition(
                  scale: _circleScale,
                  alignment: Alignment.center,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.35),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Positioned.fill(
            child: AbsorbPointer(child: SizedBox.expand()),
          ),
          Center(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _checkController,
                builder: (context, _) {
                  return CustomPaint(
                    size: const Size(96, 96),
                    painter: _CheckmarkStrokePainter(
                      progress: _checkProgress.value,
                      color: Colors.white,
                      strokeWidth: 4,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckmarkStrokePainter extends CustomPainter {
  _CheckmarkStrokePainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final w = size.width;
    final h = size.height;
    final a = Offset(0.16 * w, 0.52 * h);
    final b = Offset(0.44 * w, 0.78 * h);
    final c = Offset(0.90 * w, 0.22 * h);
    final len1 = (b - a).distance;
    final len2 = (c - b).distance;
    final total = len1 + len2;
    if (total < 0.5) return;
    var remaining = (total * progress).clamp(0.0, total);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;
    if (remaining <= 0) return;
    if (remaining >= len1) {
      canvas.drawLine(a, b, paint);
      remaining -= len1;
      if (remaining > 0) {
        final t = (remaining / len2).clamp(0.0, 1.0);
        canvas.drawLine(b, b + (c - b) * t, paint);
      }
    } else {
      final t = (remaining / len1).clamp(0.0, 1.0);
      canvas.drawLine(a, a + (b - a) * t, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CheckmarkStrokePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
