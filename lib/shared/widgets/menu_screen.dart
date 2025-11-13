import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsit_mobile/features/auth/cubit/candidate_cubit.dart';
import 'package:jobsit_mobile/features/applied_jobs/screens/applied_job_screen.dart';
import 'package:jobsit_mobile/features/auth/cubit/candidate_state.dart';
import 'package:jobsit_mobile/features/jobs/screens/home_screen.dart';
import 'package:jobsit_mobile/features/saved_jobs/screens/saved_job_screen.dart';
import 'package:jobsit_mobile/core/constants/asset_constants.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/core/constants/text_constants.dart';

import '../../features/auth/screens/account_screen.dart';
import '../../features/auth/screens/login_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentIndex = 0;
  late final CandidateCubit _cubit;

  List<Widget> screens = [
    const HomeScreen(),
    const AppliedJobScreen(),
    const SavedJobScreen(),
    const AccountScreen()
  ];

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CandidateCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorConstants.grayBackground,
        child: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: TextConstants.home),
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_repair_service_outlined),
              label: TextConstants.applied),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetConstants.iconBookmark, width: 24, height: 24, colorFilter: ColorFilter.mode(_currentIndex == 2 ? ColorConstants.main : Colors.black, BlendMode.srcIn),),
              label: TextConstants.saved),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetConstants.iconProfile, width: 24, height: 24, colorFilter: ColorFilter.mode(_currentIndex == 3 ? ColorConstants.main : Colors.black, BlendMode.srcIn),),
              label: TextConstants.profile),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {

          if(_cubit.state is AuthNoLoggedInState){
            if (index >0 && _currentIndex != index){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
            }
          }

          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: ColorConstants.main,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
