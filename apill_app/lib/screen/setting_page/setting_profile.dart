import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/loading_controller.dart';
import 'package:mainproject_apill/screen/login_page/login_page.dart';
import 'package:mainproject_apill/screen/login_page/user_controller.dart';
import 'package:mainproject_apill/widgets/backgroundcon.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
  TextEditingController confirmPasswordController = TextEditingController();

  final userCon = Get.find<UserController>(); // userCon.userName.value 가 유저의 id가 담겨있는 String 변수





  // 가상의 함수: DB에서 사용자 정보 가져오기
  void fetchUserDataFromDatabase() {
    // 여기서는 가상의 값으로 초기화
    input_name.text = "";
    input_gender.text = ""; // 또는 "female"
    input_age.text = "";
    input_height.text = "";
    input_weight.text = "";
  }


  @override
  void initState() {
    super.initState();
    // 페이지가 생성될 때 DB에서 사용자 정보 가져오기
    fetchUserDataFromDatabase();
  }



  @override
  Widget build(BuildContext context) {
    return BackGroundImageContainer(
      child: Scaffold(
        appBar: AppBar(
          title: Text('${userCon.userName.value} 님 환영합니다.',style: TextStyle(color:Colors.white ),), // 이름 $
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
                    '${userCon.userName}', //
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
                        'qwer@gmail.com', // 이메일 ${}
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
                              controller: confirmPasswordController,
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
                                          "사용자 이름",
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
                                          "나이",
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
                                    controller: input_age,
                                    readOnly: true,
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
                          SizedBox(height: 50,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent),
                                  onPressed: () {
                                    // 수정이 되었다고 알림창

                                  },
                                  child: Text('회원 수정하기')),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey),
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

                                              SizedBox(height: 40,),

                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton.icon(onPressed: ()  {
                                                      // 현재 페이지 삭제한 후 페이지 이동
                                                      // Navigator.pushAndRemoveUntil(context,
                                                      //     MaterialPageRoute(builder: (_)=>GetMaterialApp()), (route) => false);

                                                      Get.offAll(LoginPage());


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
                                    // 정말 회원탈퇴를 진행 하시겠습니까? 물어보기
                                    // 회원 탈퇴하기 페이지로 이동
                                  },
                                  child: Text('회원 탈퇴하기'))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),




                  SizedBox(
                    height: 40,
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
                          backgroundColor: Colors.grey),
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
                                        ElevatedButton.icon(onPressed: ()  {
                                          // 현재 페이지 삭제한 후 페이지 이동
                                          // Navigator.pushAndRemoveUntil(context,
                                          //     MaterialPageRoute(builder: (_)=>GetMaterialApp()), (route) => false);

                                          Get.offAll(LoginPage());


                                        }
                                            , icon: Icon(Icons.circle_outlined), label: Text('로그아웃 하기'),
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
                      child: Text('로그아웃'))


                  // TextButton(onPressed: (){
                  //   Get.offAll(LoginPage()); // 로그인 페이지로 이동
                  //
                  // }, child: Text('로그아웃하기'))

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// void loginMember(id, pw, name, weight, height, gender, age,context) async {
//   // FlutterSecureStorage 불러오기
//   final storage = FlutterSecureStorage();
//
//   try {
//     String loginsql = '''
//       SELECT * FROM members
//     ''';
//
//     // 데이터를 Map 형식으로 정의
//     Map<String, dynamic> data = {
//       'id': id,
//       'pw': pw,
//     };
//
//     var result = await dbConnector(loginsql, data);
//
//
//     // 로그인 결과가 있고, 결과가 빈 리스트가 아닌 경우에만 로그인 성공으로 간주
//     if (result != null && result.isNotEmpty) {
//       // 로그인 성공 처리를 여기에 추가
//       // 예: 로그인 성공 메시지를 출력하거나, 다음 화면으로 이동하는 등의 동작 수행
//       print('로그인 성공!');
//
//       //TODO : 스토리지 저장
//       await storage.write(
//           key: 'userId',
//           value: id
//       );
//
//       // 다음 화면으로 이동
//       // Navigator.pushAndRemoveUntil(
//       //   context,
//       //   MaterialPageRoute(builder: (_) => BottomNaviPage()),
//       //       (route) => false,
//       // );
//       Get.offAllNamed('/route');
//
//     } else {
//       // 로그인 실패 처리를 여기에 추가
//       // 예: 로그인 실패 메시지를 출력하거나, 다른 처리를 수행
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //     SnackBar(content: Text('로그인 실패: 아이디 또는 비밀번호가 일치하지 않습니다.'))
//       // );
//       Get.snackbar('로그인 실패', '아이디 또는 비밀번호가 일치하지 않습니다.');
//     }
//
//   } catch (error) {
//     // 예외가 발생하면 에러 메시지 출력
//     print('에러 발생: $error');
//   }
// }