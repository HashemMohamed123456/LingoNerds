import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/themes/app_themes.dart';
import '../../../view/widgets/elevated_button_custom.dart';
import '../../../view/widgets/progress_indicator_widget.dart';
import '../view_model/audio_player_viewModel/audio_player_cubit.dart';
import '../view_model/audio_player_viewModel/audio_player_states.dart';
import '../view_model/fluentme_viewModel/fluentMe_cubit.dart';
import '../view_model/fluentme_viewModel/fluentMe_states.dart';
import '../view_model/record_cubit.dart';
import 'package:flutter/material.dart';

import '../view_model/record_states.dart';
class FluentMeScreenBody extends StatefulWidget {
  final String postId;
  final AudioPlayer _audioPlayer = AudioPlayer();

  FluentMeScreenBody({super.key, required this.postId});

  @override
  State<FluentMeScreenBody> createState() => _FluentMeScreenBodyState();
}

class _FluentMeScreenBodyState extends State<FluentMeScreenBody> {
  @override
  void dispose() {
    widget._audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordCubit, RecordState>(
      builder: (context, recordState) {
        // Recording in progress UI
        if (recordState is RecordingInProgress) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Recording your pronunciation...",
                    style: GoogleFonts.anton(
                        color: AppThemes.blueAppColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(
                    width: 60,
                    height: 60,
                    child: ProgressIndicatorClass.constructProgressIndicator()),
                const SizedBox(height: 20),
                ElevatedButtonCustom(
                  onPressed: () => context.read<RecordCubit>().stopRecording(),
                  buttonLabel: "Stop Recording",
                )
              ],
            ),
          );
        }
        // Recording completed UI
        else if (recordState is RecordingComplete) {
          return BlocConsumer<FluentMeCubit, FluentMeState>(
            listener: (context, state) {
              if (state is FluentMeError) {
                print("Error message in fluentMe Error is : ${state.message}");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is FluentMeInitial) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Recording complete!',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 20),
                      ElevatedButtonCustom(
                        onPressed: () {
                          context.read<FluentMeCubit>().scoreRecording(
                            audioFilePath: recordState.filePath,
                            postId: widget.postId,
                            scale: 90,
                          );
                        },
                        buttonLabel: "Analyze Pronunciation",
                      ),
                      const SizedBox(height: 20),
                      ElevatedButtonCustom(
                        onPressed: () =>
                            context.read<RecordCubit>().startRecording(),
                        buttonLabel: "Record Again",
                      ),
                    ],
                  ),
                );
              }
              // Loading state while API processes the recording
              else if (state is FluentMeLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProgressIndicatorClass.constructProgressIndicator(),
                      const SizedBox(height: 20),
                      Text('Analyzing your pronunciation...',style: GoogleFonts.anton(fontSize: 20,color: AppThemes.blueAppColor),),
                    ],
                  ),
                );
              }
              // Success state showing the pronunciation score
              else if (state is FluentMeSuccess) {
                final result = state.response;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Score: ${result.overallResultData.overallPoints.toStringAsFixed(1)}/90',
                        style: AppThemes.lightTheme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your transcript:',
                        style: GoogleFonts.anton(color: AppThemes.yellowAppColor,fontSize: 25),
                      ),
                      Text(result.overallResultData.userRecordingTranscript,style: GoogleFonts.anton(color: AppThemes.blueAppColor,fontSize: 20),),
                      const SizedBox(height: 16),
                      Text(
                        'Words recognized: ${result.overallResultData.numberOfRecognizedWords}/${result.overallResultData.numberOfWordsInPost}',
                        style: GoogleFonts.anton(color: Colors.white,fontSize: 20),
                      ),
                      const SizedBox(height: 16),

                      // Audio playback controls
                      BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
                        builder: (context, playerState) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 170.w,
                                child: ElevatedButtonCustom(
                                  onPressed: () async {
                                    try {
                                      await context
                                          .read<AudioPlayerCubit>()
                                          .toggleAudio(recordState.filePath);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Playback failed: $e')),
                                      );
                                    }
                                  },
                                  buttonLabel: playerState is AudioPlayerPlaying
                                      ? "Pause"
                                      : "Play Recording",
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (playerState is AudioPlayerPlaying ||
                                  playerState is AudioPlayerPaused)
                                Container(
                                  width: 150.w,
                                  child: ElevatedButtonCustom(
                                    onPressed: () => context
                                        .read<AudioPlayerCubit>()
                                        .stopAudio(),
                                    buttonLabel: "Stop",
                                  ),
                                ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 16),
                      Text(
                        'Word-by-word analysis:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: result.wordResultData.length,
                        itemBuilder: (context, index) {
                          final word = result.wordResultData[index];
                          return Card(
                            color: AppThemes.blueAppColor,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(word.word,style:GoogleFonts.anton(color: Colors.white,fontSize: 15.sp),),
                              subtitle: Text('Speed: ${word.speed}',style: GoogleFonts.anton(color: Colors.white,fontSize: 12.sp),),
                              trailing: Text(
                                '${word.points.toStringAsFixed(1)}',
                                style: GoogleFonts.anton(
                                  color: word.points > 70
                                      ? Colors.green
                                      : word.points > 40
                                      ? Colors.orange
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButtonCustom(
                        onPressed: () async {
                          // Play AI reading from the result
                          try {
                            await widget._audioPlayer
                                .setUrl(result.overallResultData.aiReading);
                            await widget._audioPlayer.play();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Playback failed: $e')),
                            );
                          }
                        },
                        buttonLabel:'Play AI Reading',
                      ),
                      const SizedBox(height: 16),
                      ElevatedButtonCustom(
                        onPressed: () {
                          context.read<FluentMeCubit>().resetPronunciationScreen();
                          context.read<RecordCubit>().resetRecord();
                          context.read<AudioPlayerCubit>().stopAudio();
                          context.read<RecordCubit>().startRecording();
                          },
                        buttonLabel: "Record Again",
                      ),
                    ],
                  ),
                );
              } else if (state is FluentMeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 64),
                      const SizedBox(height: 10),
                      Text("Error: ${state.message}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.red)),
                      const SizedBox(height: 20),
                      ElevatedButtonCustom(
                        onPressed: () {
                          context.read<FluentMeCubit>().resetPronunciationScreen();
                          context.read<RecordCubit>().startRecording();
                        },
                        buttonLabel: "Try Again",
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    'An error occurred',
                    style: GoogleFonts.anton(color: Colors.red, fontSize: 20),
                  ),
                );
              }
            },
          );
        }
        // Error state
        else if (recordState is RecordError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 64),
                const SizedBox(height: 10),
                Text("Error: ${recordState.message}",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.red)),
                const SizedBox(height: 20),
                ElevatedButtonCustom(
                  onPressed: () => context.read<RecordCubit>().startRecording(),
                  buttonLabel: "Try Again",
                ),
              ],
            ),
          );
        }
        // Initial state - Ready to record
        else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mic, size: 70, color: AppThemes.blueAppColor),
                const SizedBox(height: 20),
                Text("Ready to record your pronunciation",
                    style: AppThemes.lightTheme.textTheme.titleMedium),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Press the button below to start recording, then speak clearly into your microphone.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.anton(
                        color: AppThemes.blueAppColor, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButtonCustom(
                  onPressed: () => context.read<RecordCubit>().startRecording(),
                  buttonLabel: "Start Recording",
                ),
              ],
            ),
          );
        }
      },
    );
  }
}