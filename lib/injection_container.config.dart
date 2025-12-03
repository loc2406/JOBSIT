// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:jobsit_mobile/core/network/dio_client.dart' as _i648;
import 'package:jobsit_mobile/core/network/network_info.dart' as _i352;
import 'package:jobsit_mobile/core/network/network_module.dart' as _i683;
import 'package:jobsit_mobile/features/auth/data/data_sources/auth_data_source.dart'
    as _i314;
import 'package:jobsit_mobile/features/auth/data/repositories/auth_repository_impl.dart'
    as _i642;
import 'package:jobsit_mobile/features/auth/domain/repositories/auth_repository.dart'
    as _i409;
import 'package:jobsit_mobile/features/auth/domain/use_cases/login_use_case.dart'
    as _i428;
import 'package:jobsit_mobile/features/auth/domain/use_cases/register_use_case.dart'
    as _i252;
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_cubit.dart'
    as _i451;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio);
    gh.lazySingleton<_i161.InternetConnection>(
        () => networkModule.internetConnection);
    gh.lazySingleton<_i352.NetworkInfo>(
        () => _i352.NetworkInfoImpl(gh<_i161.InternetConnection>()));
    gh.lazySingleton<_i648.DioClient>(() => _i648.DioClient(
          gh<_i361.Dio>(),
          gh<_i352.NetworkInfo>(),
        ));
    gh.lazySingleton<_i314.AuthDataSource>(
        () => _i314.AuthDataSourceImpl(gh<_i648.DioClient>()));
    gh.lazySingleton<_i409.AuthRepository>(
        () => _i642.AuthRepositoryImpl(dataSource: gh<_i314.AuthDataSource>()));
    gh.lazySingleton<_i428.LoginUseCase>(
        () => _i428.LoginUseCase(gh<_i409.AuthRepository>()));
    gh.lazySingleton<_i252.RegisterUseCase>(
        () => _i252.RegisterUseCase(gh<_i409.AuthRepository>()));
    gh.factory<_i451.CandidateCubit>(() => _i451.CandidateCubit(
          loginUseCase: gh<_i428.LoginUseCase>(),
          registerUseCase: gh<_i252.RegisterUseCase>(),
        ));
    return this;
  }
}

class _$NetworkModule extends _i683.NetworkModule {}
