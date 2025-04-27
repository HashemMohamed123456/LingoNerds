import 'package:dio/dio.dart';
import '../../ApiManager/ApiManager.dart';
import '../../Domain/Repo/VoiceAnalysisRepo.dart';
class VoiceAnalysisRepoImpl implements VoiceAnalysisRepository {
  Future<Map<String, dynamic>> analyzeAudio(String filePath) async {
    ApiManager _apiManager = ApiManager();

    print("Sending file to API: $filePath"); // 🔹 Debug log

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(filePath, filename: "audio.mp3"),
    });

    try {
      final response = await _apiManager.post<Map<String, dynamic>>(
        "analyze-audio/",
        data: formData,
      );

      print("API Status Code: ${response.statusCode}");
      print("API Response Data: ${response.data}");
      return response.data ?? {};
    } catch (e) {
      if (e is DioException) {
        print("Dio Error Type: ${e.type}");
        print("Dio Error Message: ${e.message}");
        print("Dio Response Data: ${e.response?.data}");
      }
      print("API Request Error: $e");
      throw e;
    }
  }
}
