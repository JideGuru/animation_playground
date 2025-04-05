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

/// Represents an item within the segmented control, particularly for the nested group.
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
  /// The value associated with the non-expanding (first) tab.
  final T simpleTabValue;

  /// The label displayed for the non-expanding (first) tab.
  final String simpleTabLabel;

  /// The label displayed for the expanding (second) tab group when it's collapsed.
  final String groupTabCollapsedLabel;

  /// The list of options for the expanding (second) tab group.
  final List<MorphingTabItem<T>> groupTabOptions;

  // --- Customization ---
  /// Height of the control.
  final double height;

  /// Overall width of the control. If null, it tries to expand.
  final double? width;

  /// Padding inside the main container.
  final EdgeInsets padding;

  /// Margin around the main sliding thumb.
  final EdgeInsets mainThumbMargin;

  /// Margin around the nested sliding thumb.
  final EdgeInsets nestedThumbMargin;

  /// Background color of the control.
  final Color backgroundColor;

  /// Color of the main sliding thumb (selects between simpleTab and the groupTab).
  final Color selectedColor;

  /// Color of the nested sliding thumb (selects within the groupTab options).
  final Color nestedSelectedColor;

  /// Text color when the text is over the corresponding selected thumb.
  final Color selectedTextColor;

  /// Text color when the text is *not* over its corresponding selected thumb.
  final Color unselectedTextColor;

  /// Color of the nested selected text.
  final Color nestedSelectedTextColor;

  /// Color of the nested unselected text.
  final Color nestedUnselectedTextColor;

  /// General text style for labels. Specific colors ([selectedTextColor],
  /// [unselectedTextColor]) will override the color in this style.
  final TextStyle? textStyle;

  /// Duration for the main thumb sliding animation.
  final Duration mainAnimationDuration;

  /// Duration for the nested thumb sliding animation.
  final Duration nestedAnimationDuration;

  /// Duration for the fade animation when switching the group tab content.
  final Duration switchAnimationDuration;

  /// Animation curve used for all animations.
  final Curve animationCurve;

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
    this.selectedColor = Colors.white, // Main thumb color
    this.nestedSelectedColor = Colors.black, // Nested thumb color
    this.selectedTextColor = Colors.black, // Text color over main thumb
    this.unselectedTextColor = Colors.white, // Text color over main background
    this.nestedSelectedTextColor = Colors.white, // Nested thumb text color
    this.nestedUnselectedTextColor = Colors.black, // Nested thumb text color
    this.textStyle,
    this.mainAnimationDuration = const Duration(milliseconds: 250),
    this.nestedAnimationDuration = const Duration(milliseconds: 250),
    this.switchAnimationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
  }) : assert(groupTabOptions.length > 0, 'groupTabOptions cannot be empty');

  @override
  State<MorphingSegmentedControl<T>> createState() =>
      _MorphingSegmentedControlState<T>();
}

class _MorphingSegmentedControlState<T>
    extends State<MorphingSegmentedControl<T>> {
  // Helper to check if the current value belongs to the group/nested options
  bool get _isGroupTabSelected {
    return widget.groupTabOptions.any((option) => option.value == widget.value);
  }

  // Calculate metrics for the main background thumb (Simple vs Group)
  Map<String, double> _calculateMainThumbMetrics(double maxWidth) {
    double availableWidth = maxWidth - widget.padding.horizontal;
    double thumbWidth = availableWidth / 2; // Always 50% for main selection
    double thumbLeft = widget.padding.left; // Default to Simple tab position

    if (_isGroupTabSelected) {
      // If any group option is selected, move thumb to the right half
      thumbLeft = widget.padding.left + (availableWidth / 2);
    }

    return {'left': thumbLeft, 'width': thumbWidth};
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    // Calculate border radius based on height, padding, and margin
    final double mainThumbEffectiveHeight = widget.height -
        widget.padding.vertical -
        widget.mainThumbMargin.vertical;
    final double mainThumbBorderRadius = mainThumbEffectiveHeight / 2;

    final TextStyle defaultTextStyle = widget.textStyle ??
        Theme.of(context).textTheme.bodyMedium ??
        const TextStyle();
    final TextStyle effectiveTextStyle =
        defaultTextStyle.copyWith(fontWeight: FontWeight.bold);

    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.height / 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth; // Use actual width
          if (maxWidth == 0 || maxWidth.isInfinite) {
            // Avoid calculations if width is not constrained
            return const SizedBox.shrink();
          }

          final mainThumbMetrics = _calculateMainThumbMetrics(maxWidth);
          final double mainThumbLeft = mainThumbMetrics['left']!;
          final double mainThumbWidth = mainThumbMetrics['width']!;

          // Determine text colors based on main thumb position
          final Color simpleTextColor = widget.value == widget.simpleTabValue
              ? widget.selectedTextColor // Over white thumb
              : widget.unselectedTextColor; // Over black background

          final Color groupCollapsedTextColor = _isGroupTabSelected
              ? widget.selectedTextColor // Over white thumb
              : widget.unselectedTextColor; // Over black background

          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              // --- 1. Main Sliding Thumb (Background Selector) ---
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
                    color: widget.selectedColor, // Use parameter
                    borderRadius: BorderRadius.circular(
                        mainThumbBorderRadius > 0 ? mainThumbBorderRadius : 0),
                  ),
                ),
              ),

              // --- 2. Tab Labels / Content Area ---
              Padding(
                padding: widget.padding, // Apply overall padding
                child: Row(
                  children: [
                    // --- SIMPLE Tab Area (50%) ---
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
                          ),
                        ),
                      ),
                    ),

                    // --- GROUP Tab Area (50%) ---
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: widget.switchAnimationDuration,
                        switchInCurve: widget.animationCurve,
                        switchOutCurve: widget.animationCurve,
                        transitionBuilder: (child, anim) {
                          return FadeTransition(opacity: anim, child: child);
                        },
                        child: _isGroupTabSelected
                            ? _NestedTabBar<T>(
                                // Use a key for state preservation if needed, ValueKey helps switcher
                                key: ValueKey(widget.groupTabOptions),
                                selectedTabValue: widget.value,
                                options: widget.groupTabOptions,
                                onChanged: widget.onChanged,
                                // Pass necessary dimensions & styles
                                parentHeight:
                                    widget.height - widget.padding.vertical,
                                nestedThumbMargin: widget.nestedThumbMargin,
                                animationDuration:
                                    widget.nestedAnimationDuration,
                                animationCurve: widget.animationCurve,
                                selectedColor: widget.nestedSelectedColor,
                                // Text colors are reversed for nested bar
                                selectedTextColor:
                                    widget.nestedSelectedTextColor,
                                // Text over nested thumb
                                unselectedTextColor:
                                    widget.nestedUnselectedTextColor,
                                // Text over main thumb background
                                textStyle: effectiveTextStyle,
                              )
                            : GestureDetector(
                                // Key for the collapsed state
                                key: ValueKey(widget.groupTabCollapsedLabel),
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  // Default to first group option when tapping collapsed label
                                  if (widget.groupTabOptions.isNotEmpty) {
                                    widget.onChanged(
                                        widget.groupTabOptions.first.value);
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        key: Key('label_2'),
                                        widget.groupTabCollapsedLabel,
                                        style: effectiveTextStyle.copyWith(
                                          color: groupCollapsedTextColor,
                                          height: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        key: Key('label_2_subtitle_row'),
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            key: const Key(
                                                'label_2_subtitle_text_0'),
                                            widget.groupTabOptions.first.label,
                                            style: effectiveTextStyle.copyWith(
                                              color: groupCollapsedTextColor
                                                  .withValues(
                                                alpha: 0.5,
                                              ),
                                              height: 1.0,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const Text(
                                            key: Key(
                                                'label_2_subtitle_text_1_separator'),
                                            ' , ',
                                          ),
                                          Text(
                                            key: const Key(
                                                'label_2_subtitle_text_1'),
                                            widget.groupTabOptions.last.label,
                                            style: effectiveTextStyle.copyWith(
                                              color: groupCollapsedTextColor
                                                  .withValues(
                                                alpha: 0.5,
                                              ),
                                              height: 1.0,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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

// --- Internal Nested Tab Bar Widget ---
// Manages selection within the second (group) segment
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
    if (options.isEmpty) {
      return {'left': 0.0, 'width': 0.0};
    }
    int selectedIndex = options.indexWhere((o) => o.value == selectedTabValue);
    if (selectedIndex < 0)
      selectedIndex = 0; // Should not happen if value is valid

    double totalOptions = options.length.toDouble();
    double thumbWidth = maxWidth / totalOptions;
    double thumbLeft = thumbWidth * selectedIndex;

    return {'left': thumbLeft, 'width': thumbWidth};
  }

  @override
  Widget build(BuildContext context) {
    // Calculate radius for the internal thumb
    final double thumbEffectiveHeight =
        parentHeight - nestedThumbMargin.vertical;
    final double thumbBorderRadius = thumbEffectiveHeight / 2;

    return LayoutBuilder(builder: (context, constraints) {
      final double maxWidth = constraints.maxWidth;
      if (maxWidth == 0 || maxWidth.isInfinite || options.isEmpty) {
        // Avoid calculations if width is not constrained or no options
        return const SizedBox.shrink();
      }

      final internalThumbMetrics = _calculateInternalThumbMetrics(maxWidth);
      final double thumbLeft = internalThumbMetrics['left']!;
      final double thumbWidth = internalThumbMetrics['width']!;

      return Stack(
        alignment: Alignment.centerLeft,
        children: [
          // --- 1. Internal Sliding Thumb ---
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
