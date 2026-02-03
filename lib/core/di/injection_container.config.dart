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
import 'package:ootd/features/message/data/datasources/message_local_datasource.dart'
    as _i499;
import 'package:ootd/features/message/data/repositories/message_repository_impl.dart'
    as _i683;
import 'package:ootd/features/message/domain/repositories/message_repository.dart'
    as _i27;
import 'package:ootd/features/message/domain/usecases/get_conversations.dart'
    as _i479;
import 'package:ootd/features/message/domain/usecases/get_messages.dart'
    as _i439;
import 'package:ootd/features/message/domain/usecases/get_notifications.dart'
    as _i328;
import 'package:ootd/features/message/domain/usecases/mark_as_read.dart'
    as _i1043;
import 'package:ootd/features/message/domain/usecases/mark_messages_as_read.dart'
    as _i781;
import 'package:ootd/features/message/domain/usecases/mark_notification_as_read.dart'
    as _i1061;
import 'package:ootd/features/message/domain/usecases/send_message.dart'
    as _i707;
import 'package:ootd/features/message/presentation/blocs/chat_bloc.dart'
    as _i285;

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
    gh.factory<_i499.MessageLocalDataSource>(
        () => _i499.MessageLocalDataSourceImpl());
    gh.factory<_i27.MessageRepository>(() => _i683.MessageRepositoryImpl(
        localDataSource: gh<_i499.MessageLocalDataSource>()));
    gh.factory<_i311.AuthRemoteDataSource>(
      () => _i136.AuthRemoteDataSourceMock(),
      registerFor: {_mock},
    );
    gh.factory<_i247.AuthRepository>(() => _i701.AuthRepositoryImpl(
          remoteDataSource: gh<_i311.AuthRemoteDataSource>(),
          secureStorage: gh<_i887.SecureStorageHelper>(),
        ));
    gh.factory<_i1061.MarkNotificationAsRead>(
        () => _i1061.MarkNotificationAsRead(gh<_i27.MessageRepository>()));
    gh.factory<_i439.GetMessages>(
        () => _i439.GetMessages(gh<_i27.MessageRepository>()));
    gh.factory<_i781.MarkMessagesAsRead>(
        () => _i781.MarkMessagesAsRead(gh<_i27.MessageRepository>()));
    gh.factory<_i707.SendMessage>(
        () => _i707.SendMessage(gh<_i27.MessageRepository>()));
    gh.factory<_i479.GetConversations>(
        () => _i479.GetConversations(gh<_i27.MessageRepository>()));
    gh.factory<_i328.GetNotifications>(
        () => _i328.GetNotifications(gh<_i27.MessageRepository>()));
    gh.factory<_i1043.MarkAsRead>(
        () => _i1043.MarkAsRead(gh<_i27.MessageRepository>()));
    gh.factory<_i557.DioClient>(() => _i557.DioClient(
          gh<String>(instanceName: 'baseUrl'),
          gh<String>(instanceName: 'authToken'),
        ));
    gh.factory<_i285.ChatBloc>(() => _i285.ChatBloc(
          getMessages: gh<_i439.GetMessages>(),
          sendMessage: gh<_i707.SendMessage>(),
          markMessagesAsRead: gh<_i781.MarkMessagesAsRead>(),
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
