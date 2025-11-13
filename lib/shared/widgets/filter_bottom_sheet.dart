import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:jobsit_mobile/data/models/province.dart';
import 'package:jobsit_mobile/core/services/job_services.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/core/constants/convert_constants.dart';
import 'package:jobsit_mobile/core/constants/text_constants.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';

class FilterBottomSheet extends StatefulWidget {
  FilterBottomSheet(
      {super.key,
      required this.selectedLocation,
      required this.selectedSchedule,
      required this.selectedPosition,
      required this.selectedMajor,
      required this.provinces,
      required this.onApply});

  late String selectedLocation;
  late String selectedSchedule;
  late String selectedPosition;
  late String selectedMajor;
  late List<Province> provinces;
  late void Function(String, String, String, String) onApply;

  @override
  State<StatefulWidget> createState() => FilterBottomSheetState();
}

class FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _selectedLocation;
  late String _selectedSchedule;
  late String _selectedPosition;
  late String _selectedMajor;
  late List<Province> _provinces;
  late void Function(String, String, String, String) _onApply;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.selectedLocation;
    _selectedSchedule = widget.selectedSchedule;
    _selectedPosition = widget.selectedPosition;
    _selectedMajor = widget.selectedMajor;
    _provinces = widget.provinces;
    _onApply = widget.onApply;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: ValueConstants.deviceHeightValue(uiValue: 30),
          horizontal: ValueConstants.deviceWidthValue(uiValue: 25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: ColorConstants.main,
              ),
              Text(
                TextConstants.location,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ColorConstants.main),
              )
            ],
          ),
          SizedBox(
            height: ValueConstants.deviceHeightValue(uiValue: 15),
          ),
          DropdownButton<String>(
            menuMaxHeight: ValueConstants.screenHeight * 0.15,
            isExpanded: true,
            items: _buildListProvinces(),
            value:  _selectedLocation,
            onChanged: (String? value) {
              setState(() {
                _selectedLocation = value!;
              });
            },
          ),
          SizedBox(
            height: ValueConstants.deviceHeightValue(uiValue: 15),
          ),
          ..._buildFilterSection(
              title: TextConstants.jobSchedule,
              options: ValueConstants.schedules,
              selectedName: _selectedSchedule,
              onSelectedItem: (name) {
                setState(() {
                  if (_selectedSchedule == name){
                    _selectedSchedule = '';
                  }else{
                    _selectedSchedule = name;
                  }
                });
          }),
          SizedBox(
            height: ValueConstants.deviceHeightValue(uiValue: 15),
          ),
          ..._buildFilterSection(
              title: TextConstants.jobPosition,
              options: ValueConstants.positions,
              selectedName: _selectedPosition,
              onSelectedItem: (name) {
                setState(() {
                  if (_selectedPosition == name){
                    _selectedPosition = '';
                  }else{
                    _selectedPosition = name;
                  }
                });
          }),
          SizedBox(
            height: ValueConstants.deviceHeightValue(uiValue: 15),
          ),
          ..._buildFilterSection(
              title: TextConstants.major,
              options: ValueConstants.majors,
              selectedName: _selectedMajor,
              onSelectedItem: (name) {
            setState(() {
              if (_selectedMajor == name){
                _selectedMajor = '';
              }else{
                _selectedMajor = name;
              }
            });
          }),
          SizedBox(
            height: ValueConstants.deviceHeightValue(uiValue: 30),
          ),
          GestureDetector(
            onTap: handleApplyFilter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: ValueConstants.deviceHeightValue(uiValue: 16),
                  horizontal: ValueConstants.deviceWidthValue(uiValue: 20)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: ColorConstants.main),
              child: const Text(
                textAlign: TextAlign.center,
                TextConstants.applyFilter,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildListProvinces(){
    return [
      const DropdownMenuItem(
        value: '',
        child: Text(TextConstants.selectLocation),
      ),
      ..._provinces
          .map((province) => DropdownMenuItem(
        value: province.name,
        child: Text(province.name),
      ))
    ];
  }

  List<Widget> _buildFilterSection(
      {required String title,
      required List<Map<String, dynamic>> options,
      required String selectedName,
      required void Function(String name) onSelectedItem}) {
    return [
      Text(
        title,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: ColorConstants.main),
      ),
      SizedBox(
        height: ValueConstants.deviceHeightValue(uiValue: 5),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filterItem(options: options, selectedName: selectedName, onSelectedItem: onSelectedItem),
        ),
      )
    ];
  }

  List<Widget> _filterItem(
      {required List<Map<String, dynamic>> options,
      required String selectedName,
      required void Function(String name) onSelectedItem}) {
    return options
        .map((item) => GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.only(
                    right: ValueConstants.deviceWidthValue(uiValue: 10)),
                decoration: BoxDecoration(
                    color: item[JobServices.nameKey] == selectedName
                        ? ColorConstants.main
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: const Border.fromBorderSide(
                        BorderSide(color: ColorConstants.main))),
                child: Text(
                  item[JobServices.nameKey].toString(),
                  style: TextStyle(
                      color: item[JobServices.nameKey] == selectedName
                          ? Colors.white
                          : Colors.black,
                      fontSize: 13),
                ),
              ),
              onTap: () => onSelectedItem(item[JobServices.nameKey]),
            ))
        .toList();
  }

  void handleApplyFilter() {
    _onApply(_selectedLocation, _selectedSchedule, _selectedPosition, _selectedMajor);
    Navigator.pop(context);
  }
}
