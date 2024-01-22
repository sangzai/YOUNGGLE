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
GPIO.setup(22, GPIO.OUT)

# def ledControl(result):
#  text = result
#  if text.find("불 켜") >= 0:
#      print("불이 켜집니다.")
#      GPIO.output(31, GPIO.HIGH)
#      
#      return("불이 켜집니다")
#  elif text.find("불 꺼") >= 0:
#      print("불이 꺼집니다.")
#      GPIO.output(31, GPIO.LOW)
#      return("불이 꺼집니다")
#  else :
#      return("정확한 명령을 말해주세요")
#

end_check=False



def add(request):
    request_list = []
    for i in request:
        request_list.append(i)
    korea_list=['영', '일', '이', '삼', '사','오','육','칠','팔', '구']
   
    input_hour = -1
    input_minute = -1
    
    current_hour = int(datetime.now().strftime("%H"))
    current_min = int(datetime.now().strftime("%M"))
    
    former_hour = 0
    former_minute = 0 
    
    hour =''
    minute = ''
    
    if request.find("시")!= -1:
        
        input_hour = 0
        if request_list[request_list.index("시")-2].isdigit():
            input_hour += int(request_list[request_list.index("시")-2]) * 10
        if request_list[request_list.index("시")-1].isdigit():
            input_hour += int(request_list[request_list.index("시")-1])
            
    elif request.find("시")== -1:
        input_hour = -1
    
    if request.find("분")!= -1:
        
        input_minute = 0
        
        if request_list[request_list.index("분")-2].isdigit():
            input_minute += int(request_list[request_list.index("분")-2])*10
#         else:
#             input_minute +='0'
        if request_list[request_list.index("분")-1].isdigit():
            input_minute += int(request_list[request_list.index("분")-1])
        else:
            input_minute += korea_list.index(request_list[request_list.index("분")-1])
                      
    elif request.find("분")== -1:
        input_minute = -1
        
    alarm_time = ['오전', '오후', '아침', '저녁','밤']
    alarm_time_check=any(keyword in request for keyword in alarm_time)
    # 시에 분에  뒤 후
    alarm_time_after = ['뒤', '후']
    alarm_time_after_check=any(keyword in request for keyword in alarm_time_after)
   
    if alarm_time_check==True:
        for i in alarm_time:
            if request.find(i) != -1:
                keyword = i
                #print(keyword)
                if keyword == "오후" or keyword == "저녁" or keyword == "밤":
                    if input_hour < 12:
                        former_hour = input_hour+12
                    else:
                        former_hour = input_hour
                elif keyword == "오전" or keyword == "아침":
                    former_hour = input_hour
                    
    elif alarm_time_after_check==False:
        if current_hour >= 12:
            if current_hour-12 == input_hour :
                if current_min <= input_minute:
                    former_hour = input_hour+12
                else:
                    former_hour = input_hour
            elif current_hour-12 > input_hour:
                former_hour = input_hour
            else:
                former_hour = input_hour+12
        else:
            if current_hour == input_hour:
                if current_min <= input_minute:
                    former_hour = input_hour
                else:
                    former_hour = input_hour+12
            elif current_hour > input_hour:
                former_hour = input_hour+12
            else:
                former_hour = input_hour
    else:
        if input_hour != -1:
            former_hour = input_hour + current_hour
        else:
            former_hour = current_hour
        
        if input_minute != -1:
            former_minute = input_minute + current_min
        else:
            former_minute = current_min
            
        if former_minute >= 60:
            former_hour = former_hour + former_minute//60
            former_minute= former_minute%60
    if former_hour == 24:
        former_hour = 0
    hour = datetime.strptime(str(former_hour), '%H').strftime('%H')
    minute = datetime.strptime(str(former_minute), '%M').strftime('%M')


    msg={"time": f"{hour}:{minute}", "isOn": 1, "isSelected": 0}
    
    if former_minute==0:
        alarm_text = f"{former_hour}시에 알람을 맞춥니다."
    else:
        alarm_text = f"{former_hour}시 {former_minute}분에 알람을 맞춥니다."
    output_file = "alarm_set.wav"
    tts.getText2VoiceStream(alarm_text, output_file)
    MS.play_file(output_file)
    pub.alarmAdd(msg)
#     threading.Thread(target=pub.alarmAdd, args=(msg,)).start()
    

def powerOff():
    global end_check
    end_check = True
    GPIO.output(22, GPIO.LOW)
    MS.end_music()
    
def music(num):
    if num == 1:
        alarm_file = "alarm_army.wav"
    elif num == 2:
        alarm_file = "alarm_pocket1.wav"
    elif num == 3:
        alarm_file = "alarm_pocket2.wav"
    elif num == 4:
        alarm_file = "alarm_pocket3.wav"
    elif num == 5:
        alarm_file = "alarm_purin.wav"
    
    threading.Thread(target=MS.play_music, args=(alarm_file,)).start()
    
    
def main():
#Example7 KWS+STT
#      
#     print('KWS Dectected ...\n Start STT...')
#     text = gv2t.getVoice2Text()
#     print('Recognized Text: '+ text)
#     tts.getText2VoiceStream(ledControl(text), "result_TTS.wav")
#     MS.play_file("result_TTS.wav")
    GPIO.output(22, GPIO.HIGH)
    global end_check
    end_check=False
    for i in range(0, 20):
        if end_check == False:
            time.sleep(1)
        elif end_check == True:
            break
        
    GPIO.output(22, GPIO.LOW)
    time.sleep(2)
    
    
if __name__ == '__main__':
 try:
     main()
 finally:
     GPIO.cleanup()
