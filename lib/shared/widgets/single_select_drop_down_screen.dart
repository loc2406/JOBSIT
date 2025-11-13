//
// import 'package:flutter/material.dart';
//
// class SingleSelectDropdown extends StatefulWidget {
//   final String title;
//   final List<String> options;
//   final Function(String?) onSelectionChanged;
//   final String? initialValue; // ✅ Thêm giá trị mặc định
//
//   const SingleSelectDropdown({
//     Key? key,
//     required this.title,
//     required this.options,
//     required this.onSelectionChanged,
//     this.initialValue, // ✅ Nhận giá trị mặc định
//   }) : super(key: key);
//
//   @override
//   _SingleSelectDropdownState createState() => _SingleSelectDropdownState();
// }
//
// class _SingleSelectDropdownState extends State<SingleSelectDropdown> {
//   String? selectedOption;
//   bool isDropdownOpen = false;
//   OverlayEntry? _overlayEntry;
//   final LayerLink _layerLink = LayerLink();
//   final GlobalKey _key = GlobalKey();
//
//   @override
//   void initState() {
//     super.initState();
//     selectedOption = widget.initialValue; // ✅ Gán giá trị mặc định khi khởi tạo
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(0.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 widget.title,
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const Text(" *", style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
//             ],
//           ),
//           const SizedBox(height: 6),
//           CompositedTransformTarget(
//             link: _layerLink,
//             child: Container(
//               key: _key,
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.blue),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: selectedOption == null
//                         ? const Text("Chọn một mục", style: TextStyle(color: Colors.grey))
//                         : Align(
//                       alignment: Alignment.centerLeft,
//                       child: Chip(
//                         label: Text(selectedOption!),
//                         onDeleted: () {
//                           setState(() {
//                             selectedOption = null;
//                             widget.onSelectionChanged(null);
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: !isDropdownOpen ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.keyboard_arrow_up),
//                     onPressed: () {
//                       setState(() {
//                         isDropdownOpen = !isDropdownOpen;
//                       });
//                       if (isDropdownOpen) {
//                         _showOverlay();
//                       } else {
//                         _hideOverlay();
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showOverlay() {
//     final overlay = Overlay.of(context);
//     final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
//     final boxSize = renderBox.size;
//
//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         width: boxSize.width,
//         child: CompositedTransformFollower(
//           link: _layerLink,
//           offset: Offset(0, boxSize.height + 5),
//           child: Material(
//             elevation: 4,
//             borderRadius: BorderRadius.circular(8),
//             child: Container(
//               width: boxSize.width,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: ConstrainedBox(
//                 constraints: const BoxConstraints(
//                   maxHeight: 250,
//                 ),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: widget.options.map((option) {
//                       return ListTile(
//                         title: Text(option),
//                         onTap: () {
//                           setState(() {
//                             selectedOption = option;
//                             isDropdownOpen = false;
//                             _hideOverlay();
//                           });
//                           widget.onSelectionChanged(option);
//                         },
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//     overlay?.insert(_overlayEntry!);
//   }
//
//   void _hideOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//     setState(() {
//       isDropdownOpen = false;
//     });
//   }
// }
import 'package:flutter/material.dart';

import '../../main.dart' as ColorConstants;



class SingleSelectDropdown extends StatefulWidget {
  final String title;
  final List<String> options;
  final Function(String?) onSelectionChanged;
  final String? initialValue;
  final String? Function(String?)? validateMethod; // ✅ Thêm hàm kiểm tra điều kiện

  const SingleSelectDropdown({
    Key? key,
    required this.title,
    required this.options,
    required this.onSelectionChanged,
    this.initialValue,
    this.validateMethod, // ✅ Nhận hàm kiểm tra
  }) : super(key: key);

  @override
  _SingleSelectDropdownState createState() => _SingleSelectDropdownState();
}

class _SingleSelectDropdownState extends State<SingleSelectDropdown> {
  String? selectedOption;
  bool isDropdownOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _key = GlobalKey();
  String? errorText; // ✅ Biến lưu lỗi

  @override
  void initState() {
    super.initState();
    selectedOption = widget.initialValue;
    _validate(); // ✅ Kiểm tra ngay khi khởi tạo
  }

  void _validate() {
    setState(() {
      errorText = widget.validateMethod?.call(selectedOption);
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
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(" *", style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          CompositedTransformTarget(
            link: _layerLink,
            child: Container(
              key: _key,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: errorText == null ? Colors.amber : Colors.red), // ✅ Đổi màu viền khi có lỗi
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: selectedOption == null
                        ? const Text("Chọn một mục", style: TextStyle(color: Colors.grey))
                        : Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text(selectedOption!),
                        onDeleted: () {
                          setState(() {
                            selectedOption = null;
                            widget.onSelectionChanged(null);
                            _validate(); // ✅ Kiểm tra lại khi xóa lựa chọn
                          });
                        },
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
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.options.map((option) {
                      return ListTile(
                        title: Text(option),
                        onTap: () {
                          setState(() {
                            selectedOption = option;
                            isDropdownOpen = false;
                            _hideOverlay();
                          });
                          widget.onSelectionChanged(option);
                          _validate(); // ✅ Kiểm tra hợp lệ sau khi chọn
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
