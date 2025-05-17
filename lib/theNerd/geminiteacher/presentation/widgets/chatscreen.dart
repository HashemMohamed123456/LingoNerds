import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

import '../manager/chatcubit.dart';
import '../manager/chatstate.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    await _speech.initialize(
      onStatus: (status) {
        debugPrint('Speech recognition status: $status');
        if (status == 'done' && _lastWords.isNotEmpty) {
          final cubit = context.read<ChatCubit>();
          cubit.sendVoiceMessage(_lastWords);
          setState(() {
            _isListening = false;
            _lastWords = '';
          });
        }
      },
      onError: (error) => debugPrint('Speech recognition error: $error'),
    );
  }

  Future<void> _startListening() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      try {
        if (await _speech.initialize()) {
          setState(() => _isListening = true);
          await _speech.listen(
            onResult: (result) {
              setState(() {
                _lastWords = result.recognizedWords;
              });
            },
          );
        }
      } catch (e) {
        debugPrint('Error starting speech recognition: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error starting speech recognition')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission denied')),
      );
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("The Nerd Chatbot"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_lastWords.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Recognized: $_lastWords',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ChatSuccess) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "The Nerd's Response:",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.response.reply,
                              style: const TextStyle(fontSize: 16),
                            ),
                            if (state.response.correction != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                "Correction:",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.response.correction!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is ChatError) {
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const Center(
                    child: Text(
                      "Tap the microphone to start speaking",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isListening ? _stopListening : _startListening,
        tooltip: _isListening ? 'Stop Listening' : 'Start Listening',
        child: Icon(_isListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
