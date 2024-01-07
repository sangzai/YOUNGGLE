import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/widgets/backgroundcon.dart';
import 'package:mainproject_apill/utils/db_connector.dart';

final dio = Dio();


class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  DateTime selectedDate = DateTime.now();

  TextEditingController input_id = TextEditingController();
  TextEditingController input_pw = TextEditingController();
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
      locale: Locale('ko', 'KO'), // 한글 버전
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
  void initState(){
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
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Image.asset(
                    'assets/image/OnlyMoon.png',
                    width: 200,
                    height: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                          label: Row(
                            children: [
                              Icon(Icons.account_circle,
                                  color: Colors.white.withOpacity(0.7)),
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
                          )),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: input_id,
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
                        Expanded(
                          child: ListTile(
                            title: Text(
                              '생년월일',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () => _selectDate(context),
                          ),
                        )
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
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // TODO : 회원가입 로직 구현
                        joinMember(
                            input_id.text,
                            input_pw.text,
                            input_name.text,
                            birth.text,
                            input_weight.text,
                            input_height.text,
                            input_gender.text,
                            input_age.text,
                            context);
                      },
                      child: Text('회원 가입'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void joinMember(
    id, pw, name, birth, weight, height, gender, age, context) async {
  try {
    String sql = '''
  INSERT INTO members (
    member_id, member_pw, member_name, member_birth, 
    member_weight, member_height, member_gender, member_age
  ) VALUES (
    :id, :pw, :name, :birth, :weight, :height, :gender, :age
  )
''';

    // 데이터를 Map 형식으로 정의
    Map<String, dynamic> data = {
      'id': id,
      'pw': pw,
      'name': name,
      'birth': birth,
      'weight': weight,
      'height': height,
      'gender': gender,
      'age': age,
    };

    // 데이터베이스에 회원가입 정보 삽입
    await dbConnector(sql, data);

    // 회원가입 성공 시 로그인 화면으로 이동
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text('회원가입이 완료되었습니다!')));
    Get.defaultDialog(
      title: '알림',
      content: Text('회원가입이 완료되었습니다!'),
    );


    // Navigator.pop(context);
    Get.back();


  } catch (error) {
    print('Error during registration: $error');

    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text('회원가입 중 오류 발생')));
    Get.defaultDialog(
      title: '알림',
      content: Text('회원가입 중 오류 발생'),
    );

  }
}