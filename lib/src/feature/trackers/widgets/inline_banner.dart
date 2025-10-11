import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

/// Reusable inline notification banner that occupies layout space (no overlay).
///
/// Usage:
/// InlineBanner(
///   text: 'Кормление сохранено',
///   type: InlineBannerType.success,
///   onClose: () {},
/// )
enum InlineBannerType { success, info, warning, error }

class InlineBanner extends StatelessWidget {
  final String text;
  final InlineBannerType type;
  final VoidCallback? onClose;

  const InlineBanner({super.key, required this.text, this.type = InlineBannerType.info, this.onClose});

  Color get _borderColor {
    switch (type) {
      case InlineBannerType.success:
        return const Color(0xFF2C9C2A); // specified green
      case InlineBannerType.warning:
        return const Color(0xFFFFB020);
      case InlineBannerType.error:
        return const Color(0xFFE65757);
      case InlineBannerType.info:
      default:
        return const Color(0xFF4D4DE7);
    }
  }

  Color get _bgColor {
    switch (type) {
      case InlineBannerType.success:
        return const Color(0xFFE7F8EE);
      case InlineBannerType.warning:
        return const Color(0xFFFFF6E8);
      case InlineBannerType.error:
        return const Color(0xFFFDECEC);
      case InlineBannerType.info:
      default:
        return const Color(0xFFEFF1FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1),
      ),
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF2C9C2A),
                fontSize: 20,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
              ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onClose,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(AppIcons.xmark, color: Color(0xFFB0B4C3)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper controller widget that auto-hides after [duration]. Parent controls
/// visibility via [visible]. It still occupies space only when visible.
class AutoHideInlineBanner extends StatefulWidget {
  final bool visible;
  final Duration duration;
  final String text;
  final InlineBannerType type;
  final VoidCallback? onClosed;

  const AutoHideInlineBanner({
    super.key,
    required this.visible,
    required this.text,
    this.type = InlineBannerType.info,
    this.duration = const Duration(seconds: 10),
    this.onClosed,
  });

  @override
  State<AutoHideInlineBanner> createState() => _AutoHideInlineBannerState();
}

class _AutoHideInlineBannerState extends State<AutoHideInlineBanner> {
  Timer? _timer;

  @override
  void didUpdateWidget(covariant AutoHideInlineBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible && !oldWidget.visible) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(widget.duration, () {
      if (!mounted) return;
      widget.onClosed?.call();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return const SizedBox.shrink();
    return InlineBanner(
      text: widget.text,
      type: widget.type,
      onClose: widget.onClosed,
    );
  }
}


