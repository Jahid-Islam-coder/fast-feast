import 'package:flutter/material.dart';

/// Reusable animated card wrapper that handles:
/// 1. Subtle entrance scale & fade-in when the card first appears.
/// 2. Smooth scale-down press feedback on user tap.
class AnimatedPressCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration entranceDuration;
  final double pressScale;

  const AnimatedPressCard({
    super.key,
    required this.child,
    this.onTap,
    this.entranceDuration = const Duration(milliseconds: 350),
    this.pressScale = 0.96,
  });

  @override
  State<AnimatedPressCard> createState() => _AnimatedPressCardState();
}

class _AnimatedPressCardState extends State<AnimatedPressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  double _currentPressScale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.entranceDuration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      setState(() {
        _currentPressScale = widget.pressScale;
      });
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      setState(() {
        _currentPressScale = 1.0;
      });
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      setState(() {
        _currentPressScale = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasTap = widget.onTap != null;
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTapDown: hasTap ? _onTapDown : null,
          onTapUp: hasTap ? _onTapUp : null,
          onTapCancel: hasTap ? _onTapCancel : null,
          onTap: widget.onTap,
          behavior: hasTap ? HitTestBehavior.translucent : HitTestBehavior.deferToChild,
          child: AnimatedScale(
            scale: _currentPressScale,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeInOut,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// Reusable bounce scale widget for Add-To-Cart actions.
class AnimatedAddToCartButton extends StatefulWidget {
  final Future<void> Function() onTap;
  final Widget child;

  const AnimatedAddToCartButton({
    super.key,
    required this.onTap,
    required this.child,
  });

  @override
  State<AnimatedAddToCartButton> createState() => _AnimatedAddToCartButtonState();
}

class _AnimatedAddToCartButtonState extends State<AnimatedAddToCartButton> {
  double _scale = 1.0;

  Future<void> _handleTap() async {
    setState(() => _scale = 1.25);
    await Future.delayed(const Duration(milliseconds: 120));
    if (mounted) {
      setState(() => _scale = 0.9);
      await Future.delayed(const Duration(milliseconds: 80));
      if (mounted) {
        setState(() => _scale = 1.0);
      }
    }
    await widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}

/// Reusable bounce widget for cart badge updates in app bars / navigation bar.
class AnimatedCartBadge extends StatefulWidget {
  final int count;
  final Widget child;

  const AnimatedCartBadge({
    super.key,
    required this.count,
    required this.child,
  });

  @override
  State<AnimatedCartBadge> createState() => _AnimatedCartBadgeState();
}

class _AnimatedCartBadgeState extends State<AnimatedCartBadge> {
  double _scale = 1.0;

  @override
  void didUpdateWidget(covariant AnimatedCartBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count && widget.count > 0) {
      _bounce();
    }
  }

  Future<void> _bounce() async {
    if (!mounted) return;
    setState(() => _scale = 1.35);
    await Future.delayed(const Duration(milliseconds: 150));
    if (mounted) {
      setState(() => _scale = 0.9);
      await Future.delayed(const Duration(milliseconds: 90));
      if (mounted) {
        setState(() => _scale = 1.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.elasticOut,
      child: widget.child,
    );
  }
}
