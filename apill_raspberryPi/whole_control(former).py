import ex2_getVoice2Text as v2t
import weather as weather
import voice2 as voice
import ex8_kwssttdss as ksd
import YoutubeMusic as music
import ex6_queryVoice as dss
import MicrophoneStream as MS
import ex4_getText2VoiceStream as tts
import ex1_kwstest as kws
import alarm as alarm
import ex5_queryText as qbt

def main():
    while True:
        rc = kws.test()
        print("check", rc)
        if rc==200:
            MS.play_file("sample_sound.wav")
#             result, request = dss.queryByVoice()
            request = v2t.getVoice2Text()

            music_list=['노래 들려줘','노래 틀어줘','노래 재생해줘','음악 들려줘','음악 틀어줘','음악 재생해줘']
            music_check = False
            
            for i in music_list:
                if request.find(i) !=-1:
                    music_check = True
                    
            alarm_list=['깨워','알람 맞춰']
            alarm_check=False
            for i in alarm_list:
                    if request.find(i) !=-1:
                        alarm_check = True
              
        #음질 문제 해결해야함 
            if music_check == True:
                print('song here')
                music.main(request)
    
        # ~에 깨워줘, 알람 맞춰줘, 
            elif alarm_check == True:
                print('alarm here')
                alarm.main()
            elif request.find("높이")!=-1:
                print('height here')
                #led.main()
            else:
                print('else here!')
                result = qbt.queryByText(request)
                if result != None:
                    tts.getText2VoiceStream(result, "result_mesg.wav")
                    MS.play_file("result_mesg.wav")
                else:
                    print("xxxxxx")
#             cnt_music = 0
#             cnt_weather = 0
#             cnt_height = 0
#             split_text = [char for char in request]
#             print("text:", split_text)
#             for i in range(0, len(split_text)):
#                 if i != len(split_text)-1:
#                     word = split_text[i]+split_text[i+1]
#                     if word == "노래":
#                         cnt_music += 1
#                     elif word == "날씨":
#                         cnt_weather += 1
#                     elif word == "높이":
#                         cnt_height += 1
#             
#             print("노래:", cnt_music)
#             print("날씨:", cnt_weather)
#             print("높이:", cnt_height)
# 
#             if cnt_music > cnt_weather and cnt_music > cnt_height:
#                 print('song here')
#                 music.main(request)
#             elif cnt_weather > cnt_music and cnt_weather > cnt_height:
#                 print('weather here')
#                 weather.main()
#             elif cnt_height > cnt_music and cnt_height > cnt_weather:
#                 print('light here')
#                 led.main()
#             else:
#                 print('else here!')
#                 tts.getText2VoiceStream(result, "result_mesg.wav")
#                 MS.play_file("result_mesg.wav")

        else:
            print('KWS Not Dectected ...')         
                 

if __name__ == "__main__":
    main() 