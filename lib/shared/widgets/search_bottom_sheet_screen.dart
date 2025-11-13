import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBottomSheet<T> extends StatefulWidget {
 const SearchBottomSheet({super.key, required this.searchHint, required this.items, required this.itemLabel, required this.onSelected});

  final String searchHint;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T) onSelected;

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState<T> extends State<SearchBottomSheet<T>> {

  late final String _searchHint;
  late final List<T> _items;
  late final String Function(T) _itemLabel;
  late final void Function(T) _onSelected;
  TextEditingController _searchController = TextEditingController();
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _searchHint = widget.searchHint;
    _items = widget.items;
    _itemLabel = widget.itemLabel;
    _onSelected = widget.onSelected;
    _filteredItems = List.from(_items);
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: _searchHint,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: (query) {
              setState(() {
                _filteredItems = _items
                    .where((item) => _itemLabel(item).toLowerCase().contains(query.toLowerCase()))
                    .toList();
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_itemLabel(_filteredItems[index])),
                  onTap: () {
                    _onSelected(_filteredItems[index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
