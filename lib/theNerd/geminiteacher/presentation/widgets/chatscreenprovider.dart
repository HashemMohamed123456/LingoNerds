
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../core/di/di.dart';
import '../../domain/use_cases/send_voice.dart';
import '../manager/chatcubit.dart';
import 'chatscreen.dart';

class ChatScreenProvider extends StatelessWidget {
  const ChatScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final sendVoiceInputUseCase = getIt<SendVoiceInputUseCase>();
    final flutterTts = getIt<FlutterTts>();
    return BlocProvider(
      create: (_) => ChatCubit(sendVoiceInputUseCase, flutterTts),
      child: ChatScreen(),
    );
  }
}
