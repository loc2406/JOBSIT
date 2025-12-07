import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobsit_mobile/app/router.dart';
import 'package:jobsit_mobile/app/theme.dart';
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_cubit.dart';
import 'package:jobsit_mobile/features/applied_jobs/presentation/screens/applied_job_screen.dart';
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_state.dart';
import 'package:jobsit_mobile/features/jobs/presentation/screens/jobs_screen.dart';
import 'package:jobsit_mobile/features/saved_jobs/presentation/screens/saved_job_screen.dart';
import 'package:jobsit_mobile/shared/widgets/bottom_nav_item.dart';

import '../../../auth/presentation/screens/account_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final CandidateCubit _cubit;

  List<Widget> _screens = [];

  final int _jobIndex = 0;
  final int _appliedIndex = 1;
  final int _savedIndex = 2;
  final int _accountIndex = 3;

  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = _jobIndex;
    _cubit = context.read<CandidateCubit>();
    _cubit.checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Để MainScreen() rebuild theo ngôn ngữ mới

    _screens = [
      const JobsScreen(),
      const AppliedJobScreen(),
      const SavedJobScreen(),
      const AccountScreen()
    ];

    return Scaffold(
      body: Container(
        color: AppTheme.backgroundLight,
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: Container(
          margin: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.07,
          decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(50)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BottomNavItem(
                  index: _jobIndex,
                  icon: Icons.business_center,
                  label: 'bottom_nav.job'.tr(),
                  isSelected: _currentIndex == _jobIndex,
                  onTap: _handleBottomNavItemClick),
              BottomNavItem(
                  index: _appliedIndex,
                  icon: Icons.task_rounded,
                  label: 'bottom_nav.applied_job'.tr(),
                  isSelected: _currentIndex == _appliedIndex,
                  onTap: _handleBottomNavItemClick),
              BottomNavItem(
                  index: _savedIndex,
                  icon: Icons.bookmark_added_rounded,
                  label: 'bottom_nav.saved_job'.tr(),
                  isSelected: _currentIndex == _savedIndex,
                  onTap: _handleBottomNavItemClick),
              BottomNavItem(
                  index: _accountIndex,
                  icon: Icons.account_circle,
                  label: 'bottom_nav.account'.tr(),
                  isSelected: _currentIndex == _accountIndex,
                  onTap: _handleBottomNavItemClick),
            ],
          )),
    );
  }

  void _handleBottomNavItemClick(int index) {
    if (_currentIndex == index) return;

    if (index == _jobIndex) {
      setState(() {
        _currentIndex = index;
      });
      return;
    }

    if (_cubit.state is AuthNoLoggedInState) {
      context.goNamed(AppRouter.loginName);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }
}
