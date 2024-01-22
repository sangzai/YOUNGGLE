# Python3 샘플 코드 #
import xmltodict
import json
import requests
from datetime import datetime

def getRainPercent(x,y):
    url = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst'
    params ={
        'serviceKey' : 'a78fit7c96FxMXUhmJ/zDEISVgbTCvvPXyVsSfE6zNCvZaFT1DslsIvfuv2Ra2yGVOi50FE8ovR7Y8khArrEQw==',
        'pageNo' : '10',
        'numOfRows' : '10',
        'dataType' : 'XML',
        'base_date' : datetime.today().strftime("%Y%m%d"),
        'base_time' : '0500',
        'nx' : x,
        'ny' : y
    }

    # 강수확률(POP), 1시간 기온(TMP),일 최저기온(TMN), 일 최고기온(TMX), 풍속(WSD), 미세먼지 
    # 우산, 옷차림, 일교차, 바람의 세기, 미세먼지 

    response = requests.get(url, params=params)
    
    if response.status_code == 200 :
        xml_data = response.content


        xml_dict = xmltodict.parse(xml_data)

        # 딕셔너리를 JSON으로 변환
        json_data = json.dumps(xml_dict, indent=2)
        # 파이썬 객체로 변환
        data = json.loads(json_data)
        # JSON 출력
        print('here',data["response"])
        return data["response"]["body"]["items"]["item"][7]["fcstValue"]
    else:
        return None
#     print(response.content)



if __name__ == "__main__":
    getRainPercent(98,101)
