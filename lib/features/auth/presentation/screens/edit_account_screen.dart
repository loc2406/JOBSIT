import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_cubit.dart';
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_state.dart';
import 'package:jobsit_mobile/core/services/candidate_services.dart';
import 'package:jobsit_mobile/shared/extensions/text_input_formatter_exts.dart';
import 'package:jobsit_mobile/core/constants/validate_constants.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';

import '../../domain/entities/candidate.dart';
import '../../../../data/models/province.dart';
import '../../domain/entities/university.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/text_constants.dart';
import '../../../../core/constants/widget_constants.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late Candidate _candidate;
  late CandidateCubit _cubit;
  bool _isSetData = false;
  final _formKey = GlobalKey<FormState>();
  File? _selectedImg;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool? _selectedGender;
  String? _candidateCity;
  String? _candidateDistrict;
  String? _candidateUniversity;
  Province? _selectedCity;
  String? _selectedDistrict;
  University? _selectedUniversity;
  List<Province> _cities = [];
  List<String> _districts = [];
  List<University> _universities = [];
  late String _token;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CandidateCubit>();
  }

  Future<void> _loadInitialData() async {
    await _getProvinces();
    await _getUniversities();
  }

  Future<void> _getProvinces() async {
    final cities = await _cubit.getProvinces();
    setState(() {
      _cities = cities;
    });
  }

  Future<void> _getUniversities() async {
    final universities = await _cubit.getUniversities();
    setState(() {
      _universities = universities;
      try{
        _selectedUniversity =   _universities.firstWhere((uni) => uni.id == _candidate.university?.id);
      }catch(e){
        _selectedUniversity = null;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isSetData) {
      final candidateInfo =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _candidate = candidateInfo[TextConstants.candidate];
      _token = candidateInfo[TextConstants.token];
      _loadInitialData().whenComplete(() => _setCandidateData());
      _isSetData = true;
    }
  }

  void _setCandidateData() {
    final location = _candidate.location;

    if (location != null) {
      RegExp regex = RegExp(r"^(.*?),\s*(Huyện|Quận|Thành phố|thị xã)?\s*([^,]+),\s*(Tỉnh|Thành phố)?\s*(.+)$");
      Match? match = regex.firstMatch(location);

      if (match != null) {
        String address = match.group(1)?.trim() ?? "";
        _candidateDistrict = "${match.group(2) ?? ''} ${match.group(3) ?? ''}".trim();
        _candidateCity = "${match.group(4) ?? ''} ${match.group(5) ?? ''}".trim();

        debugPrint("Địa chỉ: $address");
        debugPrint("Quận/Huyện: $_candidateDistrict");
        debugPrint("Tỉnh: $_candidateCity");
        debugPrint("DS Tỉnh: ${_cities.length}");

        _addressController.text = address;

        setState(() {
          try {
            _selectedCity = _cities.firstWhere(
                    (province) => province.name.toLowerCase() == _candidateCity?.toLowerCase());
          } catch (e) {
            _selectedCity = null;
          }
        });

        if (_selectedCity != null) {
          _getDistrictsAndSetSelected();
        }
      }
    }

    _firstNameController.text = _candidate.firstName;
    _lastNameController.text = _candidate.lastName;
    _emailController.text = _candidate.email;
    _birthdateController.text =
        _candidate.birthdate ?? TextConstants.defaultCandidateBirthdate;
    _phoneController.text = _candidate.phone;
    _selectedGender = _candidate.isMale;
  }


  Future<void> _getDistrictsAndSetSelected() async {
    final List<String> districts = await _cubit.getDistricts(_selectedCity!.code);
    setState(() {
      _districts = districts;

      try {
        _selectedDistrict =
            _districts.firstWhere((district) => district.toLowerCase() ==
                _candidateDistrict?.toLowerCase());
      } catch (e) {
        _selectedDistrict = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const SizedBox(),
        title: const Text(
          TextConstants.personalInfo,
          style: WidgetConstants.mainBold16Style,
        ),
        centerTitle: true,
      ),
      body: BlocListener<CandidateCubit, CandidateState>(
        listener: (context, state) {
          if (state is AuthEditSuccessState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text(TextConstants.editSuccessful)));
            Navigator.pop(context);
          }
        },
        child: _buildEditWidget(),
      ),
    );
  }

  Widget _buildEditWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: ValueConstants.deviceWidthValue(uiValue: 25)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _selectImgFromGallery,
              child: Container(
                  width: ValueConstants.screenWidth * 0.25,
                  height: ValueConstants.screenWidth * 0.25,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorConstants.main, width: 2)),
                  child: ClipOval(
                    child: _selectedImg != null
                        ? Image.file(_selectedImg!)
                        : (_candidate.avatar != null
                            ? Image.network(
                                CandidateServices.getCandidateAvatarLink(
                                    _candidate.avatar!),
                                width: ValueConstants.screenWidth * 0.25,
                                height: ValueConstants.screenWidth * 0.25,
                                errorBuilder: (context, object, stacktrace) =>
                                    WidgetConstants
                                        .buildDefaultCandidateAvatar(),
                              )
                            : WidgetConstants.buildDefaultCandidateAvatar()),
                  )),
            ),
            ..._buildValidImageWidget(),
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._buildInputField(
                        title: TextConstants.firstName,
                        label: TextConstants.firstName,
                        controller: _firstNameController,
                        validateMethod: ValidateConstants.validateFirstName,
                        keyboardType: TextInputType.text,
                        inputFormatters: [OnlyLettersInputFormatter()]),
                    ..._buildInputField(
                        title: TextConstants.lastName,
                        label: TextConstants.lastName,
                        controller: _lastNameController,
                        validateMethod: ValidateConstants.validateLastName,
                        keyboardType: TextInputType.text,
                        inputFormatters: [OnlyLettersInputFormatter()]),
                    ..._buildInputField(
                        title: TextConstants.email,
                        label: TextConstants.email,
                        controller: _emailController,
                        validateMethod: ValidateConstants.validateEmailRegister,
                        keyboardType: TextInputType.emailAddress,
                        isReadOnly: true),
                    ..._buildSelectBirthdateField(),
                    ..._buildInputField(
                        title: TextConstants.phone,
                        label: TextConstants.phone,
                        controller: _phoneController,
                        validateMethod:
                            ValidateConstants.validatePhone,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ]),
                    ..._buildSelectGenderField(),
                    ..._buildSelectCityField(),
                    ..._buildSelectDistrictField(),
                    ..._buildInputField(
                      title: TextConstants.address,
                      label: TextConstants.address,
                      controller: _addressController,
                      validateMethod: ValidateConstants.validateAddress,
                      keyboardType: TextInputType.text,
                    ),
                   ..._buildSelectSchoolField(),
                    SizedBox(
                      height: ValueConstants.deviceHeightValue(uiValue: 20),
                    ),
                    GestureDetector(
                      onTap: _handleUpdateInfo,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                ValueConstants.deviceHeightValue(uiValue: 16),
                            horizontal:
                                ValueConstants.deviceWidthValue(uiValue: 20)),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ColorConstants.main,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          TextConstants.save,
                          style: WidgetConstants.whiteBold16Style,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ValueConstants.deviceHeightValue(uiValue: 10),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImgFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImg = File(image.path);
      });
    }
  }

  List<Widget> _buildTitle(String title) {
    return [
      SizedBox(
        height: ValueConstants.deviceHeightValue(uiValue: 20),
      ),
      Text(
        title,
        style: WidgetConstants.mainBold16Style,
      ),
      SizedBox(
        height: ValueConstants.deviceHeightValue(uiValue: 10),
      ),
    ];
  }

  List<Widget> _buildInputField({
    required String title,
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validateMethod,
    required TextInputType keyboardType,
    bool isReadOnly = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return [
      ..._buildTitle(title),
      TextFormField(
        style: WidgetConstants.black16Style,
        controller: controller,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          filled: true,
          fillColor: title == TextConstants.email ? ColorConstants.grayBackground : Colors.white,
          hintText: label,
          hintStyle: const TextStyle(color: ColorConstants.grey),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          enabledBorder: WidgetConstants.inputFieldBorder,
          focusedBorder: WidgetConstants.inputFieldBorder,
          errorStyle: WidgetConstants.inputFieldErrStyle,
          errorBorder: WidgetConstants.inputFieldBorder,
          focusedErrorBorder: WidgetConstants.inputFieldBorder,
        ),
        validator: validateMethod,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
      )
    ];
  }

  List<Widget> _buildSelectBirthdateField() {
    return [
      ..._buildTitle(TextConstants.birthdate),
      TextFormField(
        style: WidgetConstants.black16Style,
        controller: _birthdateController,
        readOnly: true,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: TextConstants.defaultCandidateBirthdate,
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          hintStyle: TextStyle(color: ColorConstants.grey),
          suffixIcon: Icon(Icons.arrow_drop_down, color: ColorConstants.main,),
          enabledBorder: WidgetConstants.inputFieldBorder,
          focusedBorder: WidgetConstants.inputFieldBorder,
          errorBorder: WidgetConstants.inputFieldBorder,
          focusedErrorBorder: WidgetConstants.inputFieldBorder,
          errorStyle: WidgetConstants.inputFieldErrStyle,
        ),
        validator: ValidateConstants.validateBirthdate,
        onTap: () => _showDatePicker(),
      ),
    ];
  }

  Future<void> _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: null,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _birthdateController.text =
            "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      });
    }else{
      setState(() {
        _birthdateController.text = TextConstants.defaultCandidateBirthdate;
      });
    }
  }

  List<Widget> _buildSelectGenderField() {
    return [
      ..._buildTitle(TextConstants.gender),
      DropdownButtonFormField<bool?>(
        value: _selectedGender,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          errorStyle: WidgetConstants.inputFieldErrStyle,
          enabledBorder: WidgetConstants.inputFieldBorder,
          focusedBorder: WidgetConstants.inputFieldBorder,
          errorBorder: WidgetConstants.inputFieldBorder,
          focusedErrorBorder: WidgetConstants.inputFieldBorder,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: const [
          DropdownMenuItem(
            value: null,
            child: Text(
              TextConstants.selectGender,
              style: WidgetConstants.black16Style,
            ),
          ),
          DropdownMenuItem(
            value: true,
            child: Text(
              TextConstants.male,
              style: WidgetConstants.black16Style,
            ),
          ),
          DropdownMenuItem(
            value: false,
            child:
                Text(TextConstants.female, style: WidgetConstants.black16Style),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
          });
        },
        icon: const Icon(
          Icons.arrow_drop_down,
          color: ColorConstants.main,
        ),
        validator: ValidateConstants.validateGender,
      )
    ];
  }

  List<Widget> _buildSelectCityField() {
    return [
      ..._buildTitle(TextConstants.city),
      DropdownButtonFormField<Province?>(
        style: WidgetConstants.black16Style,
        value: _selectedCity,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          errorStyle: WidgetConstants.inputFieldErrStyle,
          enabledBorder: WidgetConstants.inputFieldBorder,
          focusedBorder: WidgetConstants.inputFieldBorder,
          errorBorder: WidgetConstants.inputFieldBorder,
          focusedErrorBorder: WidgetConstants.inputFieldBorder,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: [
          const DropdownMenuItem(
            value: null,
            child: Text(
              TextConstants.selectLocation,
              style: WidgetConstants.black16Style,
            ),
          ),
          ..._cities.map(
            (province) => DropdownMenuItem(
              value: province,
              child: Text(
                province.name,
                style: WidgetConstants.black16Style,
              ),
            ),
          )
        ],
        onChanged: (value) async {
          final List<String> districts = (value != null) ? await _cubit.getDistricts(value.code) : [];
          setState(() {
            _selectedCity = value;
            _districts = districts;
            _selectedDistrict = null;
          });
        },
        icon: const Icon(
          Icons.arrow_drop_down,
          color: ColorConstants.main,
        ),
        validator: ValidateConstants.validateCity,
      )
    ];
  }

  List<Widget> _buildSelectDistrictField() {
    return [
      ..._buildTitle(TextConstants.district),
      DropdownButtonFormField<String>(
        style: WidgetConstants.black16Style,
        value: _selectedDistrict,
        decoration: const InputDecoration(
          filled: true,
          errorStyle: WidgetConstants.inputFieldErrStyle,
          fillColor: Colors.white,
          enabledBorder: WidgetConstants.inputFieldBorder,
          focusedBorder: WidgetConstants.inputFieldBorder,
          errorBorder: WidgetConstants.inputFieldBorder,
          focusedErrorBorder: WidgetConstants.inputFieldBorder,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: [
          const DropdownMenuItem(
            value: null,
            child: Text(
              TextConstants.selectLocation,
              style: WidgetConstants.black16Style,
            ),
          ),
          ..._districts.map(
            (province) => DropdownMenuItem(
              value: province,
              child: Text(
                province,
                style: WidgetConstants.black16Style,
              ),
            ),
          )
        ],
        onChanged: (value) {
          setState(() {
            _selectedDistrict = value;
          });
        },
        icon: const Icon(
          Icons.arrow_drop_down,
          color: ColorConstants.main,
        ),
        validator: ValidateConstants.validateDistrict,
      )
    ];
  }

  List<Widget> _buildSelectSchoolField() {
    return [
      ..._buildTitle(TextConstants.university),
      DropdownButtonFormField<University?>(
        isExpanded: true ,
        style: WidgetConstants.black16Style,
        value: _selectedUniversity,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          errorStyle: WidgetConstants.inputFieldErrStyle,
          enabledBorder: WidgetConstants.inputFieldBorder,
          focusedBorder: WidgetConstants.inputFieldBorder,
          errorBorder: WidgetConstants.inputFieldBorder,
          focusedErrorBorder: WidgetConstants.inputFieldBorder,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: [
          const DropdownMenuItem(
            value: null,
            child: Text(
              TextConstants.selectUniversity,
              style: WidgetConstants.black16Style,
            ),
          ),
          ..._universities.map(
                (university) => DropdownMenuItem(
              value: university,
              child: Tooltip(
                message: university.name,
                child: Text(
                  university.name,
                  style: WidgetConstants.black16Style,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          )
        ],
        onChanged: (value){
          setState(() {
            _selectedUniversity = value;
          });
        },
        icon: const Icon(
          Icons.arrow_drop_down,
          color: ColorConstants.main,
        ),
      )
    ];
  }

  Future<void> _handleUpdateInfo() async {
    if ((_formKey.currentState as FormState).validate() &&
        _selectedImg != null) {
      await _cubit.updateInfo(
          candidateId: _candidate.id,
          token: _token,
          avatar: _selectedImg,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          birthdate: _birthdateController.text,
          phone: _phoneController.text,
          gender: _selectedGender,
          location:
              '${_addressController.text}, $_selectedDistrict, ${_selectedCity!.name}',
          university: _selectedUniversity
      );
    }
  }

  List<Widget> _buildValidImageWidget() {
    final validateMessage =
        ValidateConstants.validateCandidateAvatar(_selectedImg);
    return [
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 20),
            ),
            Text(
              validateMessage!,
              style: WidgetConstants.redItalic16Style,
            )
          ];
  }
}
