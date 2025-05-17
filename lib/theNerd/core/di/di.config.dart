// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_tts/flutter_tts.dart' as _i50;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:lingonerds/theNerd/core/di/di.dart' as _i611;
import 'package:lingonerds/theNerd/geminiteacher/data/data_sources/chat_remote_data_source.dart'
    as _i386;
import 'package:lingonerds/theNerd/geminiteacher/data/data_sources/impl.dart'
    as _i60;
import 'package:lingonerds/theNerd/geminiteacher/data/repositories/chat_repo_impl.dart'
    as _i316;
import 'package:lingonerds/theNerd/geminiteacher/data/repositories/chatrepository.dart'
    as _i63;
import 'package:lingonerds/theNerd/geminiteacher/domain/use_cases/send_voice.dart'
    as _i829;

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
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i50.FlutterTts>(() => registerModule.tts);
    gh.factory<_i386.ChatRemoteDataSource>(
        () => _i60.ChatRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.factory<_i63.ChatRepository>(
        () => _i316.ChatRepositoryImpl(gh<_i386.ChatRemoteDataSource>()));
    gh.lazySingleton<_i829.SendVoiceInputUseCase>(
        () => _i829.SendVoiceInputUseCase(gh<_i63.ChatRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i611.RegisterModule {}
