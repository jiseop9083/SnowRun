
import 'package:app/signUp.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:app/game_screen.dart';
import '../functional.dart';



// class Login extends StatefulWidget {
//   @override
//   _LoginState createState() => _LoginState();
// }


class _LoginState extends State<Login> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>(); // 스낵바를 위한 키

  void _login() async {
    String nickname = _nicknameController.text;
    String password = _passwordController.text;

    dynamic result = await loginUser(nickname, password);

    if (result == false) {
      // 로그인 실패 메시지 표시
      print("snackbar");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('존재하지 않는 아이디 혹은 비번입니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      print("no snackbar");
      // user_index를 SharedPreferences에 저장
      await saveUserIndex(result);

      // 로그인 성공 시 GameWidget으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameWidget(game: SnowManGame(tileSize: 64)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 닉네임 입력 필드
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: '닉네임',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10), // 간격
            // 비밀번호 입력 필드
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20), // 간격
            // 로그인 버튼
            ElevatedButton(
              onPressed: _login,
              child: Text('로그인'),
            ),
            SizedBox(height: 10), // 간격
            // 회원가입 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => signUp(),
                  ),
                );
              },
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}


