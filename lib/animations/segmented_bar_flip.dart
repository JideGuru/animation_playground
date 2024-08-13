import 'dart:math' as math;

import 'package:flutter/material.dart';

const kSegmentBarHeight = 45.0;
const color = Colors.black;
const images = [
  'https://images.unsplash.com/photo-1516280030429-27679b3dc9cf?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y2F0c3xlbnwwfHwwfHx8MA%3D%3D',
  'https://images.unsplash.com/photo-1536590158209-e9d615d525e4?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Y2F0c3xlbnwwfHwwfHx8MA%3D%3D',
  'https://images.unsplash.com/photo-1536589961747-e239b2abbec2?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y2F0c3xlbnwwfHwwfHx8MA%3D%3D',
  'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGNhdHN8ZW58MHx8MHx8fDA%3D',
  'https://images.unsplash.com/photo-1548366086-7f1b76106622?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGNhdHN8ZW58MHx8MHx8fDA%3D',
];

class SegmentedBarFlip extends StatefulWidget {
  const SegmentedBarFlip({super.key});

  @override
  State<SegmentedBarFlip> createState() => _SegmentedBarFlipState();
}

class _SegmentedBarFlipState extends State<SegmentedBarFlip> {
  int _selectedIndex = 0;

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: kToolbarHeight + 10),
              Center(
                child: CustomSegmentBar(
                  onTabChanged: _onTabChanged,
                ),
              ),
              const SizedBox(height: 50),
              const Text('Recent', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 15),
              Flexible(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child:
                      _selectedIndex == 0 ? _buildGridView() : _buildListView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 15,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            images[index % images.length],
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                images[index % images.length],
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  'AUD_000012374Y74WA000',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 5),
                Text(
                  '34KB',
                  style: TextStyle(fontSize: 15, color: Colors.deepPurple),
                ),
                SizedBox(height: 5),
                Text(
                  '31/99/33',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }
}

class CustomSegmentBar extends StatefulWidget {
  final Function(int) onTabChanged;
  const CustomSegmentBar({super.key, required this.onTabChanged});

  @override
  State<CustomSegmentBar> createState() => _CustomSegmentBarState();
}

class _CustomSegmentBarState extends State<CustomSegmentBar> {
  int _selectedIndex = 0;
  bool _showInitialFill = true;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
      _showInitialFill = false;
    });
    widget.onTabChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Segment(
          text: "Photos",
          isSelected: _selectedIndex == 0,
          onTap: () => _onTap(0),
          isLeftSegment: true,
          isInitiallyFilled: _showInitialFill && _selectedIndex == 0,
        ),
        Segment(
          text: "Videos",
          isSelected: _selectedIndex == 1,
          onTap: () => _onTap(1),
          isLeftSegment: false,
          isInitiallyFilled: false,
        ),
      ],
    );
  }
}

class Segment extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLeftSegment;
  final bool isInitiallyFilled; // New property to handle initial fill

  const Segment({
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.isLeftSegment,
    required this.isInitiallyFilled,
    super.key,
  });

  @override
  State createState() => _SegmentState();
}

class _SegmentState extends State<Segment> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isSelected) {
      _controller.value = 0; // Ensure the selected tab is fully visible on load
    }
  }

  @override
  void didUpdateWidget(covariant Segment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected && widget.isSelected) {
      _controller.forward(from: 0);
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _controller.reverse(from: 1);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          // Background for all segments with initial fill logic
          Container(
            width: 150,
            height: kSegmentBarHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.isInitiallyFilled ? color : Colors.transparent,
              borderRadius: widget.isLeftSegment
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      bottomLeft: Radius.circular(100),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
              border: Border.all(
                color: color,
                width: 3,
              ),
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 20,
                color: widget.isInitiallyFilled ? Colors.white : color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final double rotationAngle = widget.isSelected
                  ? _animation.value * math.pi / 2
                  : (1 - _animation.value) * math.pi / 2;

              return Transform(
                alignment: widget.isLeftSegment
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(
                      widget.isLeftSegment ? -rotationAngle : rotationAngle),
                child: Container(
                  width: 150,
                  height: kSegmentBarHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.isSelected ? color : Colors.transparent,
                    borderRadius: widget.isLeftSegment
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                          )
                        : const BorderRadius.only(
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                  ),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 20,
                      color:
                          widget.isSelected ? Colors.white : Colors.transparent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
