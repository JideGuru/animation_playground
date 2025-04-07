import 'dart:math' as math;

import 'package:animation_playground/buildcontext_extension.dart';
import 'package:flutter/material.dart';

enum PlanType { free, premiumMonthly, premiumYearly }

class MorphingSegmentedControlPage extends StatefulWidget {
  const MorphingSegmentedControlPage({super.key});

  @override
  State<MorphingSegmentedControlPage> createState() =>
      _MorphingSegmentedControlPageState();
}

class _MorphingSegmentedControlPageState
    extends State<MorphingSegmentedControlPage> {
  PlanType _selectedPlan = PlanType.free;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Morphing Segmented Control')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: MorphingSegmentedControl<PlanType>(
                  width: context.isMobile ? context.screenWidth - 20 : 420,
                  height: 50,
                  value: _selectedPlan,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPlan = newValue;
                    });
                  },
                  simpleTabValue: PlanType.free,
                  simpleTabLabel: "Free",
                  groupTabCollapsedLabel: "Premium",
                  groupTabOptions: const [
                    MorphingTabItem(
                      value: PlanType.premiumMonthly,
                      label: "Monthly",
                    ),
                    MorphingTabItem(
                      value: PlanType.premiumYearly,
                      label: "Annual",
                    ),
                  ],
                  backgroundColor: Colors.white,
                  selectedColor: Colors.black,
                  nestedSelectedColor: Colors.white,
                  selectedTextColor: Colors.white,
                  unselectedTextColor: Colors.grey,
                  nestedSelectedTextColor: Colors.black,
                  nestedUnselectedTextColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MorphingTabItem<T> {
  final T value;
  final String label;

  const MorphingTabItem({required this.value, required this.label});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MorphingTabItem<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class MorphingSegmentedControl<T> extends StatefulWidget {
  final T value;
  final ValueChanged<T> onChanged;
  final T simpleTabValue;
  final String simpleTabLabel;
  final String groupTabCollapsedLabel;
  final List<MorphingTabItem<T>> groupTabOptions;
  final double height;
  final double? width;
  final EdgeInsets padding;
  final EdgeInsets mainThumbMargin;
  final EdgeInsets nestedThumbMargin;
  final Color backgroundColor;
  final Color selectedColor;
  final Color nestedSelectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Color nestedSelectedTextColor;
  final Color nestedUnselectedTextColor;
  final TextStyle? textStyle;
  final Duration mainAnimationDuration;
  final Duration nestedAnimationDuration;
  final Duration switchAnimationDuration;
  final Curve animationCurve;
  final Curve switchScaleInCurve;
  final Curve switchScaleOutCurve;
  final Curve switchFadeInCurve;
  final Curve switchFadeOutCurve;
  final Curve switchSlideOutCurve;

  const MorphingSegmentedControl({
    super.key,
    required this.value,
    required this.onChanged,
    required this.simpleTabValue,
    required this.simpleTabLabel,
    required this.groupTabCollapsedLabel,
    required this.groupTabOptions,
    this.height = 48,
    this.width = 320,
    this.padding = const EdgeInsets.all(0),
    this.mainThumbMargin = const EdgeInsets.all(2),
    this.nestedThumbMargin = const EdgeInsets.all(4),
    this.backgroundColor = Colors.black,
    this.selectedColor = Colors.white,
    this.nestedSelectedColor = Colors.black,
    this.selectedTextColor = Colors.black,
    this.unselectedTextColor = Colors.white,
    this.nestedSelectedTextColor = Colors.white,
    this.nestedUnselectedTextColor = Colors.black,
    this.textStyle,
    this.mainAnimationDuration = const Duration(milliseconds: 250),
    this.nestedAnimationDuration = const Duration(milliseconds: 250),
    this.switchAnimationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOut,
    this.switchScaleInCurve = Curves.easeOutCubic,
    this.switchScaleOutCurve = Curves.easeInCubic,
    this.switchFadeInCurve = Curves.easeIn,
    this.switchFadeOutCurve = Curves.easeOut,
    this.switchSlideOutCurve = Curves.easeOut,
  }) : assert(groupTabOptions.length >= 2,
            'groupTabOptions must have at least two items for the default subtitle display');

  @override
  State<MorphingSegmentedControl<T>> createState() =>
      _MorphingSegmentedControlState<T>();
}

class _MorphingSegmentedControlState<T>
    extends State<MorphingSegmentedControl<T>> with TickerProviderStateMixin {
  late AnimationController _switchController;
  bool _wasGroupTabSelected = false;

  bool get _isCurrentlyGroupTabSelected =>
      widget.groupTabOptions.any((option) => option.value == widget.value);

  @override
  void initState() {
    super.initState();
    _wasGroupTabSelected = _isCurrentlyGroupTabSelected;
    _switchController = AnimationController(
      vsync: this,
      duration: widget.switchAnimationDuration,
      value: _wasGroupTabSelected ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(MorphingSegmentedControl<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool isNowGroupSelected = _isCurrentlyGroupTabSelected;

    if (_wasGroupTabSelected != isNowGroupSelected) {
      if (isNowGroupSelected) {
        _switchController.forward();
      } else {
        _switchController.reverse();
      }
      _wasGroupTabSelected = isNowGroupSelected;
    }

    if (widget.switchAnimationDuration != oldWidget.switchAnimationDuration) {
      _switchController.duration = widget.switchAnimationDuration;
    }
  }

  @override
  void dispose() {
    _switchController.dispose();
    super.dispose();
  }

  Map<String, double> _calculateMainThumbMetrics(double maxWidth) {
    if (maxWidth <= 0) return {'left': 0.0, 'width': 0.0};
    double availableWidth = math.max(0, maxWidth - widget.padding.horizontal);
    double thumbWidth = availableWidth / 2;
    double thumbLeft = widget.padding.left;
    if (_isCurrentlyGroupTabSelected) {
      thumbLeft = widget.padding.left + (availableWidth / 2);
    }
    return {'left': thumbLeft, 'width': thumbWidth};
  }

  Widget _buildSimpleTabView({
    required TextStyle effectiveTextStyle,
    required Color simpleTextColor,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.onChanged(widget.simpleTabValue),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            widget.simpleTabLabel,
            style: effectiveTextStyle.copyWith(color: simpleTextColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildGroupTabAnimatedSwitcher({
    required TextStyle effectiveTextStyle,
  }) {
    return Expanded(
      child: AnimatedBuilder(
        animation: _switchController,
        builder: (context, _) {
          final double controllerValue = _switchController.value;

          final double collapsedOpacity = (1.0 -
                  CurvedAnimation(
                    parent: _switchController,
                    curve: widget.switchFadeOutCurve,
                  ).value)
              .clamp(0.0, 1.0);
          final double collapsedScale = 1.0 -
              (CurvedAnimation(
                          parent: _switchController,
                          curve: widget.switchScaleOutCurve)
                      .value *
                  0.4);
          final Offset collapsedSlide =
              Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, -0.5))
                  .transform(CurvedAnimation(
                          parent: _switchController,
                          curve: widget.switchSlideOutCurve)
                      .value);
          final double expandedOpacity = CurvedAnimation(
                  parent: _switchController, curve: widget.switchFadeInCurve)
              .value
              .clamp(0.0, 1.0);
          final double expandedScale = 0.6 +
              (CurvedAnimation(
                          parent: _switchController,
                          curve: widget.switchScaleInCurve)
                      .value *
                  0.4);

          return Stack(
            alignment: Alignment.center,
            children: [
              if (controllerValue < 1.0)
                _buildCollapsedGroupView(
                  effectiveTextStyle: effectiveTextStyle,
                  opacity: collapsedOpacity,
                  scale: collapsedScale,
                  slideOffset: collapsedSlide,
                ),
              if (controllerValue > 0.0)
                _buildExpandedGroupView(
                  effectiveTextStyle: effectiveTextStyle,
                  opacity: expandedOpacity,
                  scale: expandedScale,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCollapsedGroupView({
    required TextStyle effectiveTextStyle,
    required double opacity,
    required double scale,
    required Offset slideOffset,
  }) {
    final Color groupCollapsedTextColor = widget.unselectedTextColor;
    final String subtitleText1 = widget.groupTabOptions.isNotEmpty
        ? widget.groupTabOptions[0].label
        : '';
    final String subtitleText2 = widget.groupTabOptions.length > 1
        ? widget.groupTabOptions[1].label
        : '';
    final double subtitleFontSize =
        math.max(10.0, (effectiveTextStyle.fontSize ?? 14.0) * 0.7);
    final Color subtitleColor = groupCollapsedTextColor.withValues(alpha: 0.6);
    final TextStyle subtitleStyle = effectiveTextStyle.copyWith(
        color: subtitleColor,
        height: 1.0,
        fontSize: subtitleFontSize,
        fontWeight: FontWeight.w400);

    return IgnorePointer(
      ignoring: opacity < 0.15,
      child: Opacity(
        opacity: opacity,
        child: Transform.translate(
          offset: slideOffset,
          child: Transform.scale(
            scale: scale,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (!_isCurrentlyGroupTabSelected &&
                    widget.groupTabOptions.isNotEmpty) {
                  widget.onChanged(widget.groupTabOptions.first.value);
                }
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.groupTabCollapsedLabel,
                      style: effectiveTextStyle.copyWith(
                          color: groupCollapsedTextColor, height: 1.1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            child: Text(subtitleText1,
                                style: subtitleStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Text(' - ', style: subtitleStyle),
                        ),
                        Flexible(
                            child: Text(subtitleText2,
                                style: subtitleStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedGroupView({
    required TextStyle effectiveTextStyle,
    required double opacity,
    required double scale,
  }) {
    return IgnorePointer(
      ignoring: opacity < 0.15,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          alignment: const Alignment(0.0, 0.3), // Align lower during scale
          child: _NestedTabBar<T>(
            selectedTabValue: widget.value,
            options: widget.groupTabOptions,
            onChanged: widget.onChanged,
            parentHeight: widget.height - widget.padding.vertical,
            nestedThumbMargin: widget.nestedThumbMargin,
            animationDuration: widget.nestedAnimationDuration,
            animationCurve: widget.animationCurve,
            selectedColor: widget.nestedSelectedColor,
            selectedTextColor: widget.nestedSelectedTextColor,
            unselectedTextColor: widget.nestedUnselectedTextColor,
            textStyle: effectiveTextStyle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double mainThumbEffectiveHeight = math.max(
        0,
        widget.height -
            widget.padding.vertical -
            widget.mainThumbMargin.vertical);
    final double mainThumbBorderRadius = mainThumbEffectiveHeight / 2;
    final TextStyle defaultTextStyle = widget.textStyle ??
        Theme.of(context).textTheme.bodyMedium ??
        const TextStyle();
    final TextStyle effectiveTextStyle =
        defaultTextStyle.copyWith(fontWeight: FontWeight.bold);

    final Color simpleTextColor = widget.value == widget.simpleTabValue
        ? widget.selectedTextColor
        : widget.unselectedTextColor;

    return Container(
      height: widget.height,
      width: widget.width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.height / 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          if (maxWidth <= 0 || maxWidth.isInfinite) {
            return const SizedBox.shrink();
          }

          final mainThumbMetrics = _calculateMainThumbMetrics(maxWidth);
          final double mainThumbLeft = mainThumbMetrics['left']!;
          final double mainThumbWidth = mainThumbMetrics['width']!;

          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              AnimatedPositioned(
                duration: widget.mainAnimationDuration,
                curve: widget.animationCurve,
                left: mainThumbLeft,
                top: widget.padding.top,
                bottom: widget.padding.bottom,
                width: mainThumbWidth,
                child: Container(
                  margin: widget.mainThumbMargin,
                  decoration: BoxDecoration(
                    color: widget.selectedColor,
                    borderRadius: BorderRadius.circular(
                        mainThumbBorderRadius > 0 ? mainThumbBorderRadius : 0),
                  ),
                ),
              ),
              Padding(
                padding: widget.padding,
                child: Row(
                  children: [
                    _buildSimpleTabView(
                      effectiveTextStyle: effectiveTextStyle,
                      simpleTextColor: simpleTextColor,
                    ),
                    _buildGroupTabAnimatedSwitcher(
                      effectiveTextStyle: effectiveTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NestedTabBar<T> extends StatelessWidget {
  final T selectedTabValue;
  final List<MorphingTabItem<T>> options;
  final ValueChanged<T> onChanged;

  final double parentHeight;
  final EdgeInsets nestedThumbMargin;
  final Duration animationDuration;
  final Curve animationCurve;
  final Color selectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final TextStyle? textStyle;

  const _NestedTabBar({
    super.key,
    required this.selectedTabValue,
    required this.options,
    required this.onChanged,
    required this.parentHeight,
    required this.nestedThumbMargin,
    required this.animationDuration,
    required this.animationCurve,
    required this.selectedColor,
    required this.selectedTextColor,
    required this.unselectedTextColor,
    this.textStyle,
  });

  Map<String, double> _calculateInternalThumbMetrics(double maxWidth) {
    if (options.isEmpty || maxWidth <= 0) {
      return {'left': 0.0, 'width': 0.0};
    }
    int selectedIndex = options.indexWhere((o) => o.value == selectedTabValue);
    if (selectedIndex < 0) selectedIndex = 0;

    double totalOptions = options.length.toDouble();
    double thumbWidth = maxWidth / totalOptions;
    double thumbLeft = thumbWidth * selectedIndex;

    thumbLeft = math.max(0, thumbLeft);
    thumbWidth = math.min(thumbWidth, maxWidth - thumbLeft);

    return {'left': thumbLeft, 'width': thumbWidth};
  }

  @override
  Widget build(BuildContext context) {
    final double thumbEffectiveHeight =
        math.max(0, parentHeight - nestedThumbMargin.vertical);
    final double thumbBorderRadius = thumbEffectiveHeight / 2;

    return LayoutBuilder(builder: (context, constraints) {
      final double maxWidth = constraints.maxWidth;
      if (maxWidth <= 0 || maxWidth.isInfinite || options.isEmpty) {
        return const SizedBox.shrink();
      }

      final internalThumbMetrics = _calculateInternalThumbMetrics(maxWidth);
      final double thumbLeft = internalThumbMetrics['left']!;
      final double thumbWidth = internalThumbMetrics['width']!;

      return Stack(
        alignment: Alignment.centerLeft,
        children: [
          if (thumbWidth > 0)
            AnimatedPositioned(
              duration: animationDuration,
              curve: animationCurve,
              left: thumbLeft,
              top: 0,
              bottom: 0,
              width: thumbWidth,
              child: Container(
                margin: nestedThumbMargin,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(
                    thumbBorderRadius > 0 ? thumbBorderRadius : 0,
                  ),
                ),
              ),
            ),
          Row(
            children: List.generate(options.length, (index) {
              final item = options[index];
              final bool isSelected = item.value == selectedTabValue;
              final Color textColor =
                  isSelected ? selectedTextColor : unselectedTextColor;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(item.value),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      item.label,
                      style: textStyle?.copyWith(color: textColor) ??
                          TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      );
    });
  }
}
