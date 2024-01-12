import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/route.dart';
import 'package:mainproject_apill/screen/login_page/login_page.dart';
import 'package:mainproject_apill/screen/login_page/user_controller.dart';
import 'package:mainproject_apill/utils/mqtt_handler.dart';
import 'package:mainproject_apill/widgets/backgroundcon.dart';

class SettingProfile extends StatefulWidget {
  const SettingProfile({super.key});

  @override
  State<SettingProfile> createState() => _SettingProfileState();
}

class _SettingProfileState extends State<SettingProfile> {

  static const storage = FlutterSecureStorage();

  static String userInfo = '';

  final mqttHandler = Get.find<MqttHandler>();

  final userCon = Get.find<UserController>(); // userCon.userName.value 가 유저의 id가 담겨있는 String 변수

  TextEditingController input_id = TextEditingController();
  TextEditingController input_pw = TextEditingController();
  TextEditingController input_age = TextEditingController();
  TextEditingController input_name = TextEditingController();
  TextEditingController input_height = TextEditingController();
  TextEditingController input_weight = TextEditingController();
  TextEditingController birth = TextEditingController();
  TextEditingController input_gender = TextEditingController();

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  void loadUserProfile() async {
    userInfo = (await storage.read(
      key: 'userProfile'
    ))!;

    List<String> userInfoList = userInfo.split(",");

    input_id.text = userCon.userId.value;
    input_name.text = userCon.userName.value;
    input_gender.text = userInfoList[0];
    input_age.text = getAge(userInfoList[2]);
    birth.text = userInfoList[2];
    input_weight.text = userInfoList[3];
    input_height.text = userInfoList[4];
  }

  String getAge(String birth){
    List<int> intBirth = birth.split('-').map((value) => int.parse(value)).toList();
    int year = intBirth[0] ;
    int month = intBirth[1];
    int day = intBirth[2];

    DateTime today = DateTime.now();
    DateTime birthDate = DateTime(year, month, day);
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    if(age == 0) {
      age = 1;
    }

    return age.toString();
  }

  void updatedProfile(bool pwCheck) async {
    String sql = '''
      UPDATE members
      SET member_pw = '${newPasswordController.text}',
          member_weight = '${input_weight.text}',
          member_height = '${input_height.text}',
      WHERE member_id = '${input_id.text}'
    ''';

    String sql2 = '''
      UPDATE members
      SET member_weight = '${input_weight.text}',
          member_height = '${input_height.text}',
      WHERE member_id = '${input_id.text}'
    ''';

    String mqttSql = pwCheck ? sql : sql2 ;

    String response = await mqttHandler.pubSqlWaitResponse(mqttSql);
    print("✨프로필 업데이트 $response");
    showAlertDialog('알림','회원정보가 수정되었습니다.');
  }

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

  Future<void> deleteAccount() async {
    String deleteSql = """
    DELETE 
    FROM members 
    WHERE member_id = "${userCon.userId.value}'
    """;
    String response = await mqttHandler.pubSqlWaitResponse(deleteSql);

  }







  @override
  Widget build(BuildContext context) {
    return BackGroundImageContainer(
      child: Scaffold(
        appBar: AppBar(
          title: Text('${input_name.text} 님 환영합니다.',style: TextStyle(color:Colors.white ),), // 이름
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  // 동그란 틀에 프로필 사진 imagepicker -> 사진을 촬영
                  CircleAvatar(
                    radius: 80.0,
                    // backgroundImage: AssetImage(''), 이미지를 넣어야 함
                  ),
                  Text(
                    '${input_name.text}', // 이름
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Card(
                    color: Color(0xFFFFFFFF),
                    margin: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 30.0,
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.email,
                        color: Color(0xFF757575),
                        size: 30.0,
                      ),
                      title: Text(
                        '${userCon.userName.value}', // 아이디
                        style: TextStyle(
                          fontFamily: 'Inconsolata',
                          fontSize: 20.0,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ),
                  ),

                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  label: Row(
                                    children: [
                                      Icon(Icons.key,
                                          color: Colors.white.withOpacity(0.7)),
                                      Text(
                                        "현재 비밀번호 입력",
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                              ),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              controller: currentPasswordController,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  label: Row(
                                    children: [
                                      Icon(Icons.key,
                                          color: Colors.white.withOpacity(0.7)),
                                      Text(
                                        "새 비밀번호 입력",
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                              ),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              controller: newPasswordController,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  label: Row(
                                    children: [
                                      Icon(Icons.key,
                                          color: Colors.white.withOpacity(0.7)),
                                      Text(
                                        "새 비밀번호 확인 입력",
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                              ),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              controller: confirmNewPasswordController,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        label: Text(
                                          "이름",
                                          style: TextStyle(
                                              color: Colors.white.withOpacity(0.7),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.2),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        )),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: input_name,
                                  ),
                                ),
                                Expanded(
                                    child: Column(
                                      children: [
                                        // value -- 해당 radio가 가지고 있는 값
                                        // groupvalue -- groupvalue 값과 value의 값이 일치하면 선택된 것으로 판정
                                        RadioListTile(
                                            title: Text(
                                              '남성',
                                              style: TextStyle(
                                                  color: Colors.white.withOpacity(0.7),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            value: 'male',
                                            groupValue: input_gender.text,
                                            onChanged: (value) {
                                              setState(() {
                                                input_gender.text = value.toString();
                                              });
                                            }),
                                        RadioListTile(
                                            title: Text(
                                              '여성',
                                              style: TextStyle(
                                                  color: Colors.white.withOpacity(0.7),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            value: 'female',
                                            groupValue: input_gender.text,
                                            onChanged: (value) {
                                              setState(() {
                                                input_gender.text = value as String;
                                              });
                                            }),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        label: Text(
                                          "생년월일",
                                          style: TextStyle(
                                              color: Colors.white.withOpacity(0.7),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.2),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        )),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: birth,

                                  ),
                                ),

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        label: Text(
                                          "키입력(cm)",
                                          style: TextStyle(
                                              color: Colors.white.withOpacity(0.7),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.2),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        )),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: input_height,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        label: Text(
                                          "몸무게 입력(kg)",
                                          style: TextStyle(
                                              color: Colors.white.withOpacity(0.7),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.2),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        )),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: input_weight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 50,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                  onPressed: () async{
                                    if (newPasswordController.text.isNotEmpty
                                        && confirmNewPasswordController.text.isNotEmpty){
                                      if (input_height.text.isNotEmpty && input_weight.text.isNotEmpty){
                                        updatedProfile(false);
                                      } else {
                                        showAlertDialog("알림","프로필 내용 중 비어있는 곳이 있습니다.");
                                      }
                                    }else{
                                      if (newPasswordController.text != confirmNewPasswordController.text){
                                        showAlertDialog("알림","비밀번호가 같지 않습니다.");
                                      } else {
                                        updatedProfile(true);
                                      }
                                    }
                                  },
                                  child: Text('회원 수정하기')),

                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                  onPressed: () {
                                    showDialog(context: context, builder: (context){
                                      return Dialog(

                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.7,
                                          height: 180,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10), color: Colors.white),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 32,),

                                              Text(
                                                '정말 회원탈퇴를 진행 하시겠습니까?',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                              ),

                                              SizedBox(height: 20,),

                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton.icon(onPressed: () async  {
                                                      await deleteAccount();
                                                      await storage.deleteAll();
                                                      Get.offAll(const RoutePage());
                                                    }
                                                        , icon: Icon(Icons.circle_outlined), label: Text('회원 탈퇴 하기'),
                                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey)),
                                                    SizedBox(width: 10,),
                                                    ElevatedButton.icon(onPressed: (){
                                                      Navigator.pop(context);
                                                    },
                                                        icon: Icon(Icons.close),
                                                        label: Text('아니오')),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });

                                  },
                                  child: Text('회원 탈퇴하기')
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),


                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.grey[200],
                    width: double.infinity,
                    height: 2,
                  ),
                  SizedBox(
                    height: 40,
                  ),

                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        showDialog(context: context, builder: (context){
                          return Dialog(

                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 180,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10), color: Colors.white),
                              child: Column(
                                children: [
                                  const SizedBox(height: 32,),

                                  Text(
                                    '정말 로그아웃을 진행 하시겠습니까?',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),

                                  SizedBox(height: 40,),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton.icon(onPressed: () async {
                                          // 현재 페이지 삭제한 후 페이지 이동
                                          await storage.deleteAll();
                                          Get.offAll(RoutePage());
                                        }
                                            , icon: Icon(Icons.circle_outlined), label: Text('로그아웃 하기'),
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue)),
                                        SizedBox(width: 10,),
                                        ElevatedButton.icon(onPressed: (){
                                          Navigator.pop(context);
                                        },
                                            icon: Icon(Icons.close),
                                            label: Text('아니오')),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });

                      },
                      child: Text('로그아웃'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}