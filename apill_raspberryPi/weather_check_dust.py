# Python3 샘플 코드 #

import xmltodict
import json
import requests

url = 'http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMinuDustFrcstDspth'

params ={
    'searchDate' : '2023-12-28',
    'returnType' : 'xml',
    'serviceKey' : 'a78fit7c96FxMXUhmJ/zDEISVgbTCvvPXyVsSfE6zNCvZaFT1DslsIvfuv2Ra2yGVOi50FE8ovR7Y8khArrEQw==',
    'numOfRows' : '1',
    'pageNo' : '1',
    'informCode' : 'PM10',
}

response = requests.get(url, params=params)
print(response.content)
xml_data = response.content


xml_dict = xmltodict.parse(xml_data)

# 딕셔너리를 JSON으로 변환
json_data = json.dumps(xml_dict, ensure_ascii=False, indent=2)

# JSON 출력
print(json_data)

