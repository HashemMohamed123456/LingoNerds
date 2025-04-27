
abstract class RecordState {}

class RecordInitial extends RecordState {}

class RecordLoading extends RecordState {}

class RecordingInProgress extends RecordState {
  String _filePath;
  RecordingInProgress(this._filePath);
}

class RecordingComplete extends RecordState {
  final String filePath;
  RecordingComplete({required this.filePath});
}

class RecordError extends RecordState {
  final String message;
  RecordError(this.message);
}
