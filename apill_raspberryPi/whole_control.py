#library
import threading
import MicrophoneStream as MS
from datetime import datetime
#py file
import weather as weather
import YoutubeMusic as music
import ex1_kwstest as kws
import ex2_getVoice2Text as v2t
import ex4_getText2VoiceStream as tts
import ex5_queryText as qbt
import ex6_queryVoice as dss
import ex8_kwssttdss as ksd
import server_sub as sub
import server_pub as pub
import alarm as alm
import height as height
import apill_raspberrypi as pill

import time
import re

# 호출에 대한 응답을 처리하는 함수
def handle_command():
    
    MS.play_file("default_sound.wav")
    request = v2t.getVoice2Text()

    music_list = ['노래 들려', '노래 틀어', '노래 재생', '음악 들려', '음악 틀어', '음악 재생']
    music_check = any(keyword in request for keyword in  music_list)
    
    alarm_set=['알람','깨워','알람 맞춰']
    alarm_set_check = any(keyword in request for keyword in alarm_set)
    alarm_set_time = ['시간', '시에', '분']
    alarm_set_time_check = any(keyword in request for keyword in alarm_set_time)
    
    alarm_stop=['알람 멈춰', '알람 꺼']
    alarm_stop_check = any(keyword in request for keyword in alarm_stop)
    
    music_stop_list = ['노래 꺼', '음악 꺼', '노래 멈춰', '음악 멈춰', '노래 중지', '음악 중지', '노래 금지', '음악 금지']
    music_stop_check = any(keyword in request for keyword in music_stop_list)
    
    height_list = ['높이', '단계']
    height_list_check = any(keyword in request for keyword in height_list)

#     height_list=[']
    if music_check:
        print('song here')
        # 넘긴 후에 해당 함수에서 스레드로 실행해주어 그 때 다시 호출 대기
#         music.main(request)
        split_text = re.split(r'노래|음악', request)
        search_text = split_text[0] + " 노래"
        output_file = "search_text.wav"
        tts.getText2VoiceStream("유튜브에서 노래를 재생합니다.", output_file)
        MS.play_file(output_file)
        result_url = music.youtube_search(search_text)
        time.sleep(0.5)
        threading.Thread(target=music.play_with_url, args=(result_url,)).start()

    elif music_stop_check:
        print('song stop')
        music.callback()

    elif alarm_set_check == True and alarm_set_time_check == True:
        print('alarm here')
#         threading.Thread(target=alm.add, args=(request,)).start()
        alm.add(request)
           
    elif alarm_stop_check== True:
#         threading.Thread(target=alm.powerOff).start()
        alm.powerOff()
        
#     elif request.find("높이")!=-1:
    elif height_list_check == True:
        print('height here')
#         threading.Thread(target=height.level, args=(request,)).start()
        height.level(request)
     
    else:
        print('else here!')
        try:
            result = qbt.queryByText(request)
            print(result)
            if result is not None:
                tts.getText2VoiceStream(result, "result_mesg.wav")
    #             try:
                MS.play_file("result_mesg.wav")
                
            else:
                print("xxxxxx")
        except Exception as e:
            print(f"error_check: {e}")

# 상시 호출 대기
def main():
    height.powerOff()
    threading.Thread(target=sub.main).start()
    threading.Thread(target=pub.main).start()
    threading.Thread(target=pill.main).start()
    while True:
        rc = kws.test()
        print("check", rc)
        if rc == 200:
            handle_command()

if __name__ == "__main__":
    main()
