import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flame/game.dart';
import 'package:app/game_screen.dart';
import '../login.dart';

class GameIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/BG_intro2.png'),
                fit: BoxFit.cover, // You can adjust the fit as needed
                alignment: Alignment(0, 0.5),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 280,  // 너비를 원하는 크기로 설정하세요.
                    height: 280, // 높이를 원하는 크기로 설정하세요.
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/intro_logo.png'), // 이미지 경로를 정확히 지정하세요.
                        fit: BoxFit.contain, // BoxFit에 따라 이미지의 채우기 방식을 조절하세요.
                      ),
                    ),
                  ),

                  // // Flare 애니메이션
                  // Text(
                  //   'Snowrun',
                  //   style: TextStyle(
                  //       color: Colors.white, fontSize: 48, fontFamily: 'main'),
                  // ),
                  // Container(
                  //   height: 200,
                  //   width: 200,
                  //   // child: Lottie.asset(
                  //   //   'assets/lottie/main_intro.json', // Lottie 파일 경로
                  //   //   repeat: true, // 애니메이션 반복 여부
                  //   //   animate: true, // 애니메이션 시작 여부
                  //   // ),
                  // ),
                  SizedBox(height: 0),
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
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.yellow,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(16.0), // 버튼의 모양을 조절
                  //     ),
                  //   ),
                  //   child: Text(
                  //     'Start',
                  //     style: TextStyle(
                  //         color: Colors.black, fontSize: 24, fontFamily: 'main'),
                  //   ),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // '로그인' 버튼 누를 때 로그인 화면으로 이동
                  //     // Start 버튼 누를 때 다른 화면으로 이동
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>
                  //               Login()),
                  //     );
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Colors.transparent, // 배경색을 완전히 투명으로 설정
                  //   ),
                  //   child: Text(
                  //     'Login',
                  //     style: TextStyle(
                  //         color: Colors.white, fontSize: 30, fontFamily: 'main'),
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      // '로그인' 버튼 누를 때 로그인 화면으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Login()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(0),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.black, fontSize: 25, fontFamily: 'main'),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent, // 배경색을 완전히 투명으로 설정
                      ),
                    ),
                  ),
                  SizedBox(height: 0), // 버튼 사이의 간격
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // '시작하기' 버튼 누를 때 게임 화면으로 이동
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>
                  //               GameWidget(game: SnowManGame(tileSize: 64))),
                  //     );
                  //   },
                  //   child: Text(
                  //     '시작하기',
                  //     style: TextStyle(
                  //         color: Colors.yellow, fontSize: 20, fontFamily: 'main'),
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      // '시작하기' 버튼 누를 때 게임 화면으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GameWidget(game: SnowManGame(tileSize: 64)),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(0),
                      child: Text(
                        'Start',
                        style: TextStyle(
                            color: Colors.black, fontSize: 25, fontFamily: 'main'),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent, // 배경색을 완전히 투명으로 설정
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
