import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lingonerds/pronunciation/AudioRecord/view_model/audio_player_viewModel/audio_player_cubit.dart';
import 'package:lingonerds/pronunciation/AudioRecord/view_model/record_cubit.dart';
import '../../../../core/themes/app_themes.dart';
import '../../../Domain/Model/PostModel.dart';
import '../../view_model/fluentme_viewModel/fluentMe_cubit.dart';
import '../fluentMe_Screen.dart';

class RecordScreen extends StatelessWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Post post;

  RecordScreen({required this.post, super.key});

  static const routeName = 'RecordScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pronunciation Practice',
          style: AppThemes.lightTheme.textTheme.labelLarge,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            context.read<FluentMeCubit>().resetPronunciationScreen();
            context.read<RecordCubit>().resetRecord();
            context.read<AudioPlayerCubit>().stopAudio();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/scaffold.png',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pronounce this:',
                  style: GoogleFonts.anton(
                    color: AppThemes.yellowAppColor,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  post.postContent,
                  style: GoogleFonts.anton(
                    color: AppThemes.blueAppColor,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: FluentMeScreen(postId: post.postId),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
