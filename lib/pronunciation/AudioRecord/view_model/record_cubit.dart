import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingonerds/pronunciation/AudioRecord/view_model/record_states.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/record_service.dart';

class RecordCubit extends Cubit<RecordState> {
  final RecordService _service;
  String? _filePath;

  RecordCubit(this._service) : super(RecordInitial());
void resetRecord(){
  emit(RecordInitial());
}
  Future<void> requestPermissions() async {
    final status = await [
      Permission.microphone,
      Permission.storage,
    ].request();

    if (status[Permission.microphone] != PermissionStatus.granted ||
        status[Permission.storage] != PermissionStatus.granted) {
      emit(RecordError("Permissions not granted."));
    }
  }

  void startRecording() async {
    await requestPermissions();
    emit(RecordLoading());
    _filePath = null; // ✅ Clear previous path
    final path = await _service.startRecording();
    if (path != null) {
      _filePath = path;
      emit(RecordingInProgress(_filePath!));
    } else {
      emit(RecordError("Permission denied or failed to start."));
    }
  }

  void stopRecording() async {
    final path = await _service.stopRecording();
    if (path != null) {
      _filePath = path;
      emit(RecordingComplete(filePath: _filePath!));
    } else {
      emit(RecordError("Failed to stop recording."));
    }
  }

  String? get recordedFilePath => _filePath;
}
