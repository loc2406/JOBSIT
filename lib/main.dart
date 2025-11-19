import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobsit_mobile/app/router.dart';
import 'package:jobsit_mobile/app/theme.dart';
import 'package:jobsit_mobile/features/auth/cubit/candidate_cubit.dart';
import 'package:jobsit_mobile/features/jobs/cubit/job_cubit.dart';
import 'package:jobsit_mobile/features/saved_jobs/cubit/saved_job_cubit.dart';
import 'package:jobsit_mobile/data/datasources/shared_prefs.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';

import 'features/applied_jobs/cubit/applied_job_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SharedPrefs.initSharedPrefs();

  final localeCode = SharedPrefs.getLanguageCode();
  final locale = Locale(localeCode);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'assets/translations',
      startLocale: locale,
      fallbackLocale: const Locale('vi'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ValueConstants.initScreenSize(context);

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CandidateCubit()),
          BlocProvider(create: (context) => JobCubit()),
          BlocProvider(create: (context) => SavedJobCubit()),
          BlocProvider(create: (context) => AppliedJobCubit()),
        ],
        child: MaterialApp.router(
          routerConfig: AppRouter.router,
          title: 'app_name'.tr(),
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.light,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        ));
  }
}
