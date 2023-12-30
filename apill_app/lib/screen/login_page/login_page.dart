import 'package:flutter/material.dart';
import 'package:mainproject_apill/screen/login_page/join_page.dart';
import 'package:mainproject_apill/screen/my_app_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController idCon = TextEditingController();
    TextEditingController pwCon = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    "당신의 APilL",
                    style: TextStyle(
                        color: Color.fromRGBO(179, 175, 153, 1),
                        fontSize: 35,
                        decoration: TextDecoration.none),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    'assets/image/OnlyMoon.png',
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "아이디",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: idCon,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "비밀번호",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: pwCon,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(onPressed: (){
                        // TODO : 카카오 로그인
                        print('카카오 로그인');
                      },
                          icon: Image.asset('assets/image/klogo.png',
                            width: 45,height: 45,)),
                      IconButton(onPressed: (){
                        // TODO : 구글 로그인
                        print('구글 로그인');
                      },
                          icon: Image.asset('assets/image/whiteGoogleIcon.png',
                            width: 45,height: 45,)),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(6, 27, 57, 1)),
                            onPressed: () {
                              // TODO : 로그인
                              print('로그인하기');
                              if(idCon.text =='flutter' && pwCon.text == '1234'){
                                // 페이지 이동
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => MyAppPage()));
                              }else{

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('잘못입력하셨습니다.'))
                                );
                              }
                            },
                            child: Text(
                              '로그인',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )),
                      ),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(6, 27, 57, 1)),
                            onPressed: () {
                              print('회원가입하기');
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => JoinPage()));
                            },
                            child: Text(
                              '회원가입',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )),
                      )
                    ],
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
