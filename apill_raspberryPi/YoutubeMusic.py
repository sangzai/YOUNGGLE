#!/usr/bin/env python
# -*- coding: utf-8 -*-

# 필요한 모듈들을 가져옵니다.
from __future__ import print_function
import ex1_kwstest as kws
import ex2_getVoice2Text as v2t
import ex4_getText2VoiceStream as tts
import MicrophoneStream as MS
import RPi.GPIO as GPIO
import time
import argparse
import pafy
import ffmpeg
import pyaudio
import re
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
import threading


# YouTube API 키 및 기타 설정
DEVELOPER_KEY = 'AIzaSyCpmV7RmtQ7pH7l7eqGesD68GNN3zGcuCY'
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'

# GPIO 설정
GPIO.cleanup()
GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)
GPIO.setup(29, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(31, GPIO.OUT)

# 버튼 및 재생 상태 초기화
btn_status = False
play_flag = 0

# 버튼 콜백 함수
def callback():
    #print("Falling edge detected from pin {}".format(channel))
    #global btn_status
    #btn_status = True
    #print(btn_status)
    global play_flag
    play_flag = 1

# GPIO 이벤트 감지 설정
#GPIO.add_event_detect(29, GPIO.FALLING, callback=callback, bouncetime=10)

# YouTube 검색 함수
def youtube_search(options):
    try:
        youtube = build(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION, developerKey=DEVELOPER_KEY)
        parser = argparse.ArgumentParser()
        parser.add_argument('--q', help='Search term', default=options)
        parser.add_argument('--max-results', help='Max results', default=25)
        args = parser.parse_args()
        search_response = youtube.search().list(
            q=args.q,
            part='id,snippet',
            maxResults=args.max_results
        ).execute()
        videos = []
        url = []
        for search_result in search_response.get('items', []):
            if search_result['id']['kind'] == 'youtube#video':
                videos.append('%s (%s)' % (search_result['snippet']['title'], search_result['id']['videoId']))
                url.append(search_result['id']['videoId'])
        resultURL = "https://www.youtube.com/watch?v=" + url[0]
        return resultURL
    except:
        print("Youtube Error")

# URL을 이용한 비디오 재생 함수
def play_with_url(play_url):
    
    video = pafy.new(play_url)
    best = video.getbestaudio()
    playurl = best.url
    
    global play_flag
    play_flag = 0
    pya = pyaudio.PyAudio()
    
    stream = pya.open(format=pya.get_format_from_width(width=2), channels=1, rate=16000, output=True)
    try:
        process = (ffmpeg
                   .input(playurl, err_detect='ignore_err', reconnect=1, reconnect_streamed=1, reconnect_delay_max=5)
                   .output('pipe:', format='wav', audio_bitrate=16000, ab=64, ac=1, ar='16k')
                   .overwrite_output()
                   .run_async(pipe_stdout=True)
                   )
        while True:
            if play_flag == 0:
                in_bytes = process.stdout.read(4096)
                if not in_bytes:
                    break
                stream.write(in_bytes)
            else:
                break
    finally:
        stream.stop_stream()
        stream.close()

# 메인 함수
def main(text):
    split_text = re.split(r'노래|음악', text)
#             search_text = split_text[split_text.index("노래") - 1]
    search_text = split_text[0]
#                 for i in range(0, split_text.index("노래")):
#                     search_text += split_text[i]

    if search_text != "":
        output_file = "search_text.wav"
        tts.getText2VoiceStream("유튜브에서 노래를 재생합니다.", output_file)
        MS.play_file(output_file)
        result_url = youtube_search(search_text)
        time.sleep(2)
        #thread
        threading.Thread(target=play_with_url, args=(result_url,)).start()
    else:
        output_file = "search_text.wav"
        tts.getText2VoiceStream("정확한 노래를 말해주세요", output_file)
        MS.play_file(output_file)
        text_again= v2t.getVoice2Text()
        main(text_again)
        
      

if __name__ == '__main__':
    main("지코의 날 노래틀어줘")
