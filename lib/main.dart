import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobsit_mobile/features/auth/cubit/candidate_cubit.dart';
import 'package:jobsit_mobile/features/jobs/cubit/job_cubit.dart';
import 'package:jobsit_mobile/features/saved_jobs/cubit/saved_job_cubit.dart';
import 'package:jobsit_mobile/features/auth/screens/login_screen.dart';
import 'package:jobsit_mobile/shared/widgets/menu_screen.dart';
import 'package:jobsit_mobile/splash_screen.dart';
import 'package:jobsit_mobile/core/services/candidate_services.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/data/datasources/shared_prefs.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'features/applied_jobs/cubit/applied_job_cubit.dart';
import 'data/models/candidate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.initSharedPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ValueConstants.initScreenSize(context);

    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => CandidateCubit()),
      BlocProvider(create: (context) => JobCubit()),
      BlocProvider(create: (context) => SavedJobCubit()),
      BlocProvider(create: (context) => AppliedJobCubit()),
    ], child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorConstants.grayBackground),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    ));
  }
}

class MainScreen extends StatefulWidget {
   const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => MainStateScreen();
}

class MainStateScreen extends State<MainScreen> {
  late final CandidateCubit _cubit;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CandidateCubit>();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? token = await SharedPrefs.getCandidateToken();
    if (token != null && token.isNotEmpty) {
      bool isExpired = JwtDecoder.isExpired(token);
      int? id = await SharedPrefs.getCandidateId();

      if (!isExpired && id != null) {
        Candidate candidate = await CandidateServices.getCandidateById(id);
        _cubit.setLoginStatus(status: true, token: token, candidate: candidate);
      } else {
        _cubit.setLoginStatus(status: false);
      }
    } else {
      _cubit.setLoginStatus(status: false);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : const MenuScreen();
  }
}

