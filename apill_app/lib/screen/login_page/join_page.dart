import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/widgets/backgroundcon.dart';

final dio = Dio();

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  DateTime selectedDate = DateTime.now();

  final storage = FlutterSecureStorage();

  TextEditingController input_id = TextEditingController();
  TextEditingController input_pw = TextEditingController();
  TextEditingController input_pw_check = TextEditingController();
  TextEditingController input_age = TextEditingController();
  TextEditingController input_name = TextEditingController();
  TextEditingController input_height = TextEditingController();
  TextEditingController input_weight = TextEditingController();
  TextEditingController birth = TextEditingController();
  TextEditingController input_gender = TextEditingController();

  // 달력을 표시하여 설정하도록 하는 함수
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1903),
      lastDate: DateTime.now(),
      locale: Locale('ko', 'KO'),
      // 한글 버전
      helpText: "",
      useRootNavigator: false,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        birth.text = '${picked.year}-${picked.month}-${picked.day}';
        calculateAge();
      });
    }
  }

  void calculateAge() {
    DateTime now = DateTime.now();
    int age = now.year - selectedDate.year;

    // 만 나이를 계산합니다.
    // 올해 생일이 아직 도래하지 않았으면 나이를 1 줄입니다.
    if (now.month < selectedDate.month ||
        (now.month == selectedDate.month && now.day < selectedDate.day)) {
      age--;
    }

    // 표시된 날짜와 나이를 업데이트합니다.
    setState(() {
      selectedDate = selectedDate;
      input_age.text = age.toString();
    });
  }

  // void initState() {
  //   super.initState();
  //
  //   // 비동기로 flutter secure storage 정보를 불러오는 작업
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _asyncMethod();
  //   });
  // }
  @override
  void initState() {
    super.initState();
    calculateAge();
  }

  @override
  Widget build(BuildContext context) {
    return BackGroundImageContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 80.0),
                    child: Image.asset(
                      'assets/image/OnlyMoon.png',
                      width: 170,
                      height: 200,
                    ),
                  ),
                  Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  label: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Icon(Icons.account_circle,
                                            color: Colors.white.withOpacity(0.7)),
                                      ),
                                      Text(
                                        "email 입력 ",
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
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal:8.0)
                              ),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              controller: input_id,

                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 47,
                            child: ElevatedButton(
                              onPressed: () {
                                // checkId(input_id.text);
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  )
                              ),
                              child: Center(
                                child: Text('중복 검사',style: TextStyle(
                                  fontSize:11,
                                ),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.visible,
                                  softWrap: false,//
                                ),
                              ),
                            ),
                          ),
                        ),]
                  ),
                  SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 47,
                      child: TextField(
                        decoration: InputDecoration(
                            label: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.key,
                                      color: Colors.white.withOpacity(0.7)),
                                ),
                                Text(
                                  "비밀번호 입력",
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
                        controller: input_pw,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 47,
                      child: TextField(
                        decoration: InputDecoration(
                            label: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.key,
                                      color: Colors.white.withOpacity(0.7)),
                                ),
                                Text(
                                  "비밀번호 확인",
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
                        controller: input_pw_check,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    // child: Row(
                    //   children: [
                    //     Expanded(
                    child: Container(
                      height: 47,
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
                    // ),

                    // ],
                    // ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(4.0),
                  // // Expanded(
                  //     child: Row(
                  //       children: [
                  //         Text('성별',),
                  //         // value -- 해당 radio가 가지고 있는 값
                  //         // groupvalue -- groupvalue 값과 value의 값이 일치하면 선택된 것으로 판정
                  //         RadioListTile(
                  //             title: Text(
                  //               '남',
                  //               style: TextStyle(
                  //                   color: Colors.white.withOpacity(0.7),
                  //                   fontWeight: FontWeight.bold),
                  //             ),
                  //             value: 'male',
                  //             groupValue: input_gender.text,
                  //             onChanged: (value) {
                  //               setState(() {
                  //                 input_gender.text = value.toString();
                  //               });
                  //             }),
                  //         RadioListTile(
                  //             title: Text(
                  //               '여',
                  //               style: TextStyle(
                  //                   color: Colors.white.withOpacity(0.7),
                  //                   fontWeight: FontWeight.bold),
                  //             ),
                  //             value: 'female',
                  //             groupValue: input_gender.text,
                  //             onChanged: (value) {
                  //               setState(() {
                  //                 input_gender.text = value as String;
                  //               });
                  //             }),
                  //       ],
                  //     ),
                  // ),
                  SizedBox(height:6,),
                  Container(
                    padding: EdgeInsets.only(left: 14),
                    child: Row(
                      children: [
                        Text('성별',
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                        Radio(
                          value: 'male',
                          groupValue: input_gender.text,
                          onChanged: (value) {
                            setState(() {
                              input_gender.text = value.toString();
                            });
                          },
                        ),
                        Text('남',
                          style: TextStyle(
                              fontSize: 16
                          ),),
                        Radio(
                          value: 'female',
                          groupValue: input_gender.text,
                          onChanged: (value) {
                            setState(() {
                              input_gender.text = value.toString();
                            });
                          },
                        ),
                        Text('여',
                          style: TextStyle(
                              fontSize: 16
                          ),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0,right: 1.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () => _selectDate(context),
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '생년월일',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.7),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8), // 간격 추가
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Container(
                                    height: 47,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        label: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            "나이",
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white.withOpacity(0.7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        // filled: true,
                                        // fillColor: Colors.white.withOpacity(0.2),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                      keyboardType: TextInputType.number,
                                      controller: input_age,
                                      readOnly: true,
                                      enabled: false,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  ,SizedBox(height: 3.0,),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            height: 47,
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
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                            height: 47,
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
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () {
                            // // TODO : 회원가입 로직 구현
                            // if (input_pw.text == input_pw_check.text) {
                            //   joinMember(
                            //       input_id.text,
                            //       input_pw.text,
                            //       input_name.text,
                            //       birth.text,
                            //       input_weight.text,
                            //       input_height.text,
                            //       input_gender.text,
                            //       input_age.text,
                            //       context);
                            // } else {
                            //   Get.defaultDialog(
                            //     title: '알람',
                            //     content: Text('비밀번호가 일치하지 않습니다.'),
                            //     titleStyle: TextStyle(color: Colors.black),
                            //   );
                            // }
                          },
                          child: Text('회원 가입')),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// void checkId(id) async {
//   try {
//     String sql = '''
//     select count(member_id) from members where member_id = :id;
//     ''';
//
//     Map<String, dynamic> data = {
//       'id': id
//     };
//
//     var result = await dbConnector(sql, data);
//
//     if (result != null && result.isNotEmpty) {
//
//       if (count > 0) {
//         Get.snackbar('알림', '이미 사용 중인 아이디입니다.');
//       } else {
//         Get.snackbar('알림', '아이디를 사용하실 수 있습니다.');
//       }
//     } else {
//       Get.snackbar('알림', '아이디 중복 확인 중 오류발생');
//     }
//   } catch (error) {
//     print('Error during registration: $error');
//
//     Get.snackbar('알림', '아이디 중복 확인 중 오류발생');
//   }
// }

// void joinMember(
//     id, pw, name, birth, weight, height, gender, age, context) async {
//   try {
//     String sql = '''
//   INSERT INTO members (
//     member_id, member_pw, member_name, member_birth,
//     member_weight, member_height, member_gender, member_age
//   ) VALUES (
//     :id, :pw, :name, :birth, :weight, :height, :gender, :age
//   )
// ''';
//
//     // 데이터를 Map 형식으로 정의
//     Map<String, dynamic> data = {
//       'id': id,
//       'pw': pw,
//       'name': name,
//       'birth': birth,
//       'weight': weight,
//       'height': height,
//       'gender': gender,
//       'age': age,
//     };
//
//     // 데이터베이스에 회원가입 정보 삽입
//     await dbConnector(sql, data);
//
//     // 회원가입 성공 시 로그인 화면으로 이동
//     // ScaffoldMessenger.of(context)
//     //     .showSnackBar(SnackBar(content: Text('회원가입이 완료되었습니다!')));
//     Get.defaultDialog(
//       title: '알림',
//       content: Text('회원가입이 완료되었습니다!'),
//     );
//
//     // Navigator.pop(context);
//     Get.back();
//   } catch (error) {
//     print('Error during registration: $error');
//
//     // ScaffoldMessenger.of(context)
//     //     .showSnackBar(SnackBar(content: Text('회원가입 중 오류 발생')));
//     Get.defaultDialog(
//       title: '알림',
//       content: Text('회원가입 중 오류 발생'),
//     );
//   }
// }
