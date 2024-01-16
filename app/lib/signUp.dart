import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:app/game_screen.dart';


class signUp extends StatefulWidget {
  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                onPressed: () {
                // 회원가입 로직을 여기에 추가합니다. (예: 서버에 데이터 전송)
                // 여기서는 예시로 바로 게임 위젯으로 이동합니다.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameWidget(game: SnowManGame(tileSize: 64)),
                    ),
                  );
                },
                child: TextField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    labelText: '회원가입하기',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}