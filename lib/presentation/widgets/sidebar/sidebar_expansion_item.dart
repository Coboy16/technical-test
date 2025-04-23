import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:technical_test/presentation/resources/resources.dart';
import './constants.dart';
import 'expansion_children_wrapper.dart';
import 'sidebar_item.dart';

class SidebarExpansionItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<SidebarItem> children;
  final List<String> childrenRoutes;
  final bool isParentSelected;
  final bool initiallyExpanded;
  final bool? forceExpanded;

  const SidebarExpansionItem({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    required this.childrenRoutes,
    required this.isParentSelected,
    this.initiallyExpanded = false,
    this.forceExpanded,
  });

  @override
  State<SidebarExpansionItem> createState() => _SidebarExpansionItemState();
}

class _SidebarExpansionItemState extends State<SidebarExpansionItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.forceExpanded ?? widget.initiallyExpanded;
  }

  @override
  void didUpdateWidget(covariant SidebarExpansionItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.forceExpanded != null && widget.forceExpanded != _isExpanded) {
      setState(() {
        _isExpanded = widget.forceExpanded!;
      });
    }
    if (widget.isParentSelected != oldWidget.isParentSelected) {
      setState(() {});
    }
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = Colors.white;
    final Color iconColor = Colors.white;
    final TextStyle textStyle = AppTextStyles.subtitle;
    final Color chevronColor = iconColor.withOpacity(0.7);

    final double indicatorLeftPos = -parentHorizontalPadding;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: itemVerticalMargin,
            horizontal: itemHorizontalMargin,
          ),
          decoration: BoxDecoration(
            color:
                widget.isParentSelected
                    ? selectedItemColor.withOpacity(
                      selectedItemBackgroundOpacity,
                    )
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
            child: InkWell(
              onTap: _toggleExpansion,
              borderRadius: BorderRadius.circular(borderRadius),
              splashColor: selectedItemColor.withOpacity(0.1),
              highlightColor: selectedItemColor.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: parentHorizontalPadding,
                  right: parentHorizontalPadding,
                  top: itemVerticalPadding,
                  bottom: itemVerticalPadding,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      children: [
                        Icon(widget.icon, color: iconColor, size: 20),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            widget.title,
                            style: textStyle.copyWith(color: textColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _isExpanded
                              ? LucideIcons.chevronUp
                              : LucideIcons.chevronDown,
                          size: 18,
                          color: chevronColor,
                        ),
                      ],
                    ),

                    if (widget.isParentSelected)
                      Positioned(
                        left: indicatorLeftPos,
                        top: -itemVerticalPadding,
                        bottom: -itemVerticalPadding,
                        child: Container(
                          width: indicatorWidth,
                          decoration: const BoxDecoration(
                            color: selectedItemColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(borderRadius),
                              bottomLeft: Radius.circular(borderRadius),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        AnimatedCrossFade(
          firstChild: Container(),
          secondChild: ExpansionTileChildrenWrapper(children: widget.children),
          crossFadeState:
              _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );
  }
}
