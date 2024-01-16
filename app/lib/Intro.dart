import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flame/game.dart';
import 'package:app/game_screen.dart';

class GameIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Flare 애니메이션
              Text(
                'Snowrun',
                style: TextStyle(
                    color: Colors.white, fontSize: 48, fontFamily: 'main'),
              ),
              Container(
                height: 200,
                width: 200,
                child: Lottie.asset(
                  'assets/lottie/main_intro.json', // Lottie 파일 경로
                  repeat: true, // 애니메이션 반복 여부
                  animate: true, // 애니메이션 시작 여부
                ),
              ),
              SizedBox(height: 20),
              // 게임 로고 또는 텍스트
              // Start 버튼
              // ElevatedButton(
              //   onPressed: () {
              //     // Start 버튼 누를 때 다른 화면으로 이동
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) =>
              //               GameWidget(game: SnowManGame(tileSize: 64))),
              //     );
              //   },
              //   child: Text(
              //     'Start',
              //     style: TextStyle(
              //         color: Colors.yellow, fontSize: 24, fontFamily: 'main'),
              //   ),
              // ),
              ElevatedButton(
                onPressed: () {
                  // '로그인' 버튼 누를 때 로그인 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Text(
                  '로그인',
                  style: TextStyle(color: Colors.yellow, fontSize: 20, fontFamily: 'main'),
                ),
              ),
              SizedBox(height: 20), // 버튼 사이의 간격
              ElevatedButton(
                onPressed: () {
                  // '시작하기' 버튼 누를 때 게임 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(

                        builder: (context) =>
                            GameWidget(game: SnowManGame(tileSize: 64))),

                  );
                },
                child: Text(
                  '시작하기',
                  style: TextStyle(color: Colors.yellow, fontSize: 20, fontFamily: 'main'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
