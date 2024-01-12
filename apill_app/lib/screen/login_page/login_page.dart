import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mainproject_apill/models/select_member_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mainproject_apill/screen/login_page/user_controller.dart';
import 'package:mainproject_apill/utils/mqtt_handler.dart';
import 'package:mainproject_apill/widgets/backgroundcon.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final mqttHandler = Get.find<MqttHandler>();
  final userCon = Get.find<UserController>();

  TextEditingController idCon = TextEditingController();
  TextEditingController pwCon = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BackGroundImageContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Container(
                // margin: EdgeInsets.all(16),
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
                        // IconButton(
                        //     onPressed: () {
                        //       // TODO : 카카오 로그인
                        //       print('카카오 로그인');
                        //     },
                        //     icon: Image.asset(
                        //       'assets/image/klogo.png',
                        //       width: 45,
                        //       height: 45,
                        //     )),
                        // IconButton(
                        //     onPressed: () {
                        //       // TODO : 구글 로그인
                        //       print('구글 로그인');
                        //     },
                        //     icon: Image.asset(
                        //       'assets/image/whiteGoogleIcon.png',
                        //       width: 45,
                        //       height: 45,
                        //     )),
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(6, 27, 57, 1)),
                              onPressed: () async {
                                // TODO : 로그인
                                loginMember(idCon.text, pwCon.text );
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
                                print('✨회원가입하기');
                                Get.toNamed('/join');
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (_) => JoinPage()));
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
      ),
    );
  }
  void loginMember(id, pw) async {
    // FlutterSecureStorage 불러오기
    // final storage = FlutterSecureStorage();
    print("✨로그인 버튼 클릭");

    try {
      String sql = '''
          SELECT * FROM members WHERE member_id = "$id" AND member_pw = "$pw"
          ''';
      print("실행");

      String response = await mqttHandler.pubSqlWaitResponse(sql);

      print("✨로그인 답변 : $response");

      // 로그인 결과가 있고, 결과가 빈 리스트가 아닌 경우에만 로그인 성공으로 간주
      if (response.isNotEmpty) {
        if (response != '[]') {
          List<MemberModel> memberList = memberModelFromJson(response);
          // 로그인 성공 처리를 여기에 추가
          // 예: 로그인 성공 메시지를 출력하거나, 다음 화면으로 이동하는 등의 동작 수행
          print('로그인 성공!');

          //TODO : 스토리지 저장
          await userCon.storage.write(
              key: 'userId',
              value: memberList[0].memberId
          );

          await userCon.storage.write(
            key: 'userName',
            value: memberList[0].memberName,
          );

          await userCon.storage.write(
            key: 'userProfile',
            value: '${memberList[0].memberGender},${memberList[0].memberAge},${DateFormat('yyyy-MM-dd').format(memberList[0].memberBirth)},${memberList[0].memberWeight},${memberList[0].memberHeight}'
          );
          print("✨유저 정보 저장 확인");

          String? value = await userCon.storage.read(key: 'userProfile');
          print(value);

          Get.offAllNamed('/route');
        }
        else{
          Get.snackbar('로그인 실패', '아이디 또는 비밀번호가 일치하지 않습니다.');
        }

      } else {
        // 로그인 실패 처리를 여기에 추가
        // 예: 로그인 실패 메시지를 출력하거나, 다른 처리를 수행
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('로그인 실패: 아이디 또는 비밀번호가 일치하지 않습니다.'))
        // );
        Get.snackbar('로그인 실패', '아이디 또는 비밀번호가 일치하지 않습니다.');
      }

    } catch (error) {
      // 예외가 발생하면 에러 메시지 출력
      print('에러 발생: $error');
    }
  }

  // TODO : 적용
  void showAlertDialog(String title, String content) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(content, style: TextStyle(fontSize:20, color: Colors.black),),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

}

