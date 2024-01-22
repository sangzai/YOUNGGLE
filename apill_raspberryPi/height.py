#알람 기능 수행
from __future__ import print_function
import time
from datetime import datetime
import ex2_getVoice2Text as gv2t
import ex1_kwstest as kws
import ex4_getText2VoiceStream as tts
import RPi.GPIO as GPIO
import MicrophoneStream as MS
import threading
import server_pub as pub

GPIO.setmode(GPIO.BOARD)
GPIO.setup(16, GPIO.OUT)
GPIO.setup(18, GPIO.OUT)

end_check=False   

def level(request):
    level=0
    index=''
    up_verb=['올려', '높여']
    down_verb=['낮춰', '내려']
    set_verb=['설정','맞춰','변경','로']
    request_list=[]
    for i in request:
        request_list.append(i)
    
    if request.find("단계")>0:
        if request_list[request_list.index("단")-1].isdigit()==False:
            if "로" in request_list:
                if request_list[request_list.index("단")-1] =='한':
                    level=1
                elif request_list[request_list.index("단")-1] =='두':
                    level=2
                index='change'
            if any(findword in request for findword in up_verb)==True:
                index='plus'
            elif any(findword in request for findword in down_verb)==True:
                index='minus'
            elif any(findword in request for findword in set_verb)==True:
                index='change'
        else:
            level=int(request_list[request_list.index("단")-1])
            if "로" in request_list:
                index='change'
                
            else:    
                if any(findword in request for findword in up_verb)==True:
                    index='plus'
                elif any(findword in request for findword in down_verb)==True:
                    index='minus'
                elif any(findword in request for findword in set_verb)==True:
                    index='change'
                
    elif any(findword in request for findword in up_verb)==True:
        index='plus'
        level=1
    elif any(findword in request for findword in down_verb)==True:
        index='minus'
        level=1
#     print('level:',level)
    
    msg={"index": f"{index}", "level": f"{level}"}
    if index==''or level <1 or level>5:
    
        print('wrong_order')
        output_file = "wrong_order.wav"
        tts.getText2VoiceStream("베개 높이는 1에서 5단계까지 조정 가능합니다", output_file)
        MS.play_file(output_file)
    else:
#         threading.Thread(target=pub.pill_height, args=(msg,)).start()
        pub.pill_height(msg)

def powerOff():
    GPIO.output(16, GPIO.HIGH)
    GPIO.output(18, GPIO.HIGH)
    global end_check
    end_check = True

def air_in(grade):
    print("air_in")
    end_check = False
    air_time=24
    for i in range(0, grade):
        GPIO.output(18, GPIO.LOW)
        for i in range(0, air_time):
            if end_check == False:
                time.sleep(1)
            elif end_check == True:
                break
        GPIO.output(18, GPIO.HIGH)
        time.sleep(0.5)
    pub.height_end()
def air_out(grade):
    print("air_out")
    end_check = False
    air_time=18
    for i in range(0, grade):
        GPIO.output(16, GPIO.LOW)
        for i in range(0, air_time):
            if end_check == False:
                time.sleep(1)
            elif end_check == True:
                break 
        GPIO.output(16, GPIO.HIGH)
        time.sleep(0.5)
    pub.height_end()
if __name__ == '__main__':
    try:
#         air_out(4)
        air_in(2)
#         powerOff()
    finally:
        GPIO.cleanup()

