import paho.mqtt.client as mqtt
import json

# # MQTT 연결 시 호출되는 콜백 함수
# def on_connect(client, userdata, flags, rc):
#     print(f"Connected with result code {rc}")
#     # 토픽 구독
#     client.subscribe("/Dart/Mqtt_client/flutter/alarm/add")
#     client.subscribe("/pillow")
# 
# # MQTT 메시지 수신 시 호출되는 콜백 함수
# def on_message(client, userdata, msg):
#     print(f"Received message: {msg.payload.decode()}")
# 
#     # 알람 대기
#     if msg.topic == "/Dart/Mqtt_client/flutter/alarm/add":
#         
#         print(msg.payload.decode())
#     # 높이 수행명령
#     elif msg.topic == "/pillow":
# #         update_alarm(msg.payload.decode())
#         print("order")
#         
        
  
def on_disconnect(client, userdata, flags, rc=0):
#     print(str(rc))
    pass


def on_publish(client, userdata, mid):
#     print("In on_pub callback mid= ", mid)
    pass
    
def pill_height(level):
    print("pill_height_level:", level)
    client = mqtt.Client()
    # 콜백 함수 설정 on_connect(브로커에 접속), on_disconnect(브로커에 접속중료), on_publish(메세지 발행)
#     client.on_connect = on_connect
    client.on_disconnect = on_disconnect
    client.on_publish = on_publish
    # address : localhost, port: 1883 에 연결
    client.connect('192.168.148.146', 1883)
    client.loop_start()
    # common topic 으로 메세지 발행
#     client.publish('wait', json.dumps({"success": "ok"}), 1)
    client.publish('Apill/height', json.dumps(level), 1)
    client.loop_stop()
    # 연결 종료
    client.disconnect()
    
def height_end():
    print("height_end:")
    client = mqtt.Client()
    # 콜백 함수 설정 on_connect(브로커에 접속), on_disconnect(브로커에 접속중료), on_publish(메세지 발행)
#     client.on_connect = on_connect
    client.on_disconnect = on_disconnect
    client.on_publish = on_publish
    # address : localhost, port: 1883 에 연결
    client.connect('192.168.148.146', 1883)
    client.loop_start()
    # common topic 으로 메세지 발행
#     client.publish('wait', json.dumps({"success": "ok"}), 1)
    client.publish('Apill/height/complete', json.dumps("height order complete"), 1)
    client.loop_stop()
    # 연결 종료
    client.disconnect()

def pill_pressure(data):
    print("data:", data)
    client = mqtt.Client()
    # 콜백 함수 설정 on_connect(브로커에 접속), on_disconnect(브로커에 접속중료), on_publish(메세지 발행)
#     client.on_connect = on_connect
    client.on_disconnect = on_disconnect
    client.on_publish = on_publish
    # address : localhost, port: 1883 에 연결
    client.connect('192.168.148.146', 1883)
    client.loop_start()
    # common topic 으로 메세지 발행
#     client.publish('wait', json.dumps({"success": "ok"}), 1)
    client.publish('Apill/RB/sensor', json.dumps(data), 1)
    client.loop_stop()
    # 연결 종료
    client.disconnect()

def alarmAdd(msg):
    print("메세지1:", msg)
    # 새로운 클라이언트 생성
    client = mqtt.Client()
    # 콜백 함수 설정 on_connect(브로커에 접속), on_disconnect(브로커에 접속중료), on_publish(메세지 발행)
#     client.on_connect = on_connect
    client.on_disconnect = on_disconnect
    client.on_publish = on_publish
    # address : localhost, port: 1883 에 연결
    client.connect('192.168.148.146', 1883)
    client.loop_start()
    # common topic 으로 메세지 발행
#     client.publish('wait', json.dumps({"success": "ok"}), 1)
    client.publish('Apill/alarm/add', json.dumps(msg), 1)
    client.loop_stop()
    # 연결 종료
    client.disconnect()
    
def main():
    # 새로운 클라이언트 생성
    client = mqtt.Client()
    # 콜백 함수 설정 on_connect(브로커에 접속), on_disconnect(브로커에 접속중료), on_publish(메세지 발행)
#     client.on_connect = on_connect
    client.on_disconnect = on_disconnect
    client.on_publish = on_publish
    # address : localhost, port: 1883 에 연결
    client.connect('192.168.148.146', 1883)
    client.loop_start()
    # common topic 으로 메세지 발행
#     print("here pub_main")
    client.publish('Apill/RB/powercheck', json.dumps({"RB_power": "success"}), 1)
    client.loop_stop()
    # 연결 종료
    client.disconnect()
    
if __name__ == "__main__":
    main()