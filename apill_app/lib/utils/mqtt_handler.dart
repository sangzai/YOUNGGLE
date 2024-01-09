import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttHandler extends GetxController {

  static const pubTopic = 'Apill/sql';

  final RxString data = "".obs;
  late MqttServerClient client;

  Future<Object> connect() async {
    client = MqttServerClient.withPort(
        '172.30.1.21', 'app', 1883,
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
          'MQTT_LOGS::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      return throw Exception('MQTT connection failed');
    }

    // print('MQTT_LOGS::Subscribing to the test topic');

    // 토픽 1
    const topic = 'Apill/sql/return';
    client.subscribe(topic, MqttQos.atMostOnce);

    // 토픽 2
    // const topic2 = 'Dart/Mytt_client/flutter/graph';
    // client.subscribe(topic2, MqttQos.atMostOnce);


    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

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
      client.publishMessage(pubTopic, MqttQos.atMostOnce, builder.payload!);
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


}
