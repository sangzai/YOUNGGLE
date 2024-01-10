import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttHandler extends GetxController {

  static const String ip = '172.30.1.19';

  // 내가 게시할 토픽 정하기
  static const pubTopic1 = 'Apill/sql';
  static const pubTopic2 = 'Apill/sql/join';
  static const pubTopic3 = 'Apill/alarm/get';
  static const pubTopic4 = 'Apill/height';


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

    print('MQTT_LOGS::Mosquitto client connecting....');

    client.connectionMessage = connMessage;
    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT_LOGS::Mosquitto client connected');
    } else {
      print(
          'MQTT_LOGS::ERROR Mosquitto client connection failed - disconnecting, status is ${client
              .connectionStatus}');
      client.disconnect();
      return throw Exception('MQTT connection failed');
    }

    // print('MQTT_LOGS::Subscribing to the test topic');

    // 구독 토픽 1
    const subtopic1 = 'Apill/sql/return';
    client.subscribe(subtopic1, MqttQos.atMostOnce);

    // 구독 토픽 2
    const subtopic2 = 'Apill/sql/join/return';
    client.subscribe(subtopic2, MqttQos.atMostOnce);

    // 구독 토픽 3
    const subtopic3 = 'Apill/alarm/list';
    client.subscribe(subtopic3, MqttQos.atMostOnce);


    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message);

      data.value = pt;
      update();

      // print(
      //     '✨MQTT_LOGS:: New data arrived: topic is <${c[0].topic}>, payload is $pt');
    });

    return client;
  }

  void onConnected() {
    print('MQTT_LOGS:: Connected');
  }

  void onDisconnected() {
    print('MQTT_LOGS:: Disconnected');
  }

  void onSubscribed(String topic) {
    print('MQTT_LOGS:: Subscribed topic: $topic');
  }

  void onSubscribeFail(String topic) {
    print('MQTT_LOGS:: Failed to subscribe $topic');
  }

  void onUnsubscribed(String? topic) {
    print('MQTT_LOGS:: Unsubscribed topic: $topic');
  }

  void pong() {
    print('MQTT_LOGS:: Ping response client callback invoked');
  }


  Future<void> resetData() async {
    data.value = '';
  }

  Future<void> waitForDataUpdate() async {
    // 원하는 조건이 충족될 때까지 대기
    while (data.value.isEmpty) {
      // await Future.delayed(Duration(seconds: 1)); // 예시로 1초 대기
      await Future.delayed(Duration(milliseconds: 500)); // 적절한 대기 시간 설정
    }

    // 데이터 업데이트가 발생했을 때 이후 로직 수행
    print('✨Data updated: ${data.value}');
  }

  Future<void> publishToSQL(String sql) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(sql);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(pubTopic1, MqttQos.atMostOnce, builder.payload!);
    }
  }

  Future<String> pubSqlWaitResponse(String sql) async {
    String response = '';
    // 게시
    await publishToSQL(sql);

    // 데이터 업데이트 기다리기
    await waitForDataUpdate();

    response = data.value;

    await resetData();

    return response;
  }

  Future<void> publishToJoin(String joinData) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(joinData);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(pubTopic2, MqttQos.atMostOnce, builder.payload!);
    }
  }
  Future<String> pubJoinWaitResponse(String joinData) async {
    String response = '';
    // 게시
    await publishToJoin(joinData);
    // 데이터 업데이트 기다리기
    await waitForDataUpdate();
    response = data.value;
    await resetData();
    return response;
  }

  Future<void> pubGetAlarm() async {
    final builder = MqttClientPayloadBuilder();

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(pubTopic3, MqttQos.atMostOnce, builder.payload!);
    }
  }

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
  Future<void> publishHeight(String heightData) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(heightData);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(pubTopic4, MqttQos.atMostOnce, builder.payload!);
    }
  }
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