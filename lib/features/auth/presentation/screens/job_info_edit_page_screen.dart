import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import '../cubit/candidate_cubit.dart';
import '../../../jobs/presentation/cubit/job_cubit.dart';
import '../../domain/entities/candidate.dart';
import '../../../../data/models/province.dart';
import '../../../../core/services/candidate_services.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/text_constants.dart';
import '../../../../core/constants/validate_constants.dart';
import '../../../../core/constants/value_constants.dart';
import '../../../../shared/widgets/input_field.dart';

import '../../../jobs/presentation/screens/cv_viewer_screen.dart';
import '../../../../shared/widgets/multi_select_drop_down_screen1.dart';
import '../../../../shared/widgets/single_select_drop_down_screen.dart';

class JobInfoEditPage extends StatefulWidget {
  const JobInfoEditPage({super.key});

  @override
  _JobInfoEditPageState createState() => _JobInfoEditPageState();
}

class _JobInfoEditPageState extends State<JobInfoEditPage> {
  final TextEditingController jobWantedController = TextEditingController();
  final TextEditingController coverLetterController = TextEditingController();
  late final JobCubit _cubit;
  late final CandidateCubit _candidateCubit;
  List<int> selectedPositionIds = [];
  List<int> selectedMajorIds = [];
  List<int> selectedJobTypeIds = [];
  String? selectedDesiredWorkingProvince;
  final _formKey = GlobalKey<FormState>();
  late Candidate _candidate;
  late String _token;
  File? selectedFileCV;
  String? selectedFileNameCV;
  late String email;
  late String password;
  String cvError = '';
  File? _selectedCV;
  List<Province> _provinces = [];

  @override
  void initState() {
    super.initState();
    _cubit = context.read<JobCubit>();
    _candidateCubit = context.read<CandidateCubit>();
    _getProvinces();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Tránh lỗi truy cập context quá sớm

    final candidateInfo =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _candidate = candidateInfo[TextConstants.candidate];
    _token = candidateInfo[TextConstants.token];
    selectedPositionIds = _candidate.positionDTOs!
        .map((pos) => pos[TextConstants.id] as int)
        .toList();
    selectedMajorIds = _candidate.majorDTOs!
        .map((maj) => maj[TextConstants.id] as int)
        .toList();
    selectedJobTypeIds = _candidate.scheduleDTOs!
        .map((sche) => sche[TextConstants.id] as int)
        .toList();
    selectedDesiredWorkingProvince = _candidate.desiredWorkingProvince!;
    jobWantedController.text = _candidate.desiredJob!;
    coverLetterController.text = _candidate.referenceLetter!;
    selectedFileNameCV = _candidate.cv; // Lưu tên file
  }

  Future<void> _getProvinces() async {
    // final provinces = await _cubit.getProvinces();
    // setState(() {
    //   _provinces = provinces;
    // });
  }

  void _viewFileCV() {
    if (selectedFileCV != null) {
      // Nếu CV là file cục bộ, mở bằng PDFView
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CVViewerScreen(
            path: selectedFileCV!.path,
          ),
        ),
      );
    } else {
      String fileUrl =CandidateServices.getCandidateAvatarLink(selectedFileNameCV!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CVViewerScreen(
            path: fileUrl,
          ),
        ),
      );
    }
  }

  Future<void> _pickFileCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
    );

    if (result != null) {
      setState(() {
        selectedFileNameCV = result.files.single.name;
        selectedFileCV = File(
            '/data/user/0/com.example.jobsit_mobile/cache/${result.files.single.name}');
        selectedFileCV!.writeAsBytesSync(result.files.single.bytes!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '${TextConstants.jobInformation}',

          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Căn giữa tiêu đề
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: ColorConstants.bgMain,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(TextConstants.jobWanted),
              //_buildTextField(jobWantedController, "Flutter Developer"),
              InputField(
                label: TextConstants.jobWanted,
                controller: jobWantedController,
                keyboardType: TextInputType.text,
                validateMethod: ValidateConstants.validateJobWanted,
              ),
              const SizedBox(height: 16),
              _buildDropdowns(),
              _buildLabel(TextConstants.cv),
              GestureDetector(
                onTap: () async {
                  await _pickFileCV();
                  setState(() {
                    cvError = ValidateConstants.validateCandidateCv(selectedFileCV) ?? '';
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: cvError == '' ? ColorConstants.main : Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedFileNameCV ?? TextConstants.pleaseSelectedFileCv,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              if (selectedFileNameCV != null) // Nút xem file
                                IconButton(
                                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                                  onPressed: () {
                                    _viewFileCV();
                                  },
                                ),
                              if (selectedFileNameCV != null) // Nút xóa file
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      selectedFileCV = null;
                                      selectedFileNameCV = null;

                                    });
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (cvError != '') // Hiển thị lỗi nếu có
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          cvError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
              _buildLabel(TextConstants.coverLetter),
              _buildMultilineTextField(coverLetterController,
                  TextConstants.writeABriefIntroductionAboutYourself),
              const SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdowns() {
    return Column(
      children: [

        SizedBox(
          height: 120,
          child: MultiSelectDropdownScreen(
            title: TextConstants.jobPosition,
            options: ValueConstants.positions,
            selectedOptionIds: selectedPositionIds,
            onSelectionChanged: (ids) {
              setState(() {
                selectedPositionIds = ids;
              });
            },
            validateMethod: (positions) => ValidateConstants.validatePosition(
                positions), // ✅ Thêm kiểm tra hợp lệ
          ),
        ),
        SizedBox(
          height: 120,
          child: MultiSelectDropdownScreen(
            title: TextConstants.major,
            options: ValueConstants.majors,
            selectedOptionIds: selectedMajorIds,
            onSelectionChanged: (ids) {
              setState(() {
                selectedMajorIds = ids;
              });
            },
            validateMethod: (majors) => ValidateConstants.validateMajor(
                majors), // ✅ Thêm kiểm tra hợp lệ
          ),
        ),
        SizedBox(
          height: 120,
          child: MultiSelectDropdownScreen(
            title: TextConstants.jobSchedule,
            options: ValueConstants.schedules,
            selectedOptionIds: selectedJobTypeIds,
            onSelectionChanged: (ids) {
              setState(() {
                selectedJobTypeIds = ids;
              });
            },
            validateMethod: (schedules) => ValidateConstants.validateSchedule(
                schedules), // ✅ Thêm kiểm tra hợp lệ
          ),
        ),

        SizedBox(
          height: 125,
          child: SingleSelectDropdown(
            title: TextConstants.jobLocation,
            options: _provinces.map((p) => p.name).toList(),
            initialValue: selectedDesiredWorkingProvince,
            onSelectionChanged: (selected) {
              setState(() {
                selectedDesiredWorkingProvince = selected;
              });
            },
            validateMethod: (location) =>
                ValidateConstants.validateLocation(location),
          ),
        ),
      ],
    );
  }

  Widget _buildMultilineTextField(
      TextEditingController controller, String placeholder) {
    return Container(
      decoration: BoxDecoration( border: Border.all(
        color:ColorConstants.main, // ✅ Đổi màu viền khi có lỗi
      ),
        borderRadius: BorderRadius.circular(8),),
      child: TextField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: placeholder,
            border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        ),
      ),
    )
      ;
  }


  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Row(
        children: [
          Text(text,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Text(" *",
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: handleUpdate,
        child: const Text(TextConstants.save,
            style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Future<void> handleUpdate() async {
    if (_formKey.currentState!.validate()) {
      await _candidateCubit.handleUpdate(
          user: _candidate,
          token: _token,
          position: selectedPositionIds,
          major: selectedMajorIds,
          jobType: selectedJobTypeIds,
          wantJob: jobWantedController.text,
          desiredWorkingProvince: selectedDesiredWorkingProvince!,
          coverLetter: coverLetterController.text, // ✅ Fix lỗi
          cv: selectedFileCV!
      );
      Navigator.pop(context);
    }
  }
}

