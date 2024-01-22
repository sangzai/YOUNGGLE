#-*-coding:utf-8-*-
import requests
import urllib.request
import json

openweather_api_url = "https://api.openweathermap.org/data/2.5/"
service_key = "343d41840e6dcc13607e12d52ddceee2"

def getNowAirPollution(pos_lat, pos_lon):
    global openweather_api_url, service_key

    # API 요청시 필요한 인수값 정의
    ow_api_url = openweather_api_url + "air_pollution"
    payload = "?lat=" + pos_lat + "&" +\
              "lon=" + pos_lon + "&" +\
                "appid=" + service_key
    url_total = ow_api_url + payload

    response = requests.get(url_total)
    if response.status_code == 200 :
        # 받은 값 JSON 형태로 정제하여 반환
        items = response.json()
        #print(items)
        return items
    else:
        return None
    
# API 요청하여 데이터 받기
# req = urllib.request.urlopen(url_total)
# res = req.readline()
# 
#     if res.status_code == 200:
#         # 받은 값 JSON 형태로 정제하여 반환
#         items = json.loads(res)
#         print(items)
#         print(items['list'][0]['components']['pm10'])
# 
#     else:
#         return None
                 

if __name__ == "__main__":
    getNowAirPollution('35.1327', '126.9025')