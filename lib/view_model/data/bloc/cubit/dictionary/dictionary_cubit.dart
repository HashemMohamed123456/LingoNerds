import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingonerds/model/dictionary/dictionary_model.dart';
import 'package:meta/meta.dart';
part 'dictionary_state.dart';
class DictionaryCubit extends Cubit<DictionaryState> {
  DictionaryCubit() : super(DictionaryInitial());
  static DictionaryCubit get(context)=>BlocProvider.of<DictionaryCubit>(context);
  final Dio dio=Dio();
  final AudioPlayer audioPlayer = AudioPlayer();
  List<String>? lastDefinitions;
  String? lastWord;
  String? currentAudioUrl;
  TextEditingController dictionaryController=TextEditingController();
  Future<void> fetchDefinitions(String word) async {
    emit(DictionaryDefinitionLoadingState());
    try {
      final response = await dio.get(
        'https://api.dictionaryapi.dev/api/v2/entries/en/$word',
      );
      if (response.statusCode == 200) {
        try {
          final dictionaryModel = DictionaryModel.fromJson(response.data);
          final definitions = extractDefinitions(dictionaryModel);
          if (definitions.isEmpty) {
            emit(DictionaryDefinitionLoadingErrorState(message: 'No definitions found'));
          } else {
            lastDefinitions = definitions;
            lastWord = word;
            emit(DictionaryDefinitionLoadingSuccessState(definitions: definitions,));
          }
        } catch (e) {
          emit(DictionaryDefinitionLoadingErrorState(message:'Failed to parse definitions: ${e.toString()}'));
        }
      } else {
        emit(DictionaryDefinitionLoadingErrorState(message:'Word not found (${response.statusCode})'));
      }
    } on DioException catch (e) {
      emit(DictionaryDefinitionLoadingErrorState(message:'Network error: ${e.message}'));
    } catch (e) {
      emit(DictionaryDefinitionLoadingErrorState(message:'Unexpected error: ${e.toString()}'));
    }
  }

  List<String> extractDefinitions(DictionaryModel model) {
    final definitions = <String>[];

    for (final entry in model.entries) {
      for (final meaning in entry.meanings) {
        for (final definition in meaning.definitions) {
          // Only add non-empty definitions
          if (definition.definition.trim().isNotEmpty) {
            definitions.add(definition.definition);
          }
        }
      }
    }
    return definitions;
  }
  Future<void> refreshDefinitions() async {
    dictionaryController.clear();
    lastDefinitions = null;
    lastWord = null;
    emit(DictionaryInitial());
  }
  String? getFirstAudioUrl(DictionaryModel model) {
    for (final entry in model.entries) {
      for (final phonetic in entry.phonetics) {
        if (phonetic.audio.isNotEmpty) {
          return phonetic.audio;
        }
      }
    }
    return null;
  }
  Future<void>playAudioForWord({required String word})async{
    emit(PlayingAudioLoadingState());
    try{
      final response=await dio.get('https://api.dictionaryapi.dev/api/v2/entries/en/$word');
      if(response.statusCode==200){
        final dictionaryModel=DictionaryModel.fromJson(response.data);
        final audioUrl=getFirstAudioUrl(dictionaryModel);
        if(audioUrl!=null){
          await audioPlayer.play(UrlSource(getFirstAudioUrl(dictionaryModel)!));
          emit(AudioPlayerPlayState());
        }else{
          emit(PlayingAudioErrorState(message: 'No Audio Available for this word'));
        }
      }else{
        emit(PlayingAudioErrorState(message: 'Failed to fetch Audio'));
      }
    }catch(e){
      emit(PlayingAudioErrorState(message: "Failed to Play Audio: ${e.toString()}"));
    }
  }
}