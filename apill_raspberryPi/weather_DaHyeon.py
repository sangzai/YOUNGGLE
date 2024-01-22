#-*-coding:utf-8-*-
import urllib.request
import json

openweather_api_url = "https://api.openweathermap.org/data/2.5/"
service_key = "343d41840e6dcc13607e12d52ddceee2"


def getNowCity(city):
    global openweather_api_url, service_key

    # API 요청시 필요한 인수값 정의
    ow_api_url = openweather_api_url + "weather"
    payload = "?q=" + city + "&" + "appid=" + service_key #"lang=kr" 옵션을 추가하면 날씨설명을 한글로 받을 수 있음.
    url_total = ow_api_url + payload

    # API 요청하여 데이터 받기
    req = urllib.request.urlopen(url_total)
    res = req.readline()

    # 받은 값 JSON 형태로 정제하여 반환
    items = json.loads(res)
    print(items)
    
    print(" 1시간 기온(TMP):%r"%str(items['weather'][0]['main']))
    print("일 최저기온(TMN):%r"%str(items['main']['temp_min']))
    print("일 최고기온(TMX):%r"% str(items['main']['temp_max']))
    print("풍속(WSD):%r"%str(items['wind']['speed']))


if __name__ == "__main__":
    getNowCity('Gwangju')
