import paho.mqtt.client as mqtt
import ex4_getText2VoiceStream as tts
import MicrophoneStream as MS
import alarm as alm
import height as height
import threading
import server_pub as pub
import weather as wea
import weather_dust as wd
import mapgrid as mg
import weather_check as wc
import json

# def on_connect(client, userdata, flags, rc):
#     if rc == 0:
#         print("connected OK")
#     else:
#         print("Bad connection Returned code=", rc)


def on_disconnect(client, userdata, flags, rc=0):
    print(str(rc))


def on_subscribe(client, userdata, mid, granted_qos):
    print("subscribed: " + str(mid) + " " + str(granted_qos))


# def on_message(client, userdata, msg):
#     print(str(msg.payload.decode("utf-8")))
    
# MQTT 연결 시 호출되는 콜백 함수
def on_connect(client, userdata, flags, rc):
    print(f"Connected with result code {rc}")
    # 토픽 구독
    client.subscribe("Apill/alarm/RBreturn")
    client.subscribe("Apill/height/return")
    client.subscribe("Apill/RB/powercheck/return")
    client.subscribe("Apill/height/return/msg")
    client.subscribe("Apill/RB/weather/return")

# MQTT 메시지 수신 시 호출되는 콜백 함수
def on_message(client, userdata, msg):
#     print(f"Received message: {msg.payload.decode()}")
    try:
        data=json.loads(msg.payload.decode())
    #     print(data["air_check"])
        # 알람 대기
        if msg.topic == "Apill/alarm/RBreturn":
            threading.Thread(target=alm.main).start()
            alm.music(data["msg"])
            print("here!",msg.payload.decode())
        elif msg.topic == "Apill/RB/weather/return":
            # 날씨 브리핑
            alm.powerOff()
            coord = ['35.1102272', '126.8819292']
            grid=(mg.mapToGrid(float(coord[0]), float(coord[1])))
            print('WakeUP weather brief')
            if coord == None:
                tts.getText2VoiceStream("%s 을 찾지 못했습니다." % address ,"result_mesg.wav")
           
            else:
                weather_info = wea.get_weather_by_coord(coord[0], coord[1])
                dust_info = wd.getNowAirPollution(coord[0], coord[1])
                rain_per = wc.getRainPercent(grid[0],grid[1])
                response_text = wea.create_weather_text(weather_info, dust_info, rain_per)
                print('response_text:',response_text)
                tts.getText2VoiceStream(response_text, "wakeup_mesg.wav")
                MS.play_file("wakeup_mesg.wav")
                tts.getText2VoiceStream(response_text ,"wakeup_mesg.wav")
                
            
        # 높이 수행명령
        elif msg.topic == "Apill/height/return":
            if data["air_check"]=='in':
                threading.Thread(target=height.air_in,args=(data["air_level"],)).start()
            else: 
                threading.Thread(target=height.air_out,args=(data["air_level"],)).start()
        elif msg.topic == "Apill/RB/powercheck/return":
#            print("전원체크:",msg.payload.decode())
            threading.Thread(target=pub.main).start()
             
        elif msg.topic == "Apill/height/return/msg":
            if data["msg"]==1:
                speak='현재 같은 높이입니다.'
            elif data["msg"]==2:
                speak='현재 최대 높이입니다.'
            elif data["msg"]==3:
                speak='현재 최소 높이입니다.'
            elif data["msg"]==4:
                speak='최대 높이인 5단계로 변경되었습니다.'
            elif data["msg"]==5:
                speak=data['level'] + "단계로 변경되었습니다."
            elif data["msg"]==6:
                speak='최소 높이인 1단계로 변경되었습니다.'
            output_file = "height_wrong_order.wav"
            print(speak)
            tts.getText2VoiceStream(speak, output_file)
            MS.play_file(output_file)
                
    except json.decoder.JSONDecodeError as e:
        print(f"JSON Decode Error: {e}")
        


def main():
    # 새로운 클라이언트 생성
    client = mqtt.Client()
    # 콜백 함수 설정 on_connect(브로커에 접속), on_disconnect(브로커에 접속중료), on_subscribe(topic 구독),
    # on_message(발행된 메세지가 들어왔을 때)
    client.on_connect = on_connect
    client.on_disconnect = on_disconnect
    client.on_subscribe = on_subscribe
    client.on_message = on_message
    # address : localhost, port: 1883 에 연결
    client.connect('192.168.148.146', 1883)
    # common topic 으로 메세지 발행
    client.loop_forever()
    print("listen")
    
if __name__ == "__main__":
    main()