import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/route.dart';
import 'package:mainproject_apill/screen/login_page/user_controller.dart';
import 'package:mainproject_apill/utils/mqtt_handler.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';
import 'package:mainproject_apill/widgets/backgroundcon.dart';

class SettingProfile extends StatefulWidget {
  const SettingProfile({super.key});

  @override
  State<SettingProfile> createState() => _SettingProfileState();
}

class _SettingProfileState extends State<SettingProfile> {


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
    String? userinfo = await userCon.storage.read(key: 'userProfile');
    print("✨유저 정보 로드 : ${userinfo}");
    if(userinfo != null){
      userCon.userInfo.value = userinfo;
      List<String> userInfoList = userCon.userInfo.value.split(",");
      setState(() {
        input_id.text = userCon.userId.value;
        input_name.text = userCon.userName.value;
        input_gender.text = userInfoList[0];
        input_age.text = getAge(userInfoList[2]);
        birth.text = userInfoList[2];
        input_weight.text = userInfoList[3];
        input_height.text = userInfoList[4];
      });
    } else {
      print("✨유저 프로필 못 찾음");
    }

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
    print('✨회원탈퇴 : $response');

  }




  @override
  Widget build(BuildContext context) {
    return BackGroundImageContainer(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Card(
                          color: AppColors.appColorWhite50,
                          margin: EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 30.0,
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.email,
                              color: AppColors.appColorBlue80,
                              size: 30.0,
                            ),
                            title: Text(
                              '${userCon.userId.value}', // 아이디
                              style: TextStyle(
                                fontFamily: 'Inconsolata',
                                fontSize: 20.0,
                                color: Color(0xFF212121),
                              ),
                            ),
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
                                      fillColor: Colors.blueGrey.withOpacity(0.2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: input_name,
                                  enabled: false,
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                      label: Text(
                                        "성별",
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      filled: true,
                                      fillColor: Colors.blueGrey.withOpacity(0.2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: input_gender,
                                  enabled: false,
                                ),
                              ),

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
                                      fillColor: Colors.blueGrey.withOpacity(0.2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: birth,
                                  enabled: false,

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
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.appColorBlue70),
                                onPressed: () {
                                  showDialog(context: context, builder: (context){
                                    return Dialog(

                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.7,
                                        height: 180,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10), color: AppColors.appColorWhite.darken(20)),
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
                                                  ElevatedButton(onPressed: () async {
                                                    // 현재 페이지 삭제한 후 페이지 이동
                                                    await userCon.storage.deleteAll();
                                                    Get.offAll(RoutePage());
                                                  },
                                                      child: Text('로그아웃 하기'),
                                                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.appColorBlue.darken(30))),
                                                  SizedBox(width: 10,),
                                                  ElevatedButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                      child: Text('아니오')),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                },
                                child: Text('로그아웃')),

                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.appColorBlue70),
                                onPressed: () async{
                                  List<String> userInfoList = userCon.userInfo.value.split(",");
                                  if (newPasswordController.text.isNotEmpty
                                      && confirmNewPasswordController.text.isNotEmpty){
                                    if (input_height.text != userInfoList[4]
                                    && input_weight.text != userInfoList[3]) {
                                      if (input_height.text.isNotEmpty &&
                                          input_weight.text.isNotEmpty) {
                                        updatedProfile(false);
                                      } else {
                                        showAlertDialog("알림", "프로필 내용 중 비어있는 곳이 있습니다.");
                                      }
                                    } else{
                                      showAlertDialog("알림", "프로필 내용 중 수정된 곳이 없습니다.");
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  color: Colors.grey[200],
                  width: double.infinity,
                  height: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      showDialog(context: context, builder: (context){
                        return Dialog(

                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 180,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10), color: AppColors.appColorWhite.darken(20)),
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
                                      ElevatedButton(onPressed: () async  {
                                        await deleteAccount();
                                        await userCon.storage.deleteAll();
                                        Get.offAll(const RoutePage());
                                      },
                                          child: Text('회원 탈퇴 하기'),
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey)),
                                      SizedBox(width: 10,),
                                      ElevatedButton(onPressed: (){
                                        Navigator.pop(context);
                                      },

                                          child: Text('아니오')),
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
          ),
        ),
      ),
    );
  }
}