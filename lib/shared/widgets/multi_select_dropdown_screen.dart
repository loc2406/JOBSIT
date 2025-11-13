import 'package:flutter/material.dart';

import '../../core/constants/color_constants.dart';

class MultiSelectDropdownScreen extends StatefulWidget {
  final String title;
  final List<String> options;
  final List<String> selectedOptions;

  const MultiSelectDropdownScreen({
    Key? key,
    required this.title,
    required this.options,
    required this.selectedOptions,
  }) : super(key: key);

  @override
  _MultiSelectDropdownScreenState createState() =>
      _MultiSelectDropdownScreenState();
}

class _MultiSelectDropdownScreenState extends State<MultiSelectDropdownScreen> {
  bool isDropdownOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _key = GlobalKey();

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                " *",
                style: TextStyle(
                    color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(height: 8),
          CompositedTransformTarget(
            link: _layerLink,
            child: Container(
              key: _key,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: ColorConstants.main),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 35),
                    child: SizedBox(
                      height: 35,
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: widget.selectedOptions.map((item) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6.0, left: 10),
                                    child: Chip(
                                      label: Text(item),
                                      onDeleted: () {
                                        setState(() {
                                          widget.selectedOptions.remove(item);
                                        });
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: !isDropdownOpen ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.keyboard_arrow_up),
                            onPressed: () {
                              setState(() {
                                isDropdownOpen = !isDropdownOpen;
                              });
                              if (isDropdownOpen) {
                                _showOverlay();
                              } else {
                                _hideOverlay();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final boxSize = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: boxSize.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, boxSize.height + 5),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: boxSize.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                height: 200, // Giới hạn chiều cao của dropdown
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.options.map((option) {
                      final isSelected = widget.selectedOptions.contains(option);
                      return ListTile(
                        title: Text(option),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              widget.selectedOptions.remove(option);
                            } else {
                              widget.selectedOptions.add(option);
                            }
                            isDropdownOpen = false;
                            _hideOverlay();
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    overlay?.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      isDropdownOpen = false;
    });
  }
}