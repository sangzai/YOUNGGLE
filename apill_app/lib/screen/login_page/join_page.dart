import 'package:flutter/material.dart';
import 'package:mainproject_apill/widgets/backgroundcon.dart';

enum Gender { male, female }

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  // 성별 저장
  Gender g = Gender.male;

  // 사용자가 선택한 생년월일 저장
  DateTime selectedDate = DateTime.now();

  // 달력을 표시하여 설정하도록 하는 함수
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController input_id = TextEditingController();
    TextEditingController input_pw = TextEditingController();
    TextEditingController input_age = TextEditingController();
    TextEditingController input_name = TextEditingController();
    TextEditingController input_tall = TextEditingController();
    TextEditingController input_weight = TextEditingController();

    return BackGroundImageContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
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
                              Icon(Icons.account_circle, color: Colors.white.withOpacity(0.7)),
                              Text(
                                "email 입력 ",
                                style: TextStyle(color: Colors.white.withOpacity(0.7),
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
                              Icon(Icons.key, color: Colors.white.withOpacity(0.7)),
                              Text(
                                "비밀번호 입력",
                                style: TextStyle(color: Colors.white.withOpacity(0.7),
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
                                  style: TextStyle(color: Colors.white.withOpacity(0.7),
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
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                value: Gender.male,
                                groupValue: g,
                                onChanged: (value) {
                                  setState(() {
                                    g = value!;
                                    print('남성');
                                  });
                                }),
                            RadioListTile(
                                title: Text(
                                  '여성',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                value: Gender.female,
                                groupValue: g,
                                onChanged: (value) {
                                  setState(() {
                                    g = value!;
                                    print('여성');
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
                                  "나이 입력",
                                  style: TextStyle(color: Colors.white.withOpacity(0.7),
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
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              '생년월일',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(
                              '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.bold
                              ),
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
                                  style: TextStyle(color: Colors.white.withOpacity(0.7),
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
                            controller: input_tall,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                label: Text(
                                  "몸무게 입력(kg)",
                                  style: TextStyle(color: Colors.white.withOpacity(0.7),
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
