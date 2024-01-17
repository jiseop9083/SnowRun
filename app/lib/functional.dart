import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// API의 URL. 실제 URL로 대체해야 합니다.
const String apiUrl = "http://172.10.7.69:80";

Future<bool> checkNewUser(String nickname) async {
  final response =
      await http.get(Uri.parse('$apiUrl/new_user/?user_id=$nickname'));
  return json.decode(response.body);
}

Future<int> createUser(String nickname, String password) async {
  final response = await http.post(
    Uri.parse('$apiUrl/users/'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'user_id': nickname, 'password': password}),
  );
  // HTTP 요청이 성공적으로 처리되었습니다.
  var data = json.decode(response.body);
  return data['user_index'];
}

Future<dynamic> loginUser(String nickname, String password) async {
  final response = await http.get(
    Uri.parse('$apiUrl/login/?user_id=$nickname&password=$password'),
  );
  var data = json.decode(response.body);
  if (data == false) {
    return false;
  } else {
    return data['user_index'];
  }
}

Future<void> saveUserIndex(int userIndex) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('userIndex', userIndex);
}

Future<int?> getUserIndex() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userIndex');
}

Future<Map<String, dynamic>> updateScore(int userIndex, int score) async {
  final response = await http.get(
    Uri.parse('$apiUrl/update-score/?user_index=$userIndex&score=$score'),
  );
  return json.decode(response.body);
}

Future<List<dynamic>> getScores() async {
  final response = await http.get(Uri.parse('$apiUrl/get-scores/'));
  // 서버로부터 정상적인 응답을 받았을 때
  List<dynamic> scores = json.decode(response.body);
  return scores;
}
