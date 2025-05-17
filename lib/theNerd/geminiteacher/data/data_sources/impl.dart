import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

import '../../../core/constants.dart';
import '../../domain/entities/chat_response.dart';
import 'chat_remote_data_source.dart';

@Injectable(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;
  late final GenerativeModel _model;
  
  ChatRemoteDataSourceImpl(this.dio) {

    if (apiKey.isEmpty) {
      final errorMessage = "FATAL ERROR: Gemini API Key is empty in ChatRemoteDataSourceImpl.";
      print(errorMessage);
      throw Exception(errorMessage);
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 1024,
      ),
      systemInstruction: Content.text(
        "You are an expert English language tutor. The user will provide text that represents their spoken English. Your tasks are:\n"
        "1. Identify and correct any grammatical errors in the user's recorder audio.\n"
        "2. Provide clear explanations for the corrections.\n"
        "3. If the text suggests unclear pronunciation (e.g., commonly confused words, awkward phrasing that might stem from pronunciation issues), offer polite feedback and tips for clearer articulation of those specific phrases or words. Focus on what can be inferred from text. Do not attempt to assess audio directly.\n"
        "4. Maintain an encouraging and supportive tone.\n"
        "5. Keep your responses concise and focused on the language feedback."
        "6. Ignore the Capitalization and the commas errors as you are judging a voice input"
        "7.And Your Name when someone asks u is  Lingo Nerd"
      ),
    );
  }

  @override
  Future<ChatResponse> sendMessage(String inputText) async {
    if (inputText.trim().isEmpty) {
      return ChatResponse(reply: "Please say something!", correction: null);
    }
    
    try {
      final content = [Content.text(inputText)];
      final response = await _model.generateContent(content).timeout(const Duration(seconds: 30));
      
      if (response.text == null || response.text!.isEmpty) {
        print("Gemini API returned an empty response. Check safety filters or prompt.");
        if (response.promptFeedback != null) {
          print("Prompt Feedback from API: ${response.promptFeedback}");
          if (response.promptFeedback!.blockReason != null) {
            throw Exception('Request blocked by API: ${response.promptFeedback!.blockReason!.name}. Message: ${response.promptFeedback!.blockReasonMessage ?? "No specific message."}');
          }
        }
        throw Exception('No response text from Gemini API and no explicit block reason found.');
      }

      return ChatResponse(
        reply: response.text!,
        correction: null, 
      );
    } on GenerativeAIException catch (e) {
      print('GenerativeAIException in ChatRemoteDataSourceImpl: ${e.message}');
      throw Exception('Gemini API Error: ${e.message}'); 
    } catch (e) {
      print('Generic error in ChatRemoteDataSourceImpl sendMessage: $e');
      throw Exception('Error processing Gemini API request: $e');
    }
  }
}
