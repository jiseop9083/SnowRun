import 'package:app/signUp.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:app/game_screen.dart';
import '../functional.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

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
      // appBar: AppBar(
      //   title: Text('로그인'),
      //   automaticallyImplyLeading: false, // 뒤로가기 버튼 비활성화
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/BG_intro2.png'),
                fit: BoxFit.cover, // You can adjust the fit as needed
                alignment: Alignment(0, 0),
              ),
            ),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // intro_logo
                    Container(
                      width: 200,  // 너비를 원하는 크기로 설정하세요.
                      height: 200, // 높이를 원하는 크기로 설정하세요.
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/intro_logo.png'), // 이미지 경로를 정확히 지정하세요.
                          fit: BoxFit.contain, // BoxFit에 따라 이미지의 채우기 방식을 조절하세요.
                        ),
                      ),
                    ),
                    // SizedBox(height:5),
                    // 닉네임 입력 필드
                    Container(
                      width: 200,
                      child: TextField(
                        controller: _nicknameController,
                        decoration: InputDecoration(
                          hintText: 'nickname',
                          // contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          labelStyle: TextStyle(
                            fontFamily: 'main', // 원하는 폰트 패밀리로 설정
                            fontSize: 13.0, // 원하는 폰트 크기로 설정
                            color: Colors.black, // 원하는 색상으로 설정
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black), // 밑줄 색상
                          ),
                          prefixIcon: ImageIcon(AssetImage('assets/images/icon_nickname.png'), size:20),
                        ),
                      ),
                    ),
                    SizedBox(height: 0), // 간격
                    Container(
                      width: 200,
                    // 비밀번호 입력 필드
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'password',
                          // contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          labelStyle: TextStyle(
                            fontFamily: 'main', // 원하는 폰트 패밀리로 설정
                            fontSize: 13.0, // 원하는 폰트 크기로 설정
                            color: Colors.black, // 원하는 색상으로 설정
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black), // 밑줄 색상
                          ),
                          prefixIcon: ImageIcon(AssetImage('assets/images/icon_password.png'), size:20),
                        ),
                      ),
                    ),
                    SizedBox(height: 5), // 간격
                    // 로그인 버튼
                    InkWell(
                      onTap: _login,
                      child: Container(
                        padding: EdgeInsets.all(0),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.black, fontSize: 20, fontFamily: 'main'),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent, // 배경색을 완전히 투명으로 설정
                        ),
                      ),
                    ),
                    SizedBox(height: 0), // 간격
                    // 회원가입 버튼
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => signUp(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(0),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.black, fontSize: 20, fontFamily: 'main'),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent, // 배경색을 완전히 투명으로 설정
                        ),
                      ),
                    ),
                    SizedBox(height: 15), // 간격
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => signUp(),
                    //       ),
                    //     );
                    //   },
                    //   child: Text('Sign Up'),
                    // ),
                  ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
