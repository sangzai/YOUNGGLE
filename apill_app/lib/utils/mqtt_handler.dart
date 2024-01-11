import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/models/alarm_model.dart';
import 'package:mainproject_apill/screen/main_page/alarm_page/alarm_controller.dart';
import 'package:mainproject_apill/screen/main_page/alarm_page/alarm_page.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttHandler extends GetxController {

  final alarmCon = Get.put(AlarmController());

  static const String ip = '172.30.1.19';

  // ✨내가 게시할 토픽 정하기
  static const pubTopic1 = 'Apill/sql';
  static const pubTopic2 = 'Apill/join';
  static const pubTopic3 = 'Apill/join/idcheck';
  static const pubTopic4 = 'Apill/alarm/get';
  static const pubTopic5 = 'Apill/user/profile';
  static const pubTopic6 = 'Apill/height';
  static const pubTopic7 = 'Apill/alarm/check';
  static const pubTopic8 = 'Apill/alarm/add';
  static const pubTopic9 = 'Apill/alarm/delete';
  static const pubTopic10 = 'Apill/alarm/update';
  static const pubTopic11 = 'Apill/App/powercheck';

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
    try {
      await client.connect();
    } catch (e) {
      print('✨Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('✨MQTT_LOGS::MQTT 클라이언트 연결');
    } else {
      print('✨MQTT_LOGS::MQTT 클라이언트 연결 실패 - 연결끊김, 현재상태 ${client
              .connectionStatus}');
      client.disconnect();
      return throw Exception('MQTT connection failed');
    }

    // print('MQTT_LOGS::Subscribing to the test topic');

    //✨구독
    // 구독 토픽 1
    // sql select 반환
    const subtopic1 = 'Apill/sql/return';
    client.subscribe(subtopic1, MqttQos.atMostOnce);

    // 구독 토픽 2
    // 회원가입 결과
    const subtopic2 = 'Apill/join/return';
    client.subscribe(subtopic2, MqttQos.atMostOnce);

    // 구독 토픽 3
    // 회원가입 아이디 체크
    const subtopic3 = 'Apill/join/idcheck/return';
    client.subscribe(subtopic3, MqttQos.atMostOnce);

    // 구독 토픽 4
    // 알람 목록 받기
    const subtopic4 = 'Apill/alarm/Appreturn';
    client.subscribe(subtopic4, MqttQos.atMostOnce);

    // 구독 토픽 5
    // 앱 신호 확인용
    const subtopic5 = 'Apill/App/powercheck/return';
    client.subscribe(subtopic5, MqttQos.atMostOnce);

    // 구독 토픽 7
    // 프로필 받기
    const subtopic7 = 'Apill/user/profile/return';
    client.subscribe(subtopic7, MqttQos.atMostOnce);




    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      var pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

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
        pt = '';
        // print("데이터 비워졌는지 확인 ${pt}");

      }
      // else if (c[0].topic==  ) {
      //
      //
      // }


      data.value = pt;
      update();
    });

    return client;
  }

  void onConnected() {
    print('✨MQTT_LOGS:: Connected');
    pubAppOn();
    print("✨앱 상태 확인 토픽 게시");
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
    String response = '';
    // 게시
    await pubJoin(joinData);

    // 데이터 업데이트 기다리기
    await waitForDataUpdate();

    response = data.value;

    await resetData();

    return response;
  }

  // 프로필 검색 함수
  Future<void> pubLoadProfile(String idData) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(idData);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(pubTopic5, MqttQos.atMostOnce, builder.payload!);
    }
  }
  // 프로필 검색 함수
  Future<String> pubLoadProfileWaitResponse(String idData) async {
    String response = '';
    // 게시
    await pubLoadProfile(idData);

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
  Future<void> publishHeight(String heightData) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(heightData);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(pubTopic6, MqttQos.atMostOnce, builder.payload!);
    }
  }
  // 높이값을 변경해주는 함수
  Future<String> pubHeightWaitResponse(String heightData) async {
    String response = '';
    // 게시
    await publishHeight(heightData);
    // 데이터 업데이트 기다리기
    await waitForDataUpdate();
    response = data.value;
    await resetData();
    return response;
  }

}