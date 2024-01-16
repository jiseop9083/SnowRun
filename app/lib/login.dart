import 'package:app/signUp.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:app/game_screen.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              onPressed: () {
              // 로그인 로직 (여기서 입력 값을 사용)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameWidget(game: SnowManGame(tileSize: 64)),
                  ),
                );
              },
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
