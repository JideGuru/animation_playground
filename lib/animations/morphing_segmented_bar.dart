import 'dart:math' as math;

import 'package:animation_playground/buildcontext_extension.dart';
import 'package:flutter/material.dart';

// Define your values (could be enums, strings, ints...)
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
                        value: PlanType.premiumMonthly, label: "Monthly"),
                    MorphingTabItem(
                        value: PlanType.premiumYearly, label: "Annual"),
                  ],
                  // --- Optional Customization ---
                  // height: 50,
                  // width: 350,
                  backgroundColor: Colors.white,
                  selectedColor: Colors.black,
                  nestedSelectedColor: Colors.white,
                  selectedTextColor: Colors.white,
                  unselectedTextColor: Colors.grey,
                  nestedSelectedTextColor: Colors.black,
                  nestedUnselectedTextColor: Colors.white,
                  // textStyle: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- MorphingTabItem Class ---
// (Ensure this class definition is included)
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

// --- MorphingSegmentedControl Widget ---
/// A segmented control with a morphing behavior for the second segment,
/// allowing it to expand into sub-options.
///
/// Uses a generic type `T` for the values associated with each tab.
class MorphingSegmentedControl<T> extends StatefulWidget {
  /// The currently selected value. Must be one of [simpleTabValue] or a value from [groupTabOptions].
  final T value;

  /// Callback invoked when the selected value changes.
  final ValueChanged<T> onChanged;

  // --- Tab Configuration ---
  final T simpleTabValue;
  final String simpleTabLabel;
  final String groupTabCollapsedLabel; // "Premium"
  final List<MorphingTabItem<T>>
      groupTabOptions; // Items for nested bar & subtitle

  // --- Customization ---
  final double height;
  final double? width;
  final EdgeInsets padding;
  final EdgeInsets mainThumbMargin;
  final EdgeInsets nestedThumbMargin;
  final Color backgroundColor;
  final Color selectedColor; // Main thumb color
  final Color nestedSelectedColor; // Nested thumb color
  final Color selectedTextColor; // Text over main thumb
  final Color unselectedTextColor; // Text over main background
  final Color nestedSelectedTextColor; // Text over nested thumb
  final Color
      nestedUnselectedTextColor; // Text over nested background (main thumb)
  final TextStyle? textStyle;
  final Duration mainAnimationDuration;
  final Duration nestedAnimationDuration;
  final Duration switchAnimationDuration; // Duration for the morph switch
  final Curve animationCurve; // General curve for slides
  // Curves for the switch transition specifically
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
    this.switchAnimationDuration =
        const Duration(milliseconds: 400), // Using 400ms
    this.animationCurve = Curves.easeInOut,
    this.switchScaleInCurve = Curves.easeOutCubic,
    this.switchScaleOutCurve = Curves.easeInCubic,
    this.switchFadeInCurve = Curves.easeIn,
    this.switchFadeOutCurve = Curves.easeOut,
    this.switchSlideOutCurve = Curves.easeOut, // Curve for the slide-out part
  }) : assert(groupTabOptions.length >= 2,
            'groupTabOptions must have at least two items for the default subtitle display');

  @override
  State<MorphingSegmentedControl<T>> createState() =>
      _MorphingSegmentedControlState<T>();
}

// --- State Class ---
// Add TickerProviderStateMixin
class _MorphingSegmentedControlState<T>
    extends State<MorphingSegmentedControl<T>> with TickerProviderStateMixin {
  late AnimationController _switchController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  // Track previous state to trigger animation correctly
  bool _wasGroupTabSelected = false;

  // Helper getter
  bool get _isCurrentlyGroupTabSelected =>
      widget.groupTabOptions.any((option) => option.value == widget.value);

  @override
  void initState() {
    super.initState();
    _wasGroupTabSelected = _isCurrentlyGroupTabSelected;

    _switchController = AnimationController(
      vsync: this,
      duration: widget.switchAnimationDuration,
      // Set initial value based on initial selection
      value: _wasGroupTabSelected ? 1.0 : 0.0,
    );

    _setupAnimations();
  }

  // Helper to set up tween animations based on controller
  void _setupAnimations() {
    // Fade: 0->1 for expanding (nested comes in), 1->0 for collapsing (collapsed comes in)
    // Opacity logic driven inside builder based on controller value directly for simplicity
    // This simplifies reversing, but we can use Tweens if preferred.

    // Scale: 0.8->1.0 for expanding (nested scales in), 1.0->0.8 for collapsing (nested scales out)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
            parent: _switchController, curve: Curves.easeInOut) // Example curve
        );

    // Slide: Only for collapsed view when it's moving OUT (controller 0 -> 1)
    _slideAnimation = Tween<Offset>(
            begin: Offset.zero, end: const Offset(0.0, -0.5)) // Slide up more
        .animate(CurvedAnimation(
            parent: _switchController, curve: widget.switchSlideOutCurve));
  }

  @override
  void didUpdateWidget(MorphingSegmentedControl<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool isNowGroupSelected = _isCurrentlyGroupTabSelected;

    // If the group selection state CHANGES, trigger animation
    if (_wasGroupTabSelected != isNowGroupSelected) {
      if (isNowGroupSelected) {
        // Expanding: Animate 0.0 -> 1.0
        _switchController.forward();
      } else {
        // Collapsing: Animate 1.0 -> 0.0
        _switchController.reverse();
      }
      _wasGroupTabSelected = isNowGroupSelected;
    }

    // If durations change, update controller
    if (widget.switchAnimationDuration != oldWidget.switchAnimationDuration) {
      _switchController.duration = widget.switchAnimationDuration;
    }
    // Note: If curves change, re-setup animations if using CurvedAnimation wrappers outside builder
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
    // Use the CURRENT selection state for thumb position
    if (_isCurrentlyGroupTabSelected) {
      thumbLeft = widget.padding.left + (availableWidth / 2);
    }
    return {'left': thumbLeft, 'width': thumbWidth};
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

    // Colors
    final Color simpleTextColor = widget.value == widget.simpleTabValue
        ? widget.selectedTextColor
        : widget.unselectedTextColor;
    // Collapsed view text should ALWAYS contrast with the main background
    final Color groupCollapsedTextColor = widget.unselectedTextColor;

    // Subtitle Text Generation
    final String subtitleText1 = widget.groupTabOptions.isNotEmpty
        ? widget.groupTabOptions[0].label
        : '';
    final String subtitleText2 = widget.groupTabOptions.length > 1
        ? widget.groupTabOptions[1].label
        : '';

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
              // --- Main Thumb ---
              // Use an AnimatedPositioned controlled by the main selection, NOT the switch controller
              AnimatedPositioned(
                duration: widget.mainAnimationDuration,
                // Use main duration
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

              // --- Labels ---
              Padding(
                padding: widget.padding,
                child: Row(
                  children: [
                    // --- Simple Tab ---
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => widget.onChanged(widget.simpleTabValue),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            widget.simpleTabLabel,
                            style: effectiveTextStyle.copyWith(
                                color: simpleTextColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),

                    // --- Group Tab (Using AnimatedBuilder) ---
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _switchController,
                        builder: (context, _) {
                          // Calculate animation values based on controller
                          // Use curves directly here for more control per property
                          final double controllerValue = _switchController
                              .value; // 0.0 = collapsed, 1.0 = expanded

                          // --- Collapsed View Animations ---
                          // Fade out as controller goes 0 -> 1
                          final double collapsedOpacity = 1.0 -
                              CurvedAnimation(
                                      parent: _switchController,
                                      curve: widget.switchFadeOutCurve)
                                  .value;
                          // Scale down as controller goes 0 -> 1
                          final double collapsedScale = 1.0 -
                              (CurvedAnimation(
                                          parent: _switchController,
                                          curve: widget.switchScaleOutCurve)
                                      .value *
                                  0.2); // Scale 1.0 -> 0.8
                          // Slide up as controller goes 0 -> 1
                          final Offset collapsedSlide = Tween<Offset>(
                                  begin: Offset.zero,
                                  end: const Offset(0.0, -0.5))
                              .transform(CurvedAnimation(
                                      parent: _switchController,
                                      curve: widget.switchSlideOutCurve)
                                  .value);

                          // --- Expanded View Animations ---
                          // Fade in as controller goes 0 -> 1
                          final double expandedOpacity = CurvedAnimation(
                                  parent: _switchController,
                                  curve: widget.switchFadeInCurve)
                              .value;
                          // Scale up as controller goes 0 -> 1
                          final double expandedScale = 0.8 +
                              (CurvedAnimation(
                                          parent: _switchController,
                                          curve: widget.switchScaleInCurve)
                                      .value *
                                  0.2); // Scale 0.8 -> 1.0

                          // Use IgnorePointer to disable taps on views that are mostly faded out
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              // --- Collapsed View (Premium + Subtitle) ---
                              if (controllerValue <
                                  1.0) // Optimization: Don't build if fully expanded
                                IgnorePointer(
                                  ignoring: controllerValue >
                                      0.8, // Disable taps when mostly faded
                                  child: Opacity(
                                    opacity: collapsedOpacity,
                                    child: Transform.translate(
                                      offset: collapsedSlide,
                                      child: Transform.scale(
                                        scale: collapsedScale,
                                        child: GestureDetector(
                                          // Keep GestureDetector for tap target
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            // Check if currently collapsed before triggering change
                                            if (!_isCurrentlyGroupTabSelected &&
                                                widget.groupTabOptions
                                                    .isNotEmpty) {
                                              widget.onChanged(widget
                                                  .groupTabOptions.first.value);
                                            }
                                          },
                                          child: Container(
                                            // Background needed? Probably not if main thumb handles it
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  // Main Label
                                                  widget.groupTabCollapsedLabel,
                                                  style: effectiveTextStyle
                                                      .copyWith(
                                                          color:
                                                              groupCollapsedTextColor,
                                                          height: 1.1),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 1),
                                                Row(
                                                  // Subtitle
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Flexible(
                                                        child: Text(
                                                            subtitleText1,
                                                            style: effectiveTextStyle
                                                                .copyWith(
                                                                    color: groupCollapsedTextColor
                                                                        .withValues(
                                                                      alpha:
                                                                          0.6,
                                                                    ),
                                                                    height: 1.0,
                                                                    fontSize: math.max(
                                                                        10.0,
                                                                        (effectiveTextStyle.fontSize ??
                                                                                14.0) *
                                                                            0.7),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis)),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 2.0),
                                                      child: Text(
                                                        ' - ',
                                                        style: effectiveTextStyle
                                                            .copyWith(
                                                                color: groupCollapsedTextColor
                                                                    .withValues(
                                                                  alpha: 0.6,
                                                                ),
                                                                height: 1.0,
                                                                fontSize: math.max(
                                                                    10.0,
                                                                    (effectiveTextStyle.fontSize ??
                                                                            14.0) *
                                                                        0.7),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Text(subtitleText2,
                                                          style: effectiveTextStyle
                                                              .copyWith(
                                                                  color: groupCollapsedTextColor
                                                                      .withValues(
                                                                    alpha: 0.6,
                                                                  ),
                                                                  height: 1.0,
                                                                  fontSize: math.max(
                                                                      10.0,
                                                                      (effectiveTextStyle.fontSize ??
                                                                              14.0) *
                                                                          0.7),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              // --- Expanded View (_NestedTabBar) ---
                              if (controllerValue >
                                  0.0) // Optimization: Don't build if fully collapsed
                                IgnorePointer(
                                  ignoring: controllerValue <
                                      0.2, // Disable taps when mostly faded out
                                  child: Opacity(
                                    opacity: expandedOpacity,
                                    child: Transform.scale(
                                      scale: expandedScale,
                                      alignment: const Alignment(
                                          0.0, 0.3), // Align lower
                                      child: _NestedTabBar<T>(
                                        // key is not strictly needed here as it's always the same instance type
                                        selectedTabValue: widget.value,
                                        options: widget.groupTabOptions,
                                        onChanged: widget.onChanged,
                                        parentHeight: widget.height -
                                            widget.padding.vertical,
                                        nestedThumbMargin:
                                            widget.nestedThumbMargin,
                                        animationDuration:
                                            widget.nestedAnimationDuration,
                                        animationCurve: widget.animationCurve,
                                        selectedColor:
                                            widget.nestedSelectedColor,
                                        selectedTextColor:
                                            widget.nestedSelectedTextColor,
                                        unselectedTextColor:
                                            widget.nestedUnselectedTextColor,
                                        textStyle: effectiveTextStyle,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
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

// --- _NestedTabBar Class ---
// (Keep the _NestedTabBar class from the previous valid answer - no changes needed)
class _NestedTabBar<T> extends StatelessWidget {
  final T selectedTabValue;
  final List<MorphingTabItem<T>> options;
  final ValueChanged<T> onChanged;

  // Styling & Animation forwarded from parent
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

  // Calculate metrics for the *internal* thumb
  Map<String, double> _calculateInternalThumbMetrics(double maxWidth) {
    // Avoid division by zero or negative width
    if (options.isEmpty || maxWidth <= 0) {
      return {'left': 0.0, 'width': 0.0};
    }
    int selectedIndex = options.indexWhere((o) => o.value == selectedTabValue);
    if (selectedIndex < 0) selectedIndex = 0;

    double totalOptions = options.length.toDouble();
    double thumbWidth = maxWidth / totalOptions;
    double thumbLeft = thumbWidth * selectedIndex;

    // Ensure thumb doesn't exceed bounds due to precision issues
    thumbLeft = math.max(0, thumbLeft);
    thumbWidth = math.min(thumbWidth, maxWidth - thumbLeft);

    return {'left': thumbLeft, 'width': thumbWidth};
  }

  @override
  Widget build(BuildContext context) {
    // Calculate radius for the internal thumb
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
          // --- 1. Internal Sliding Thumb ---
          // Ensure thumb width/position are valid before building
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
                  color: selectedColor, // Use parameter
                  borderRadius: BorderRadius.circular(
                      thumbBorderRadius > 0 ? thumbBorderRadius : 0),
                ),
              ),
            ),

          // --- 2. Nested Option Labels ---
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
                              color: textColor, fontWeight: FontWeight.bold),
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
