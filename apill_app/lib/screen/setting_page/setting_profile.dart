// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';
// import 'package:mainproject_apill/screen/login_page/login_page.dart';
// import 'package:mainproject_apill/screen/login_page/user_controller.dart';
// // import 'package:mainproject_apill/utils/db_connector.dart';
// import 'package:mainproject_apill/utils/mqtt_handler.dart';
// import 'package:mainproject_apill/widgets/backgroundcon.dart';
//
// class Profile extends StatefulWidget {
//   const Profile({super.key});
//
//   @override
//   State<Profile> createState() => _ProfileState();
// }
//
// class _ProfileState extends State<Profile> {
//
//   final mqttHandler = Get.find<MqttHandler>();
//
//   final userCon = Get.find<UserController>(); // userCon.userName.value 가 유저의 id가 담겨있는 String 변수
//
//   TextEditingController input_id = TextEditingController();
//   TextEditingController input_pw = TextEditingController();
//   TextEditingController input_age = TextEditingController();
//   TextEditingController input_name = TextEditingController();
//   TextEditingController input_height = TextEditingController();
//   TextEditingController input_weight = TextEditingController();
//   TextEditingController birth = TextEditingController();
//   TextEditingController input_gender = TextEditingController();
//
//   TextEditingController currentPasswordController = TextEditingController();
//   TextEditingController newPasswordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     updateUserProfile(); // 페이지가 처음 열릴 때 사용자 정보 불러오기
//   }
//
//   void updateUserProfile() async {
//     final storage = FlutterSecureStorage();
//     String? userId = await storage.read(key: 'userId');
//
//     try {
//       // String sql = 'SELECT * FROM members WHERE member_id = :id';
//       Map<String, dynamic> params = {'id': userId};
//
//       String jsonData = json.encode(params);
//
//       String response = await mqttHandler.pubLoadProfileWaitResponse(jsonData);
//
//       if (response.isNotEmpty) {
//
//         print(response);
//
//         setState(() {
//           // input_id.text = userData.colByName('member_id').toString();
//           // input_pw.text = userData.colByName('member_pw').toString();
//           // input_name.text = userData.colByName('member_name').toString();
//           // birth.text = userData.colByName('member_birth').toString();
//           // input_weight.text = userData.colByName('member_weight').toString();
//           // input_height.text = userData.colByName('member_height').toString();
//           // input_gender.text = userData.colByName('member_gender').toString();
//           //
//           // // Set radio values based on retrieved data
//           // if (userData.colByName('member_gender').toString() == 'male') {
//           //   input_gender.text = 'male';
//           // } else if (userData.colByName('member_gender').toString() == 'female') {
//           //   input_gender.text = 'female';
//           // }
//         });
//       }
//     } catch (error) {
//       print('에러 발생: $error');
//     }
//   }
//
//   void saveUpdatedProfile() async {
//     final storage = FlutterSecureStorage();
//     String? userId = await storage.read(key: 'userId');
//
//     try {
//       String sql = '''
//         UPDATE members
//         SET member_pw = :pw,
//             member_name = :name,
//             member_birth = :birth,
//             member_weight = :weight,
//             member_height = :height,
//             member_gender = :gender
//         WHERE member_id = :id
//       ''';
//
//       Map<String, dynamic> params = {
//         'id': userId,
//         'pw': input_pw.text,
//         'name': input_name.text,
//         'birth': birth.text,
//         'weight': double.parse(input_weight.text),
//         'height': double.parse(input_height.text),
//         'gender': input_gender.text,
//       };
//
//       // var result = await dbConnector(sql, params);
//
//       if (result != null) {
//         showAlertDialog('성공', '회원 정보가 업데이트되었습니다.');
//         // 회원 정보 수정 페이지로 이동
//         Get.offAll(Profile());
//       } else {
//         showAlertDialog('실패', '회원 정보 업데이트에 실패했습니다.');
//       }
//     } catch (error) {
//       print('에러 발생: $error');
//     }
//   }
//
//
//   Future<void> changePassword() async {
//     final storage = FlutterSecureStorage();
//     String? userId = await storage.read(key: 'userId');
//
//     try {
//       if (await checkPassword(userId, currentPasswordController.text)) {
//         if (newPasswordController.text == confirmPasswordController.text) {
//           String pwUpdateSql = 'UPDATE members SET member_pw = :pw WHERE member_id = :id';
//           Map<String, dynamic> pwUpdateParams = {'id': userId, 'pw': newPasswordController.text};
//           // var pwUpdateResult = await dbConnector(pwUpdateSql, pwUpdateParams);
//
//           // String infoUpdateSql = 'UPDATE members SET member_name = :name WHERE member_id = :id';
//           // Map<String, dynamic> infoUpdateParams = {'id': userId, 'name': input_name.text};
//           // var infoUpdateResult = await dbConnector(infoUpdateSql, infoUpdateParams);
//
//           String infoUpdateSql = '''
//           UPDATE members
//           SET member_name = :name,
//               member_birth = :birth,
//               member_weight = :weight,
//               member_height = :height,
//               member_gender = :gender
//           WHERE member_id = :id
//         ''';
//           Map<String, dynamic> infoUpdateParams = {
//             'id': userId,
//             'name': input_name.text,
//             'birth': birth.text,
//             'weight': double.parse(input_weight.text),
//             'height': double.parse(input_height.text),
//             'gender': input_gender.text,
//           };
//           var infoUpdateResult = await dbConnector(infoUpdateSql, infoUpdateParams);
//
//           if (pwUpdateResult != null && infoUpdateResult != null) {
//             showAlertDialog('성공', '회원 정보가 변경되었습니다.',);
//             // 회원 수정 성공 후 페이지 닫기
//             Get.offAll(Profile());
//           } else {
//             showAlertDialog('실패', '변경에 실패했습니다.');
//           }
//         } else {
//           showAlertDialog('비밀번호 불일치', '새비밀번호와 확인 비밀번호가 일치하지 않습니다.');
//         }
//       } else {
//         showAlertDialog('비밀번호 오류', '현재 비밀번호가 일치하지 않습니다.');
//       }
//     } catch (error) {
//       print('에러 발생: $error');
//     }
//   }
//
//   Future<bool> checkPassword(String? userId, String password) async {
//     try {
//       String sql = 'SELECT * FROM members WHERE member_id = :id AND member_pw = :pw';
//       Map<String, dynamic> params = {'id': userId, 'pw': password};
//       var result = await dbConnector(sql, params);
//       return result != null && result.isNotEmpty;
//     } catch (error) {
//       print('에러 발생: $error');
//       return false;
//     }
//   }
//
//   void showAlertDialog(String title, String content) {
//     Get.dialog(
//       AlertDialog(
//         title: Text(title),
//         content: Text(content, style: TextStyle(fontSize:20, color: Colors.black),),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Get.back();
//             },
//             child: Text('확인'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void deleteAccount() async {
//     final storage = FlutterSecureStorage();
//     String? userId = await storage.read(key: 'userId');
//
//     try {
//       String deleteSql = 'DELETE FROM members WHERE member_id = :id';
//       Map<String, dynamic> deleteParams = {'id': userId};
//       var deleteResult = await dbConnector(deleteSql, deleteParams);
//
//       if (deleteResult != null) {
//         showAlertDialog('성공', '회원 탈퇴가 완료되었습니다.');
//         Get.delete<UserController>();
//         Get.offAll(LoginPage());
//       } else {
//         showAlertDialog('실패', '회원 탈퇴에 실패했습니다.');
//       }
//     } catch (error) {
//       print('에러 발생: $error');
//     }
//   }
//
//
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return BackGroundImageContainer(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('${input_name.text} 님 환영합니다.',style: TextStyle(color:Colors.white ),), // 이름
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Container(
//               margin: EdgeInsets.all(12),
//               padding: EdgeInsets.all(12),
//               child: Column(
//                 children: [
//                   // 동그란 틀에 프로필 사진 imagepicker -> 사진을 촬영
//                   CircleAvatar(
//                     radius: 80.0,
//                     // backgroundImage: AssetImage(''), 이미지를 넣어야 함
//                   ),
//                   Text(
//                     '${input_name.text}', // 이름
//                     style: TextStyle(
//                       fontSize: 30.0,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//
//                   Card(
//                     color: Color(0xFFFFFFFF),
//                     margin: EdgeInsets.symmetric(
//                       horizontal: 40.0,
//                       vertical: 30.0,
//                     ),
//                     child: ListTile(
//                       leading: Icon(
//                         Icons.email,
//                         color: Color(0xFF757575),
//                         size: 30.0,
//                       ),
//                       title: Text(
//                         '${userCon.userName.value}', // 아이디
//                         style: TextStyle(
//                           fontFamily: 'Inconsolata',
//                           fontSize: 20.0,
//                           color: Color(0xFF212121),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   SingleChildScrollView(
//                     child: Container(
//                       margin: EdgeInsets.all(16),
//                       padding: EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 80,
//                           ),
//
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: TextField(
//                               decoration: InputDecoration(
//                                   label: Row(
//                                     children: [
//                                       Icon(Icons.key,
//                                           color: Colors.white.withOpacity(0.7)),
//                                       Text(
//                                         "현재 비밀번호 입력",
//                                         style: TextStyle(
//                                             color: Colors.white.withOpacity(0.7),
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                   filled: true,
//                                   fillColor: Colors.white.withOpacity(0.2),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   )),
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.7),
//                               ),
//                               keyboardType: TextInputType.text,
//                               obscureText: true,
//                               controller: currentPasswordController,
//                             ),
//                           ),
//
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: TextField(
//                               decoration: InputDecoration(
//                                   label: Row(
//                                     children: [
//                                       Icon(Icons.key,
//                                           color: Colors.white.withOpacity(0.7)),
//                                       Text(
//                                         "새 비밀번호 입력",
//                                         style: TextStyle(
//                                             color: Colors.white.withOpacity(0.7),
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                   filled: true,
//                                   fillColor: Colors.white.withOpacity(0.2),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   )),
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.7),
//                               ),
//                               keyboardType: TextInputType.text,
//                               obscureText: true,
//                               controller: newPasswordController,
//                             ),
//                           ),
//
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: TextField(
//                               decoration: InputDecoration(
//                                   label: Row(
//                                     children: [
//                                       Icon(Icons.key,
//                                           color: Colors.white.withOpacity(0.7)),
//                                       Text(
//                                         "새 비밀번호 확인 입력",
//                                         style: TextStyle(
//                                             color: Colors.white.withOpacity(0.7),
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                   filled: true,
//                                   fillColor: Colors.white.withOpacity(0.2),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   )),
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.7),
//                               ),
//                               keyboardType: TextInputType.text,
//                               obscureText: true,
//                               controller: confirmPasswordController,
//                             ),
//                           ),
//
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: TextField(
//                                     decoration: InputDecoration(
//                                         label: Text(
//                                           "사용자 이름",
//                                           style: TextStyle(
//                                               color: Colors.white.withOpacity(0.7),
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         filled: true,
//                                         fillColor: Colors.white.withOpacity(0.2),
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(8),
//                                         )),
//                                     style: TextStyle(
//                                       color: Colors.white.withOpacity(0.7),
//                                     ),
//                                     keyboardType: TextInputType.text,
//                                     controller: input_name,
//                                   ),
//                                 ),
//                                 Expanded(
//                                     child: Column(
//                                       children: [
//                                         // value -- 해당 radio가 가지고 있는 값
//                                         // groupvalue -- groupvalue 값과 value의 값이 일치하면 선택된 것으로 판정
//                                         RadioListTile(
//                                             title: Text(
//                                               '남성',
//                                               style: TextStyle(
//                                                   color: Colors.white.withOpacity(0.7),
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             value: 'male',
//                                             groupValue: input_gender.text,
//                                             onChanged: (value) {
//                                               setState(() {
//                                                 input_gender.text = value.toString();
//                                               });
//                                             }),
//                                         RadioListTile(
//                                             title: Text(
//                                               '여성',
//                                               style: TextStyle(
//                                                   color: Colors.white.withOpacity(0.7),
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             value: 'female',
//                                             groupValue: input_gender.text,
//                                             onChanged: (value) {
//                                               setState(() {
//                                                 input_gender.text = value as String;
//                                               });
//                                             }),
//                                       ],
//                                     )),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: TextField(
//                                     decoration: InputDecoration(
//                                         label: Text(
//                                           "생년월일",
//                                           style: TextStyle(
//                                               color: Colors.white.withOpacity(0.7),
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         filled: true,
//                                         fillColor: Colors.white.withOpacity(0.2),
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(8),
//                                         )),
//                                     style: TextStyle(
//                                       color: Colors.white.withOpacity(0.7),
//                                     ),
//                                     keyboardType: TextInputType.number,
//                                     controller: birth,
//
//                                   ),
//                                 ),
//
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Expanded(
//                                   child: TextField(
//                                     decoration: InputDecoration(
//                                         label: Text(
//                                           "키입력(cm)",
//                                           style: TextStyle(
//                                               color: Colors.white.withOpacity(0.7),
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         filled: true,
//                                         fillColor: Colors.white.withOpacity(0.2),
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(8),
//                                         )),
//                                     style: TextStyle(
//                                       color: Colors.white.withOpacity(0.7),
//                                     ),
//                                     keyboardType: TextInputType.number,
//                                     controller: input_height,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Expanded(
//                                   child: TextField(
//                                     decoration: InputDecoration(
//                                         label: Text(
//                                           "몸무게 입력(kg)",
//                                           style: TextStyle(
//                                               color: Colors.white.withOpacity(0.7),
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         filled: true,
//                                         fillColor: Colors.white.withOpacity(0.2),
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(8),
//                                         )),
//                                     style: TextStyle(
//                                       color: Colors.white.withOpacity(0.7),
//                                     ),
//                                     keyboardType: TextInputType.number,
//                                     controller: input_weight,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 50,),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blue),
//                                   onPressed: () async{
//                                     if (newPasswordController.text.isNotEmpty) {
//                                       // 비밀번호를 변경하는 경우
//                                       await changePassword();
//                                     } else {
//                                       // 비밀번호 변경이 없는 경우
//                                       saveUpdatedProfile();
//                                     }
//
//                                   },
//                                   child: Text('회원 수정하기')),
//
//
//
//
//                               ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blue),
//                                   onPressed: () {
//                                     showDialog(context: context, builder: (context){
//                                       return Dialog(
//
//                                         child: Container(
//                                           width: MediaQuery.of(context).size.width * 0.7,
//                                           height: 180,
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(10), color: Colors.white),
//                                           child: Column(
//                                             children: [
//                                               const SizedBox(height: 32,),
//
//                                               Text(
//                                                 '정말 회원탈퇴를 진행 하시겠습니까?',
//                                                 style: const TextStyle(
//                                                     fontSize: 16,
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Colors.red),
//                                               ),
//
//                                               SizedBox(height: 20,),
//
//                                               Padding(
//                                                 padding: const EdgeInsets.all(8.0),
//                                                 child: Row(
//                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                   children: [
//                                                     ElevatedButton.icon(onPressed: ()  {
//                                                       deleteAccount();
//
//                                                       // 현재 페이지 삭제한 후 페이지 이동
//                                                       // Get.offAll(LoginPage());
//
//
//                                                     }
//                                                         , icon: Icon(Icons.circle_outlined), label: Text('회원 탈퇴 하기'),
//                                                         style: ElevatedButton.styleFrom(backgroundColor: Colors.grey)),
//                                                     SizedBox(width: 10,),
//                                                     ElevatedButton.icon(onPressed: (){
//                                                       Navigator.pop(context);
//                                                     },
//                                                         icon: Icon(Icons.close),
//                                                         label: Text('아니오')),
//                                                   ],
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     });
//
//                                   },
//                                   child: Text('회원 탈퇴하기')
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     color: Colors.grey[200],
//                     width: double.infinity,
//                     height: 2,
//                   ),
//                   SizedBox(
//                     height: 40,
//                   ),
//
//                   ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue),
//                       onPressed: () {
//                         showDialog(context: context, builder: (context){
//                           return Dialog(
//
//                             child: Container(
//                               width: MediaQuery.of(context).size.width * 0.7,
//                               height: 180,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10), color: Colors.white),
//                               child: Column(
//                                 children: [
//                                   const SizedBox(height: 32,),
//
//                                   Text(
//                                     '정말 로그아웃을 진행 하시겠습니까?',
//                                     style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.red),
//                                   ),
//
//                                   SizedBox(height: 40,),
//
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         ElevatedButton.icon(onPressed: ()  {
//                                           // 현재 페이지 삭제한 후 페이지 이동
//                                           Get.offAll(LoginPage());
//
//
//                                         }
//                                             , icon: Icon(Icons.circle_outlined), label: Text('로그아웃 하기'),
//                                             style: ElevatedButton.styleFrom(backgroundColor: Colors.blue)),
//                                         SizedBox(width: 10,),
//                                         ElevatedButton.icon(onPressed: (){
//                                           Navigator.pop(context);
//                                         },
//                                             icon: Icon(Icons.close),
//                                             label: Text('아니오')),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           );
//                         });
//
//                       },
//                       child: Text('로그아웃'))
//
//
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// void showAlertDialog(String title, String content) {
//   Get.dialog(
//     AlertDialog(
//       title: Text(title),
//       content: Text(content),
//       actions: [
//         ElevatedButton(
//           onPressed: () {
//             Get.back();
//           },
//           child: Text('확인'),
//         ),
//       ],
//     ),
//   );
// }