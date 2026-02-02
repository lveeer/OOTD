// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:ootd/core/network/dio_client.dart' as _i557;
import 'package:ootd/core/storage/secure_storage_helper.dart' as _i887;
import 'package:ootd/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i311;
import 'package:ootd/features/auth/data/datasources/auth_remote_datasource_mock.dart'
    as _i136;
import 'package:ootd/features/auth/data/repositories/auth_repository_impl.dart'
    as _i701;
import 'package:ootd/features/auth/domain/repositories/auth_repository.dart'
    as _i247;
import 'package:ootd/features/auth/domain/usecases/login_usecase.dart' as _i244;
import 'package:ootd/features/auth/domain/usecases/send_sms_code_usecase.dart'
    as _i784;

const String _mock = 'mock';
const String _prod = 'prod';
const String _dev = 'dev';

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
    gh.singleton<_i887.SecureStorageHelper>(() => _i887.SecureStorageHelper());
    gh.factory<_i311.AuthRemoteDataSource>(
      () => _i136.AuthRemoteDataSourceMock(),
      registerFor: {_mock},
    );
    gh.factory<_i247.AuthRepository>(() => _i701.AuthRepositoryImpl(
          remoteDataSource: gh<_i311.AuthRemoteDataSource>(),
          secureStorage: gh<_i887.SecureStorageHelper>(),
        ));
    gh.factory<_i557.DioClient>(() => _i557.DioClient(
          gh<String>(instanceName: 'baseUrl'),
          gh<String>(instanceName: 'authToken'),
        ));
    gh.factory<_i784.SendSmsCodeUseCase>(
        () => _i784.SendSmsCodeUseCase(gh<_i247.AuthRepository>()));
    gh.factory<_i244.LoginUseCase>(
        () => _i244.LoginUseCase(gh<_i247.AuthRepository>()));
    gh.factory<_i311.AuthRemoteDataSource>(
      () => _i311.AuthRemoteDataSourceImpl(dioClient: gh<_i557.DioClient>()),
      registerFor: {
        _prod,
        _dev,
      },
    );
    return this;
  }
}
