import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobsit_mobile/app/router.dart';
import 'package:jobsit_mobile/app/theme.dart';
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_cubit.dart';
import 'package:jobsit_mobile/features/jobs/presentation/cubit/job_cubit.dart';
import 'package:jobsit_mobile/features/saved_jobs/presentation/cubit/saved_job_cubit.dart';
import 'package:jobsit_mobile/data/datasources/shared_prefs.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';
import 'package:jobsit_mobile/injection_container.dart';

import 'features/applied_jobs/presentation/cubit/applied_job_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SharedPrefs.initSharedPrefs();

  final localeCode = SharedPrefs.getLanguageCode();
  final locale = Locale(localeCode);

  configureDependencies();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
          BlocProvider(create: (context) => getIt<CandidateCubit>()),
          BlocProvider(create: (context) => JobCubit()),
          BlocProvider(create: (context) => SavedJobCubit()),
          BlocProvider(create: (context) => AppliedJobCubit()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(414, 896),
          minTextAdapt: true,
          splitScreenMode: true,
          child: MaterialApp.router(
            builder: (context, child) {
              final mediaQueryData = MediaQuery.of(context);

              final scale = mediaQueryData.textScaler
                  .clamp(minScaleFactor: 1.0, maxScaleFactor: 1.1);

              return MediaQuery(
                data: mediaQueryData.copyWith(textScaler: scale),
                child: child!,
              );
            },
            routerConfig: AppRouter.router,
            title: 'app_name'.tr(),
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.light,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          ),
        ));
  }
}
