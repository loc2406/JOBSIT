
import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';

class MultiSelectDropdownScreen extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> options;
  final List<int> selectedOptionIds;
  final Function(List<int>) onSelectionChanged;
  final String? Function(List<int>?)? validateMethod; // ✅ Thêm hàm kiểm tra điều kiện

  const MultiSelectDropdownScreen({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOptionIds,
    required this.onSelectionChanged,
    this.validateMethod, // ✅ Nhận hàm kiểm tra
  });

  @override
  _MultiSelectDropdownScreenState createState() =>
      _MultiSelectDropdownScreenState();
}

class _MultiSelectDropdownScreenState extends State<MultiSelectDropdownScreen> {
  bool isDropdownOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _key = GlobalKey();
  String? errorText; // ✅ Lưu lỗi hiển thị



  void _validate() {
    setState(() {
      errorText = widget.validateMethod?.call(widget.selectedOptionIds);
    });
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
                border: Border.all(
                  color: errorText == null ? ColorConstants.main : Colors.red, // ✅ Đổi màu viền khi có lỗi
                ),
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
                                children: widget.selectedOptionIds.map((id) {
                                  String name = widget.options
                                      .firstWhere((item) => item['id'] == id)['name'];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6.0, left: 10),
                                    child: Chip(
                                      label: Text(name),
                                      onDeleted: () {
                                        setState(() {
                                          widget.selectedOptionIds.remove(id);
                                          _validate(); // ✅ Kiểm tra lại khi xoá item
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
          if (errorText != null) // ✅ Hiển thị lỗi nếu có
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
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
                      final int id = option['id'];
                      final String name = option['name'];
                      final bool isSelected = widget.selectedOptionIds.contains(id);
                      return ListTile(
                        title: Text(name),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              widget.selectedOptionIds.remove(id);
                            } else {
                              widget.selectedOptionIds.add(id);
                            }
                            isDropdownOpen = false;
                            _hideOverlay();
                            widget.onSelectionChanged(widget.selectedOptionIds);
                            _validate(); // ✅ Kiểm tra hợp lệ sau khi chọn item
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

  void _hideOverlay({bool updateState = true}) {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (updateState && mounted) {
      setState(() {
        isDropdownOpen = false;
      });
    } else {
      isDropdownOpen = false;
    }
  }

}

