import requests
import map
import ex6_queryVoice as dss
import MicrophoneStream as MS
import ex1_kwstest as kws
import ex4_getText2VoiceStream as tts
import ex2_getVoice2Text as v2t
import time
import weather_dust as wd
import mapgrid as mg
import weather_check as wc

def get_weather_by_code(code):
    api_url = "https://api.openweathermap.org/data/2.5/weather?q=%s&appid=%s&units=%s"
    app_id = "73e41c7c3f1dbff51cfedb3951ce2ee4"
    unit = "metric" # 미터법을 이용하겠다 명시
    response = requests.get(api_url % (code, app_id, unit))
    if response.status_code == 200:
        return response.json()
    else:
        return None
    
def get_weather_by_coord(lat, lon):
    api_url = "https://api.openweathermap.org/data/2.5/weather?lat=%s&lon=%s&appid=%s&units=%s"
    app_id = "73e41c7c3f1dbff51cfedb3951ce2ee4"
    unit = "metric" # 미터법을 이용하겠다 명시
    response = requests.get(api_url % (lat, lon, app_id, unit))
    if response.status_code == 200:
        return response.json()
    else:
        return None
    
def create_weather_text(weather_info, dust_info, rain_per):
    temp_gap=0
    response = """오늘 날씨를 알려드리겠습니다. 현재 온도는 %d 도이고, 습도는 %d 퍼센트입니다.
    최저기온은 %d도, 최고기온은 %d도 이며 미세먼지 농도는"""
    
    # 강수확률(POP), 1시간 기온(TMP),일 최저기온(TMN), 일 최고기온(TMX), 풍속(WSD), 미세먼지 
    # 우산, 옷차림, 일교차, 바람의 세기, 미세먼지
    # 1시간 기온(TMP): weather_info['weather'][0]['main']
    # 일 최저기온(TMN):weather_info['main']['temp_min']
    # 일 최고기온(TMX): weather_info['main']['temp_max']
    # 풍속(WSD): weather_info['wind']['speed']
    

    
    if weather_info != None:
       # if weather_info['weather'][0]['main']=='Rain'
        print("날씨:%r"%str(weather_info['weather'][0]['main']))
        print("일 최저기온(TMN):%r"%str(weather_info['main']['temp_min']))
        print("일 최고기온(TMX):%r"% str(weather_info['main']['temp_max']))
        print("풍속(WSD):%r"%str(weather_info['wind']['speed']))
        if dust_info != None:
            print("미세먼지:%r"%str(dust_info['list'][0]['components']['pm10']))
            fine_dust = dust_info['list'][0]['components']['pm10']
            if fine_dust >= 151:
                response += " 매우나쁨으로 외부 활동은 자제해주시기 바랍니다."
            elif fine_dust >= 81:
                response += " 나쁨으로 장시간 외부 활동은 자제해주시기 바랍니다."
            elif fine_dust >= 31:
                response += " 보통으로 몸 상태에 따라 유의하시기 바랍니다."
            elif fine_dust >= 0:
                response += " 좋음으로 외부활동하기 좋습니다."
                
        if weather_info['main']['temp'] >=27:
            response += "날씨가 더우니 가벼운 옷차림을 추천드리며 "
        elif weather_info['main']['temp'] >=15:
            response += "날씨가 쌀쌀하니 겉옷을 챙기시기 바라며 " 
        elif weather_info['main']['temp'] >=5:
            response += "날씨가 추우니 따뜻하게 입으시기 바라며 "
        else:
            response += "날씨가 매우 추우니 평소보다 더 따뜻한 옷차림을 추천드리며 "
              
             
        if rain_per != None:
            print("강수확률 : ", rain_per)
            if float(rain_per)<30:
                response+= "강수확률은 "+ rain_per+"퍼센트로 비 올 확률이 낮습니다."
            elif float(rain_per)<60:
                response+= "강수확률은 "+ rain_per+"퍼센트로 비가 올 수 있으니 유의하시기 바랍니다."
            elif float(rain_per)<80:
                response+= "강수확률은 "+ rain_per+"퍼센트로 비가 올 확률이 높으니 우산 챙기시기 바랍니다."
        
        return response % ( weather_info['main']['temp'], weather_info['main']['humidity'], weather_info['main']['temp_min'],weather_info['main']['temp_max'])
#         print(response)
#         response = "오늘의 날씨를 알려드리겠습니다. 현재 온도는 3도로 날씨가 매우 추우니 평소보다 더 따뜻한 옷차림을 추천드립니다."
#         return response
    else:
        return "날씨를 알 수 없습니다."

def main():
    # Example8 KWS+STT+DSS
#     print("start")
#     MS.play_file("result_mesg.wav")
#     tts.getText2VoiceStream("어디의 날씨를 알려드릴까요?", "result_mesg.wav")

#     address = v2t.getVoice2Text()
    #address = dss.queryByVoice()
    address = "광주광역시 동구"
   
    coord = map.get_coord_by_address(address)
    print('coord:',coord)
    grid=(mg.mapToGrid(float(coord[0]), float(coord[1])))
    print('grid:',grid)
    if coord == None:
        tts.getText2VoiceStream("%s 을 찾지 못했습니다." % address ,"result_mesg.wav")
   
    else:
        weather_info = get_weather_by_coord(coord[0], coord[1])
        dust_info = wd.getNowAirPollution(coord[0], coord[1])
        rain_per = wc.getRainPercent(grid[0],grid[1])
        response_text = create_weather_text(weather_info, dust_info, rain_per)
       
        tts.getText2VoiceStream(response_text ,"result_mesg.wav")
        
    
    if coord == '':
       print('질의한 내용이 없습니다.\n\n\n')
    else:
       MS.play_file("result_mesg.wav")




if __name__ == "__main__":
    main()
