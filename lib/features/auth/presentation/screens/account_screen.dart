import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsit_mobile/features/applied_jobs/cubit/applied_job_cubit.dart';
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_cubit.dart';
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_state.dart';
import 'package:jobsit_mobile/features/saved_jobs/cubit/saved_job_cubit.dart';
import 'package:jobsit_mobile/features/auth/presentation/screens/edit_account_screen.dart';
import 'package:jobsit_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:jobsit_mobile/core/services/candidate_services.dart';
import 'package:jobsit_mobile/core/constants/asset_constants.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/data/datasources/shared_prefs.dart';
import 'package:jobsit_mobile/core/constants/text_constants.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';
import 'package:jobsit_mobile/core/constants/widget_constants.dart';
import 'package:jobsit_mobile/shared/extensions/context_exts.dart';

import '../../domain/entities/candidate.dart';
import 'job_info_edit_page_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _isAllowedSearch = false;
  bool _onReceiveEmail = false;
  late CandidateCubit _cubit;
  late Candidate _candidate;
  late String _token;

  ThemeData get _theme => Theme.of(context);

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CandidateCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _theme.primaryColor,
        title: Text(
          'screen.account.title'.tr(),
          style: _theme.textTheme.displayMedium
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<CandidateCubit, CandidateState>(
        builder: (context, state) {
          if (state is AuthNoLoggedInState) {
            return _buildNoLoggedInWidget();
          } else if (state is AuthLoadingState) {
            return const Center(
              child: WidgetConstants.circularProgress,
            );
          } else if (state is AuthLoginSuccessState) {
            _candidate = state.candidate;
            _token = state.token;
            _isAllowedSearch = state.candidate.searchable;
            _onReceiveEmail = state.candidate.mailReceive;
            return _buildProfile();
          } else {
            return const SizedBox();
          }
        },
        listener: (context, state) {
          if (state is AuthLogoutState) {
            context.showNotification('notification.account.logout'.tr());
          }
        },
      ),
    );
  }

  Widget _buildNoLoggedInWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: double.infinity,
          child: Text(
            TextConstants.dontLoggedIn,
            style: WidgetConstants.blackBold16Style,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: ValueConstants.deviceHeightValue(uiValue: 10),
        ),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: ColorConstants.main),
            child: const Text(
              TextConstants.login,
              style: WidgetConstants.whiteBold16Style,
              textAlign: TextAlign.center,
            ),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
        )
      ],
    );
  }

  Widget _buildProfile() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ValueConstants.deviceWidthValue(uiValue: 25),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 15),
            ),
            Container(
              width: ValueConstants.screenWidth * 0.25,
              height: ValueConstants.screenWidth * 0.25,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: _theme.primaryColor, width: 2),
              ),
              child: ClipOval(
                child: _candidate.avatar != null
                    ? Image.network(
                        CandidateServices.getCandidateAvatarLink(
                            _candidate.avatar!),
                        width: ValueConstants.screenWidth * 0.25,
                        height: ValueConstants.screenWidth * 0.25,
                        errorBuilder: (context, object, stacktrace) =>
                            _buildDefaultCandidateAvatar(),
                      )
                    : _buildDefaultCandidateAvatar(),
              ),
            ),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 15),
            ),
            Text(
              '${_candidate.firstName} ${_candidate.lastName}',
              style: _theme.textTheme.displayLarge
                  ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: const Icon(
                          Icons.person_outline_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ValueConstants.deviceHeightValue(uiValue: 5),
                    ),
                    Text(
                      'screen.account.applied'.tr(),
                      style: _theme.textTheme.labelSmall,
                    ),
                    SizedBox(
                      height: ValueConstants.deviceHeightValue(uiValue: 5),
                    ),
                    Text(
                      '0',
                      style: _theme.textTheme.labelSmall?.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: ValueConstants.deviceWidthValue(uiValue: 50),
                ),
                Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: const Icon(
                          Icons.home_repair_service_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ValueConstants.deviceHeightValue(uiValue: 5),
                    ),
                    Text(
                      'screen.account.saved'.tr(),
                      style: _theme.textTheme.labelSmall,
                    ),
                    SizedBox(
                      height: ValueConstants.deviceHeightValue(uiValue: 5),
                    ),
                    Text('0',
                        style: _theme.textTheme.labelSmall?.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 10),
            ),
            SwitchListTile(
              value: _isAllowedSearch,
              onChanged: (value) async {
                await _cubit.updateSearchable(_candidate.id, _token);
              },
              title: Text(
                'screen.account.allow_searchable'.tr(),
                style: _theme.textTheme.labelMedium?.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              thumbColor: const WidgetStatePropertyAll(Colors.white),
              trackColor: WidgetStatePropertyAll(
                  _isAllowedSearch ? ColorConstants.main : ColorConstants.grey),
              contentPadding: const EdgeInsets.all(0),
            ),
            SwitchListTile(
              value: _onReceiveEmail,
              onChanged: (value) async {
                await _cubit.updateMailReceive(_candidate.id, _token);
              },
              title: Text(
                'screen.account.email_notification'.tr(),
                style: _theme.textTheme.labelMedium?.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              thumbColor: const WidgetStatePropertyAll(Colors.white),
              trackColor: WidgetStatePropertyAll(
                  _onReceiveEmail ? ColorConstants.main : ColorConstants.grey),
              contentPadding: const EdgeInsets.all(0),
            ),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 20),
            ),
            ..._buildPersonalInfo(),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 20),
            ),
            ..._buildJobInfo(),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 20),
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: ValueConstants.deviceHeightValue(uiValue: 16),
                    horizontal: ValueConstants.deviceWidthValue(uiValue: 20)),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _theme.primaryColor),
                ),
                child: Text(
                  'screen.account.change_password'.tr(),
                  style: _theme.textTheme.displayMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 10),
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: ValueConstants.deviceHeightValue(uiValue: 16),
                    horizontal: ValueConstants.deviceWidthValue(uiValue: 20)),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorConstants.main,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'screen.account.logout'.tr(),
                  style: _theme.textTheme.displayMedium?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () async {
                await _cubit.logout(_token);
                if (mounted) {
                  context.read<SavedJobCubit>().clearAllSavedJobs();
                  context.read<AppliedJobCubit>().clearAllAppliedJobs();
                }
              },
            ),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultCandidateAvatar() {
    return Icon(Icons.image_outlined,
        color: _theme.primaryColor, size: ValueConstants.screenWidth * 0.1);
  }

  List<Widget> _buildPersonalInfo() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'screen.account.personal_info'.tr(),
            style: _theme.textTheme.displayMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            child: SvgPicture.asset(
              AssetConstants.iconEdit,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditAccountScreen(),
                    settings: RouteSettings(arguments: {
                      TextConstants.candidate: _candidate,
                      TextConstants.token: _token,
                    })),
              );
            },
          )
        ],
      ),
      SizedBox(
        height: ValueConstants.deviceHeightValue(uiValue: 10),
      ),
      Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            _buildPersonalInfoItem(
                AssetConstants.iconMessage,
                (_candidate.email.isNotEmpty)
                    ? _candidate.email
                    : 'screen.account.no_data'.tr()),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 10),
            ),
            _buildPersonalInfoItem(
                AssetConstants.iconCall,
                (_candidate.phone.isNotEmpty)
                    ? _candidate.phone
                    : 'screen.account.no_data'.tr()),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 10),
            ),
            _buildPersonalInfoItem(
                AssetConstants.iconLocation,
                (_candidate.location != null && _candidate.location!.isNotEmpty)
                    ? _candidate.location!
                    : 'screen.account.no_data'.tr()),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 10),
            ),
            _buildPersonalInfoItem(
                AssetConstants.iconHome,
                _candidate.university != null
                    ? _candidate.university!.name
                    : 'screen.account.no_data'.tr()),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 10),
            ),
            _buildPersonalInfoItem(
                AssetConstants.iconCalendar,
                (_candidate.birthdate != null &&
                        _candidate.birthdate!.isNotEmpty)
                    ? _candidate.birthdate!
                    : TextConstants.noData),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 10),
            ),
            _buildPersonalInfoItem(AssetConstants.iconProfile,
                _candidate.isMale ? TextConstants.male : TextConstants.female)
          ],
        ),
      )
    ];
  }

  Widget _buildPersonalInfoItem(String asset, String info) {
    return Row(
      children: [
        SvgPicture.asset(asset),
        SizedBox(
          width: ValueConstants.deviceWidthValue(uiValue: 10),
        ),
        Expanded(
            child: Text(
          info,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: _theme.textTheme.displaySmall?.copyWith(color: Colors.black),
        ))
      ],
    );
  }

  List<Widget> _buildJobInfo() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'screen.account.job_info'.tr(),
            style: _theme.textTheme.displayMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          GestureDetector(
              child: SvgPicture.asset(
                AssetConstants.iconEdit,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const JobInfoEditPage(),
                      settings: RouteSettings(arguments: {
                        TextConstants.candidate: _candidate,
                        TextConstants.token: _token,
                      })),
                );
              })
        ],
      ),
      SizedBox(
        height: ValueConstants.deviceHeightValue(uiValue: 10),
      ),
      Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'screen.account.desired_job'.tr(),
              style: _theme.textTheme.displayMedium
                  ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 5),
            ),
            Text(
              _candidate.desiredJob != null ||
                      _candidate.desiredJob?.isNotEmpty == true
                  ? _candidate.desiredJob!
                  : 'screen.account.no_data'.tr(),
              style:
                  _theme.textTheme.displaySmall?.copyWith(color: Colors.black),
            ),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 10),
            ),
            ..._candidate.positionDTOs != null &&
                    _candidate.positionDTOs?.isNotEmpty == true
                ? _buildJobInfoItems('screen.account.job_position'.tr(),
                    _candidate.positionDTOs!)
                : _buildJobInfoItem('screen.account.job_position'.tr(),
                    'screen.account.no_data'.tr()),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 10),
            ),
            ..._candidate.majorDTOs != null &&
                    _candidate.majorDTOs?.isNotEmpty == true
                ? _buildJobInfoItems(
                    'screen.account.job_major'.tr(), _candidate.majorDTOs!)
                : _buildJobInfoItem('screen.account.job_major'.tr(),
                    'screen.account.no_data'.tr()),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 10),
            ),
            ..._candidate.scheduleDTOs != null &&
                    _candidate.scheduleDTOs?.isNotEmpty == true
                ? _buildJobInfoItems('screen.account.job_schedule'.tr(),
                    _candidate.scheduleDTOs!)
                : _buildJobInfoItem('screen.account.job_schedule'.tr(),
                    'screen.account.no_data'.tr()),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 10),
            ),
            Text(
              'screen.account.working_place'.tr(),
              style: _theme.textTheme.displayMedium
                  ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                SvgPicture.asset(AssetConstants.iconLocation),
                SizedBox(
                  width: ValueConstants.deviceWidthValue(uiValue: 10),
                ),
                Text((_candidate.desiredWorkingProvince != null &&
                        _candidate.desiredWorkingProvince?.isNotEmpty == true)
                    ? _candidate.desiredWorkingProvince!
                    : 'screen.account.no_data'.tr()),
              ],
            ),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 10),
            ),
            ..._buildJobInfoItem(
                'screen.account.cv'.tr(),
                (_candidate.cv != null && _candidate.cv?.isNotEmpty == true)
                    ? _candidate.cv!
                    : 'screen.account.no_data'.tr()),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 10),
            ),
            Text(
              'screen.account.reference_letter'.tr(),
              style: _theme.textTheme.displayMedium
                  ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 5),
            ),
            Text((_candidate.referenceLetter != null &&
                    _candidate.referenceLetter?.isNotEmpty == true)
                ? _candidate.referenceLetter!
                : 'screen.account.no_data'.tr()),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildJobInfoItem(String title, String content) {
    return [
      Text(
        title,
        style: _theme.textTheme.displayMedium
            ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: ValueConstants.deviceHeightValue(uiValue: 5),
      ),
      Text(
        content,
        style: _theme.textTheme.displaySmall?.copyWith(color: Colors.black),
      )
    ];
  }

  List<Widget> _buildJobInfoItems(
      String title, List<Map<String, dynamic>> items) {
    return [
      Text(
        title,
        style: _theme.textTheme.displayMedium
            ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 5)),
      Wrap(
        spacing: 8,
        runSpacing: 4,
        children: items.map((item) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: _theme.primaryColor,
            ),
            child: Text(
              item['name'],
              style:
                  _theme.textTheme.labelMedium?.copyWith(color: Colors.white),
            ),
          );
        }).toList(),
      ),
    ];
  }
}
