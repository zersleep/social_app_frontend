import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavItem {
  final IconData icon;
  final String label;
  const NavItem({required this.icon, required this.label});
}

class AnimatedNavBar extends StatefulWidget {
  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const AnimatedNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  State<AnimatedNavBar> createState() => _AnimatedNavBarState();
}

class _AnimatedNavBarState extends State<AnimatedNavBar>
    with SingleTickerProviderStateMixin {
  static const Color _accent = Color(0xFF5B4BFF);
  static const Color _pillBg = Color(0xFFEAE6FF);
  static const Color _inactive = Color(0xFF1A1A1A);

  final List<GlobalKey> _itemKeys = [];
  final GlobalKey _rowKey = GlobalKey();

  bool _isDragging = false;
  int _hoverIndex = -1;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _itemKeys.addAll(List.generate(widget.items.length, (_) => GlobalKey()));
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scaleAnim = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.length != _itemKeys.length) {
      _itemKeys
        ..clear()
        ..addAll(List.generate(widget.items.length, (_) => GlobalKey()));
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  int _indexAt(Offset globalPos) {
    for (int i = 0; i < _itemKeys.length; i++) {
      final ctx = _itemKeys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final topLeft = box.localToGlobal(Offset.zero);
      final rect = topLeft & box.size;
      final expanded = Rect.fromLTRB(
        rect.left,
        rect.top - 40,
        rect.right,
        rect.bottom + 40,
      );
      if (expanded.contains(globalPos)) return i;
    }
    final rowBox = _rowKey.currentContext?.findRenderObject() as RenderBox?;
    if (rowBox != null) {
      final rowTopLeft = rowBox.localToGlobal(Offset.zero);
      final rowRect = rowTopLeft & rowBox.size;
      if (globalPos.dx <= rowRect.left) return 0;
      if (globalPos.dx >= rowRect.right) return _itemKeys.length - 1;
    }
    return _hoverIndex;
  }

  void _handleStart(Offset globalPos) {
    final idx = _indexAt(globalPos);
    if (idx < 0) return;
    setState(() {
      _isDragging = true;
      _hoverIndex = idx;
    });
    _scaleController.forward();
    HapticFeedback.selectionClick();
    if (idx != widget.selectedIndex) {
      widget.onChanged(idx);
    }
  }

  void _handleUpdate(Offset globalPos) {
    if (!_isDragging) return;
    final idx = _indexAt(globalPos);
    if (idx < 0 || idx == _hoverIndex) return;
    setState(() => _hoverIndex = idx);
    HapticFeedback.selectionClick();
    widget.onChanged(idx);
  }

  void _handleEnd() {
    if (!_isDragging) return;
    setState(() {
      _isDragging = false;
      _hoverIndex = -1;
    });
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Center(
          child: Listener(
            onPointerDown: (e) => _handleStart(e.position),
            onPointerMove: (e) => _handleUpdate(e.position),
            onPointerUp: (_) => _handleEnd(),
            onPointerCancel: (_) => _handleEnd(),
            child: AnimatedBuilder(
              animation: _scaleAnim,
              builder: (context, child) {
                final scale = 1.0 + (_scaleAnim.value * 0.02);
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            0.06 + _scaleAnim.value * 0.08,
                          ),
                          blurRadius: 20 + _scaleAnim.value * 14,
                          offset: Offset(0, 6 + _scaleAnim.value * 4),
                        ),
                      ],
                    ),
                    child: child,
                  ),
                );
              },
              child: Row(
                key: _rowKey,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int index = 0; index < widget.items.length; index++) ...[
                    if (index > 0) const SizedBox(width: 4),
                    _NavBarItem(
                      key: _itemKeys[index],
                      item: widget.items[index],
                      isSelected: index == widget.selectedIndex,
                      isHovered:
                          _isDragging && index == _hoverIndex,
                      accent: _accent,
                      pillBg: _pillBg,
                      inactive: _inactive,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final bool isHovered;
  final Color accent;
  final Color pillBg;
  final Color inactive;

  const _NavBarItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isHovered,
    required this.accent,
    required this.pillBg,
    required this.inactive,
  });

  @override
  Widget build(BuildContext context) {
    final hoverScale = isHovered ? 1.18 : 1.0;
    final hoverLift = isHovered ? -0.15 : 0.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(
        horizontal: isSelected ? 16 : 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: isSelected ? pillBg : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSlide(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            offset: Offset(0, hoverLift),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutBack,
              scale: hoverScale,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: isSelected ? 1 : 0),
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return Icon(
                    item.icon,
                    color: Color.lerp(inactive, accent, value),
                    size: 24,
                  );
                },
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    child: child,
                  ),
                );
              },
              child: isSelected
                  ? Padding(
                      key: ValueKey(item.label),
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        item.label,
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
