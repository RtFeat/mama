import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

import 'animated_text.dart';
import 'avatar.dart';

class ProfileSwitch extends StatefulWidget {
  final List<ChildModel?> children;
  final Alignment alignment;
  final bool isShowText;
  final UserStore userStore;
  final Function()? onTap;
  const ProfileSwitch({
    super.key,
    this.onTap,
    required this.userStore,
    required this.children,
    this.alignment = Alignment.centerRight,
    this.isShowText = false,
  });

  @override
  State<ProfileSwitch> createState() => _ProfileSwitchState();
}

class _ProfileSwitchState extends State<ProfileSwitch> {
  int _currentIndex = 0;
  int _nextIndex = 1;
  bool _isAnimating = false;

  ChildModel? _selectedChild;
  ChildModel? _nextChild;

  @override
  void initState() {
    super.initState();
    _nextIndex = (_currentIndex + 1) % widget.children.length;
    _selectedChild = widget.children[_currentIndex];
    _nextChild = widget.children[_nextIndex];
  }

  void _toggleCircles() {
    // if (_isAnimating) return;
    setState(() {
      _isAnimating = !_isAnimating;

      _currentIndex = (_currentIndex + 1) % widget.children.length;
      _nextIndex = (_currentIndex + 1) % widget.children.length;
      final selectedChild = widget.children[_currentIndex];
      _selectedChild = selectedChild;
      _nextChild = widget.children[_nextIndex];
      if (selectedChild != null) {
        widget.userStore.selectChild(child: selectedChild);
      }
    });

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    const double startPos = 25;
    const double endPos = 0;

    final firstCircle = _isAnimating ? startPos : endPos;
    final secondCircle = _isAnimating ? endPos : startPos;

    final bool isOnRight = widget.alignment == Alignment.centerRight;

    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.isShowText)
            Positioned(
              right: 100,
              child: Column(
                children: [
                  AnimatedText(
                    isSwitched: _isAnimating,
                    title: _selectedChild?.firstName ?? '',
                  ),
                  Text(
                    t.home.switch_hint,
                    style: textTheme.bodySmall!.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
          // Нижний аватар
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: !isOnRight ? firstCircle : null,
            right: isOnRight ? firstCircle : null,
            child: GestureDetector(
              onTap: _toggleCircles,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: CustomAvatar(
                  radius: _isAnimating ? 25 : 20,
                  key: ValueKey<int>(_currentIndex),
                  avatarUrl: _isAnimating
                      ? _selectedChild?.avatarUrl
                      : _nextChild?.avatarUrl,
                ),
              ),
            ),
          ),
          // Верхний аватар
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: !isOnRight ? secondCircle : null,
            right: isOnRight ? secondCircle : null,
            child: GestureDetector(
              onTap: _toggleCircles,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: CustomAvatar(
                  key: ValueKey<int>(_nextIndex),
                  avatarUrl: _isAnimating
                      ? _nextChild?.avatarUrl
                      : _selectedChild?.avatarUrl,
                  radius: _isAnimating ? 20 : 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
