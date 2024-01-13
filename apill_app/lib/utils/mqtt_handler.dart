import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/models/alarm_model.dart';
import 'package:mainproject_apill/models/pillow_height_model.dart';
import 'package:mainproject_apill/screen/main_page/alarm_page/alarm_controller.dart';
import 'package:mainproject_apill/screen/main_page/alarm_page/alarm_page.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_utils/set_initial_date.dart';
import 'package:mainproject_apill/screen/main_page/sleep_page/pillow_height_controller.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttHandler extends GetxController {

  final RxBool initCheck = true.obs;
  //     SetInitialDate().initializeData();
  final pillowHeightCon = Get.put(PillowHeightController());

  final alarmCon = Get.put(AlarmController());

  // 건중씨 IP
  // static const String ip = '172.30.1.19';
  // 상원씨 노트북 IP
  static const String ip = '192.168.205.146';


  // ✨내가 게시할 토픽 정하기
  // sql용
  static const pubTopic1 = 'Apill/sql';
  // 회원가입
  static const pubTopic2 = 'Apill/join';
  // id 중복 검사
  static const pubTopic3 = 'Apill/join/idcheck';
  // 높이 보내기
  static const pubTopic6 = 'Apill/App/height';
  // 알람 불러오기
  static const pubTopic7 = 'Apill/alarm/check';
  // 알람 더하기
  static const pubTopic8 = 'Apill/alarm/add';
  // 알람 삭제하기
  static const pubTopic9 = 'Apill/alarm/delete';
  // 알람 수정
  static const pubTopic10 = 'Apill/alarm/update';
  // 앱 전원 확인
  static const pubTopic11 = 'Apill/App/powercheck';


  //✨구독할 토픽 정하기
  // sql 결과값 받기
  static const subtopic1 = 'Apill/sql/return';
  // 회원가입 결과 받기
  static const subtopic2 = 'Apill/join/return';
  // 아이디 중복 체크하기
  static const subtopic3 = 'Apill/join/idcheck/return';
  // 알람 목록 받기
  static const subtopic4 = 'Apill/alarm/Appreturn';
  // 앱 신호 확인용
  static const subtopic5 = 'Apill/App/powercheck/return';
  // 베개 높이 받기
  static const subtopic8 = 'Apill/App/height/return';


  // mqtt response 저장되는변수
  final RxString data = "".obs;

  late MqttServerClient client;

  Future<Object> connect() async {
    client = MqttServerClient.withPort(
      ip, 'app', 1883,
    );
    // client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
    client.keepAlivePeriod = 60;

    /// Set the correct MQTT protocol for mosquito
    client.setProtocolV311();

    final connMessage = MqttConnectMessage()
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    print('✨MQTT_LOGS::Mosquitto client connecting....');

    client.connectionMessage = connMessage;

    while (true) {
      try {
        await client.connect();
      } catch (e) {
        print('✨Exception: $e');
        client.disconnect();

        Get.defaultDialog(
          middleTextStyle: TextStyle(color: Colors.black),
          title: "연결 실패",
          middleText: "연결 재시도중",
          barrierDismissible: false,
        );
      }

      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        print('✨MQTT_LOGS::MQTT 클라이언트 연결');
        Get.back();
        break;
      } else {
        print(
            '✨MQTT_LOGS::MQTT 클라이언트 연결 실패 - 연결끊김, 현재상태 ${client.connectionStatus}');
        client.disconnect();
        print('✨Reconnecting in 10 seconds...');
        await Future.delayed(const Duration(seconds: 10));
      }
    }

    // print('MQTT_LOGS::Subscribing to the test topic');

    //✨구독
    // 구독 토픽 1
    // sql select 반환
    // const subtopic1 = 'Apill/sql/return';
    client.subscribe(subtopic1, MqttQos.atMostOnce);

    // 구독 토픽 2
    // 회원가입 결과
    // const subtopic2 = 'Apill/join/return';
    client.subscribe(subtopic2, MqttQos.atMostOnce);

    // 구독 토픽 3
    // 회원가입 아이디 체크
    // const subtopic3 = 'Apill/join/idcheck/return';
    client.subscribe(subtopic3, MqttQos.atMostOnce);

    // 구독 토픽 4
    // 알람 목록 받기
    // const subtopic4 = 'Apill/alarm/Appreturn';
    client.subscribe(subtopic4, MqttQos.atMostOnce);

    // 구독 토픽 5
    // 앱 신호 확인용
    // const subtopic5 = 'Apill/App/powercheck/return';
    client.subscribe(subtopic5, MqttQos.atMostOnce);

    // 구독 토픽 8
    // 높이 조절
    // const subtopic8 = 'Apill/App/height/return';
    client.subscribe(subtopic8, MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print("✨[${c[0].topic}]에서 데이터 도착");

      if (c[0].topic == subtopic4){
        print("✨알람 목록 구독 토픽 감지 : $pt");
        List<AlarmModel> alarmList = alarmModelFromJson(pt);

        // 기존 알람 리스트 비우기
        alarmCon.alarms.clear();

        for (AlarmModel alarmModel in alarmList){
          int id = alarmModel.id;
          TimeOfDay time = TimeOfDay(
            hour: int.parse(alarmModel.time.split(":")[0]),
            minute: int.parse(alarmModel.time.split(":")[1]),
          );
          bool isOn = alarmModel.isOn == 1;
          bool isSelected = false;

          Alarm alarm = Alarm(time, id: id,isOn: isOn, isSelected: isSelected);
          // alarmCon.alarms.add(alarm);
          alarmCon.alarms.add(alarm);
        }
        print("✨알람 목록 갱신 완료! ${alarmCon.alarms}");
      }
      else if (c[0].topic== subtopic5 ) {
        print("✨서버의 앱 신호 확인 토픽 감지");
        pubAppOn();
        print("✨데이터 비워졌는지 확인 : [$pt]");
      }
      else if (c[0].topic== subtopic8 ) {
        print('✨높이 변경 신호 토픽 감지');
        print('$pt');
        final pillowHeight = pillowHeightFromJson(pt);
        pillowHeightCon.pillowHeight.value = pillowHeight.nowlevel.toDouble();
        pillowHeightCon.lateralHeight.value = pillowHeight.cplevel.toDouble();
        pillowHeightCon.dosalHeight.value = pillowHeight.dplevel.toDouble();

      }

      data.value = pt;
      update();
    });

    if(initCheck.value) {
      SetInitialDate().initializeData();
    }

    return client;
  }

  void onConnected() {
    print('✨MQTT_LOGS:: Connected');
    // print("✨초기화용 데이터 받기");
  }

  void onDisconnected() {
    print('✨MQTT_LOGS:: Disconnected');
  }

  void onSubscribed(String topic) {
    print('✨MQTT_LOGS:: 구독 토픽: $topic');
  }

  void onSubscribeFail(String topic) {
    print('✨MQTT_LOGS:: 구독 실패 $topic');
  }

  void onUnsubscribed(String? topic) {
    print('✨MQTT_LOGS:: 구독 해제: $topic');
  }

  void pong() {
    print('✨MQTT_LOGS:: Ping response client callback invoked');
  }

  // 기본 답변 초기화 함수
  Future<void> resetData() async {
    data.value = '';
  }

  // 기본 답변 대기 함수
  Future<void> waitForDataUpdate() async {
    // 원하는 조건이 충족될 때까지 대기
    while (data.value.isEmpty) {
      // await Future.delayed(Duration(seconds: 1)); // 예시로 1초 대기
      await Future.delayed(Duration(milliseconds: 500)); // 적절한 대기 시간 설정
    }

    // 데이터 업데이트가 발생했을 때 이후 로직 수행
    print('✨Data updated: ${data.value}');
  }

  // 앱이 켜진 신호 보내기
  Future<void> pubAppOn() async {
    final builder = MqttClientPayloadBuilder();

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(pubTopic11, MqttQos.atMostOnce, builder.payload!);
    }

    print("✨ 앱 신호확인 게시");
  }

  // select용 sql함수
  Future<void> publishToSQL(String sql) async {
    print("✨ select sql 함수 실행2 ");
    final builder = MqttClientPayloadBuilder();
    builder.addString(sql);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(pubTopic1, MqttQos.atMostOnce, builder.payload!);
    }
  }
  // select용 sql함수
  Future<String> pubSqlWaitResponse(String sql) async {
    await resetData();
    print("✨ select sql 함수 실행1");
    String response = '';
    // 게시
    await publishToSQL(sql);
    print("✨1 게시 완료");

    // 데이터 업데이트 기다리기
    await waitForDataUpdate();
    print("✨2 답변 대기 완료");

    response = data.value;

    await resetData();

    print("✨3 응답 비우기 완료");
    return response;
  }

  // 회원가입 아이디 중복 체크
  Future<void> pubJoinCheckId(String id) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(id);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(pubTopic3, MqttQos.atMostOnce, builder.payload!);
    }
  }
  // 회원가입 아이디 중복 체크
  Future<String> pubCheckIdWaitResponse(String id) async {
    await resetData();
    String response = '';
    // 게시
    await pubJoinCheckId(id);

    // 데이터 업데이트 기다리기
    await waitForDataUpdate();

    response = data.value;

    await resetData();

    return response;
  }

  // 회원가입
  Future<void> pubJoin(String joinData) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(joinData);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(pubTopic2, MqttQos.atMostOnce, builder.payload!);
    }
  }
  // 회원가입
  Future<String> pubJoinWaitResponse(String joinData) async {
    await resetData();
    String response = '';
    // 게시
    await pubJoin(joinData);

    // 데이터 업데이트 기다리기
    await waitForDataUpdate();

    response = data.value;

    await resetData();

    return response;
  }

  // 알람 가져오는 함수
  Future<void> pubGetAlarm() async {
    final builder = MqttClientPayloadBuilder();

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(pubTopic7, MqttQos.atMostOnce, builder.payload!);
    }
  }
  // 알람 가져오는 함수
  Future<String> pubGetAlarmWaitResponse() async {
    await resetData();
    String response = '';
    // 게시
    await pubGetAlarm();

    // 데이터 업데이트 기다리기
    await waitForDataUpdate();

    response = data.value;

    await resetData();

    return response;
  }

  // 알람 추가 함수
  Future<void> pubAddAlarm(
      TimeOfDay addAlarmTime,
      bool editedIsOn,
      bool isSelected,) async {
      String hour = '${addAlarmTime.hour}'.padLeft(2,'0');
      String minute = '${addAlarmTime.minute}'.padLeft(2,'0');


    final Map<String, dynamic> jsonData = {
      'time' : "$hour:$minute",
      'isOn' : editedIsOn ? 1 : 0,
      'isSelected' : 0,
    };
    final String encodeJson = jsonEncode(jsonData);

    final builder = MqttClientPayloadBuilder();
    builder.addString(encodeJson);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(pubTopic8, MqttQos.atMostOnce, builder.payload!);
    }
  }

  //알람 삭제 함수
  Future<void> pubDeleteAlarm(List<int> selectedIds) async {
    for (int id in selectedIds){
      final Map<String, dynamic> jsonData = {'id': id};
      final String encodeJson = jsonEncode(jsonData);

      final builder = MqttClientPayloadBuilder();
      builder.addString(encodeJson);

      if (client.connectionStatus?.state == MqttConnectionState.connected) {
        client.publishMessage(pubTopic9, MqttQos.atMostOnce, builder.payload!);
      }
    }
  }

  //알람 수정 함수
  Future<void> pubUpdateAlarm(
      TimeOfDay editedAlarmTime,
      bool editedIsOn,
      bool isSelected,
      int editedAlarmId, ) async {

      String hour = '${editedAlarmTime.hour}'.padLeft(2,'0');
      String minute = '${editedAlarmTime.minute}'.padLeft(2,'0');


    final Map<String, dynamic> jsonData = {
      'time' : "$hour:$minute",
      'isOn' : editedIsOn ? 1 : 0,
      'isSelected' : 0,
      'id': editedAlarmId
    };
    final String encodeJson = jsonEncode(jsonData);

    final builder = MqttClientPayloadBuilder();
    builder.addString(encodeJson);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(pubTopic10, MqttQos.atMostOnce, builder.payload!);
    }
  }


  // 높이값을 변경해주는 함수
  Future<void> publishHeight(int dp, int cp) async {
    final Map<String, dynamic> jsonData = {
      'DP' : dp,
      'CP' : cp
    };
    final String encodeJson = jsonEncode(jsonData);

    final builder = MqttClientPayloadBuilder();
    builder.addString(encodeJson);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(pubTopic6, MqttQos.atMostOnce, builder.payload!);
    }
  }
  // 높이값을 변경해주는 함수
  Future<String> pubHeightWaitResponse(int dp, int cp) async {
    String response = '';
    await resetData();
    // 게시
    await publishHeight(dp, cp);
    // 데이터 업데이트 기다리기
    await waitForDataUpdate();
    response = data.value;
    await resetData();
    return response;
  }

  Future<void> setUnsubscribe() async {
    client.unsubscribe(subtopic5);
    client.unsubscribe(subtopic4);
    client.unsubscribe(subtopic8);
    data.value = '';
  }

  Future<void> setSubscribe() async {
    client.subscribe(subtopic5,MqttQos.atMostOnce);
    client.subscribe(subtopic4,MqttQos.atMostOnce);
    client.subscribe(subtopic8,MqttQos.atMostOnce);
    data.value = '';
  }

}