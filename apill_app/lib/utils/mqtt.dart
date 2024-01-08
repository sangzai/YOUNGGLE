import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final client = MqttServerClient('172.30.1.21', 'app');

var pongCount = 0; // Pong 횟수

Future<int> main() async {
  /// 웹소켓 URL은 ws:// 또는 wss://로 시작해야하며 Dart는 예외를 throw합니다. 웹소켓 MQTT 브로커를 참조하세요.
  /// 웹소켓을 사용하려면 다음 라인을 추가하세요.
  /// client.useWebSocket = true;
  // client.port = 8883; // ( 또는 사용 중인 WS 포트)
  /// 특수한 사용을 위한 대체 웹소켓 구현도 있습니다. useAlternateWebSocketImplementation 참조
  /// wss를 사용하는 경우 secure 플래그를 설정하지 마세요. secure 플래그는 TCP 소켓에만 적용됩니다.
  /// websocketProtocols 세터를 사용하여 사용자 고유의 웹소켓 프로토콜 목록을 제공하거나 이 기능을 사용하지 않도록 비활성화할 수도 있습니다.
  /// 여기에서 API 문서를 자세히 읽으세요. 대부분의 브로커는 대부분의 경우 클라이언트 기본 목록을 지원하므로 이를 무시할 수 있습니다.

  /// 필요한 경우 로깅을 설정합니다. 기본값은 off입니다.
  client.logging(on: true);

  /// Mosquitto에 대한 올바른 MQTT 프로토콜을 설정합니다.
  client.setProtocolV311();

  /// Keep alive를 사용할 경우 여기에 설정해야 합니다. 그렇지 않으면 keep alive가 비활성화됩니다.
  client.keepAlivePeriod = 20;

  /// 연결 시간 제한 기간을 설정할 수 있습니다. 기본값은 5 초입니다.
  client.connectTimeoutPeriod = 2000; // 밀리초

  /// 연결 해제 콜백을 추가합니다.
  client.onDisconnected = onDisconnected;

  /// 성공한 연결 콜백을 추가합니다.
  client.onConnected = onConnected;

  /// 구독 콜백을 추가합니다. 필요한 경우 구독이 실패한 경우를 위해 onSubscribeFail 콜백도 사용할 수 있습니다.
  /// 이 콜백은 무효한 토픽에 대한 구독을 시도하거나 브로커가 구독 요청을 거부한 경우에 실패할 수 있습니다.
  client.onSubscribed = onSubscribed;

  /// 필요한 경우 브로커에서 Pong 메시지를 수신할 때 호출되는 Pong 수신 콜백을 설정합니다.
  client.pongCallback = pong;

  /// 사용하거나 기본 메시지를 사용하여 연결 메시지를 생성합니다.
  final connMess = MqttConnectMessage()
      // .withClientIdentifier('ApilL_APP')
      // .withWillTopic('willtopic') // 이를 설정하면 윌 메시지도 설정해야 합니다.
      // .withWillMessage('My Will message')
      .startClean(); // 테스트를 위한 비영속 세션
      // .withWillQos(MqttQos.atLeastOnce);
  print('✨예시 : 모스키토 클라이언트 연결중...');
  client.connectionMessage = connMess;

  /// 클라이언트를 연결합니다. 여기서 발생한 모든 오류는 적절한 예외를 발생시켜 알려줍니다.
  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    // 클라이언트에서 연결 실패 시 발생
    print('✨예시 : 클라이언트 연결 예외 - $e');
    client.disconnect();
  } on SocketException catch (e) {
    // 소켓 레이어에서 발생
    print('✨예시 : 소켓 예외 - $e');
    client.disconnect();
  }

  /// 연결이 되었는지 확인합니다.
  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('✨예시 : 연결확인');
  } else {
    /// 상태 대신 여기서 status를 사용하면 브로커 리턴 코드도 얻을 수 있습니다.
    print(
        '✨예시 : 모스키토 클라이언트 연결 실패, 상태값 : ${client.connectionStatus}');
    client.disconnect();
    exit(-1);
  }

  /// 이제 구독을 시도해 봅시다.
  print('✨예시 : 구독 시작');
  const topic = 'Dart/Mqtt_client/flutter/sql/return'; // 와일드카드 토픽이 아님
  client.subscribe(topic, MqttQos.atMostOnce);

  /// 클라이언트에는 각 구독된 토픽에 대한 게시된 업데이트에 대한 알림을 얻기 위해 청취할 수 있는 change notifier 객체가 있습니다.
  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt =
    MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    /// 위의 내용은 페이로드에만 관심이 있는 사용자에게는 다소 복잡해 보일 수 있습니다.
    /// 그러나 일부 사용자는 받은 게시 메시지에 관심을 갖을 수 있습니다.
    /// 패키지가 어느 정도 알려진 상태가 될 때까지 우리를 제한하지 말아 봅시다.
    /// 페이로드는 바이트 버퍼이며 이는 토픽에 특정합니다.
    print(
        '✨예시 확인 topic is <${c[0].topic}>, payload is <-- $pt -->');
    print('');
  });

  /// 필요하면 게시된 메시지를 청취할 수 있습니다. 이 스트림에서 수신된 모든 메시지는 브로커와의 게시 핸드셰이크를 완료했습니다.
  // client.published!.listen((MqttPublishMessage message) {
  //   print(
  //       // 'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}'
  //     '확인'
  //   );
  // });

  /// 토픽에 게시합니다.
  /// raw 버퍼 대신 페이로드 빌더를 사용합니다.
  /// 게시할 알려진 토픽
  const pubTopic = 'Dart/Mqtt_client/flutter/sql';
  final builder = MqttClientPayloadBuilder();
  builder.addString('SELECT * FROM mibanddata');

  /// 구독합니다.
  // print('✨예시 : 토픽 구독');
  // client.subscribe(pubTopic, MqttQos.exactlyOnce);

  /// 게시합니다.
  print('✨예시 : 내 토픽 게시');
  client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);

  /// 이제 잠시 동안 잠자기 상태에 들겠습니다. 이 기간 동안 keep alive 메커니즘에 의해 핑 요청/응답 메시지가 교환됩니다.
  print('✨예시 : 대기중');
  await MqttUtilities.asyncSleep(60);

  /// 마지막으로 gracefully하게 구독을 해제하고 종료합니다.
  print('✨예시 : 구독해제');
  client.unsubscribe(topic);

  /// 원한다면 브로커로부터 구독 해제 메시지를 기다립니다.
  await MqttUtilities.asyncSleep(2);
  print('✨예시 : 연결끊어짐');
  client.disconnect();
  print('✨예시 : 정상 종료');
  return 0;
}

/// 구독된 콜백
void onSubscribed(String topic) {
  print('✨예시 : 주제가 확인되었습니다: $topic');
}

/// 비초기화된 연결 콜백
void onDisconnected() {
  print('예제 : 클라이언트 연결 해제시 클라이언트 콜백 - 클라이언트 연결 해제');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    print('✨예제 : 클라이언트 연결 해제시 콜백은 의도된 것입니다 - 올바릅니다');
  } else {
    print(
        '✨예제 : 클라이언트 연결 해제시 콜백은 연결 해제 또는 없음 - 올바르지 않습니다 - 종료');
    exit(-1);
  }
  if (pongCount == 3) {
    print('✨예제 : 퐁 카운트가 올바릅니다');
  } else {
    print('✨예제 : 퐁 카운트가 올바르지 않습니다. 예상값은 3이며, 현재값은 $pongCount');
  }
}

/// 성공한 연결 콜백
void onConnected() {
  print(
    '✨예제 : 클라이언트 연결시 클라이언트 콜백 - 클라이언트 연결이 성공했습니다');
}

/// Pong 콜백
void pong() {
  print('✨예제 : Ping 응답 클라이언트 콜백이 호출되었습니다');
  pongCount++;
  print('✨퐁카운트:${pongCount}');
}
