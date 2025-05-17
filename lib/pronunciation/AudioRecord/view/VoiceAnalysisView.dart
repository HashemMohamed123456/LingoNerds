import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lingonerds/view/widgets/elevated_button_custom.dart';
import 'package:lingonerds/view/widgets/progress_indicator_widget.dart';

import '../../../core/themes/app_themes.dart';
import '../view_model/viewModel/cubits/VoiceCubit.dart';


class VoiceScreen extends StatefulWidget {
  static const String routeName = "voiceId";
  @override
  _VoiceScreenState createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    // Update state when playback completes
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() => isPlaying = false);
      }
    });
  }

  Future<void> _pickAndAnalyzeAudio(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null && result.files.single.path != null) {
      String filePath = result.files.single.path!;
      print("Selected filePath: $filePath");
      context.read<VoiceCubit>().analyzeVoice(filePath);
    }
  }
  Future<void> _playAudio(String url) async {
    if (url.isEmpty) {
      print("Error: Audio URL is empty");
      return;
    }

    try {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
      // No need to call setState here!
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    // No need to call setState here!
  }


  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/scaffold.png'))
      ),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent,title:  Text("Voice Transcriber",style: AppThemes.lightTheme.textTheme.labelLarge,)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocConsumer<VoiceCubit, VoiceState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is VoiceLoading) {
                    return ProgressIndicatorClass.constructProgressIndicator();
                  } else if (state is VoiceSuccess) {
                    String audioUrl = state.response['audio_feedback_url'].trim();
                    print("Trying to play audio from: $audioUrl");

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Text("Your Phrase: ${state.response['original_text']}",style:AppThemes.lightTheme.textTheme.titleMedium ,),
                            Padding(
                      padding: EdgeInsets.only(top: 50),
                                child: Text("Fixed Phrase  ${state.response['corrected_text']}",style: AppThemes.lightTheme.textTheme.titleMedium,)
                            ),
                             SizedBox(height: 50.h),
                            StreamBuilder<PlayerState>(
                              stream: _audioPlayer.playerStateStream,
                              builder: (context, snapshot) {
                                final playerState = snapshot.data;
                                final playing = playerState?.playing ?? false;

                                return ElevatedButtonCustom(
                                  onPressed: () {
                                    if (playing) {
                                      _stopAudio(); // If already playing => stop it
                                    } else {
                                      _playAudio(audioUrl); // If not playing => start playing
                                    }
                                  },
                                  buttonLabel: playing ? "Reset" : "Play Corrected Audio",
                                );
                              },
                            ),



                          ],
                        ),
                      ),
                    );
                  } else if (state is VoiceError) {
                    return Text("Error: ${state.message}", style: TextStyle(color: Colors.red));
                  } else {
                    return Column(
                      children: [
                        Image.asset('assets/icons/feedback.png',height: 400.h,width: 400.w,),
                        SizedBox(height: 25.h,),
                        ElevatedButtonCustom(
                          onPressed: () => _pickAndAnalyzeAudio(context),
                          buttonLabel: "Select & Analyze Audio"
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
