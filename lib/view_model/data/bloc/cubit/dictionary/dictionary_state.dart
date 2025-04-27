part of 'dictionary_cubit.dart';

@immutable
abstract class DictionaryState {}

class DictionaryInitial extends DictionaryState {}
class DictionaryDefinitionLoadingState extends DictionaryState{}
class DictionaryDefinitionLoadingSuccessState extends DictionaryState{
  final List<String> definitions;
  DictionaryDefinitionLoadingSuccessState({required this.definitions,});
}
class DictionaryDefinitionLoadingErrorState extends DictionaryState{
  final String message;
  DictionaryDefinitionLoadingErrorState({required this.message});
}
class AudioPlayerInitialState extends DictionaryState{}
class AudioPlayerPlayState extends DictionaryState{}
class AudioPlayerStopState extends DictionaryState{}
class PlayingAudioLoadingState extends DictionaryState{}
class PlayingAudioErrorState extends DictionaryState{
  final String message;
  PlayingAudioErrorState({required this.message});
}