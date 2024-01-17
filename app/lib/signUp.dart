import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:app/game_screen.dart';
import '../functional.dart';


class signUp extends StatefulWidget {
  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signUp() async {
    print("startSignUp");
    String nickname = _nicknameController.text;
    String password = _passwordController.text;
    print("nickname: ${nickname}, password: ${password}");
    dynamic newId = await checkNewUser(nickname);
    print("${newId}");
    if (newId == false) {
      // 로그인 실패 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('중복되는 아이디입니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      dynamic result = await createUser(nickname, password);
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
        title: Text('회원가입'),
        centerTitle: true, // 제목을 가운데 정렬합니다.
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
              SizedBox(height: 10), // 간격 조절
              // 비밀번호 입력 필드
              TextField(
                controller: _passwordController,
                obscureText: true, // 비밀번호를 숨김 처리합니다.
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20), // 간격 조절
              // 회원가입하기 버튼
              ElevatedButton(
                onPressed: _signUp,
                child: Text('회원가입하기'),
              ),
            ],
          ),
      ),
    );
  }
}