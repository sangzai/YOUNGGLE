#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Example 6: STT + Dialog - queryByVoice"""

from __future__ import print_function

import audioop
from ctypes import *

import MicrophoneStream as MS
# STT
import ex4_getText2VoiceStream as tts
import gigagenieRPC_pb2
import gigagenieRPC_pb2_grpc
import grpc
import user_auth as UA
import time

RATE = 16000
CHUNK = 512

HOST = 'openapi.gigagenie.ai'
PORT = 50051

ERROR_HANDLER_FUNC = CFUNCTYPE(None, c_char_p, c_int, c_char_p, c_int, c_char_p)


def py_error_handler(filename, line, function, err, fmt):
    dummy_var = 0


c_error_handler = ERROR_HANDLER_FUNC(py_error_handler)
asound = cdll.LoadLibrary('libasound.so')
asound.snd_lib_error_set_handler(c_error_handler)

channel = grpc.secure_channel('{}:{}'.format(HOST, PORT), UA.getCredentials())
stub = gigagenieRPC_pb2_grpc.GigagenieStub(channel)


def generate_request():
    with MS.MicrophoneStream(RATE, CHUNK) as stream:
        audio_generator = stream.generator()
        msg_req = gigagenieRPC_pb2.reqQueryVoice()
        msg_req.reqOptions.lang = 0
        msg_req.reqOptions.userSession = "1234"
        msg_req.reqOptions.deviceId = "aklsjdnalksd"
        yield msg_req
        for content in audio_generator:
            message = gigagenieRPC_pb2.reqQueryVoice()
            message.audioContent = content
            yield message
            rms = audioop.rms(content, 2)


def queryByVoice():
    print("\n\n\n질의할 내용을 말씀해 보세요.\n\n듣고 있는 중......\n")
    request = generate_request()
#     request = text
    print("request:",request)
    result_text = ''
    request_text = ''
    response = stub.queryByVoice(request)
    if response.resultCd == 200:
        print(response)
        print("질의 내용: %s" % response.uword)
        request_text = response.uword
        for a in response.action:
            response = a.mesg
            parsing_resp = response.replace('<![CDATA[', '')
            parsing_resp = parsing_resp.replace(']]>', '')
            result_text = parsing_resp
            print("\n질의에 대한 답변: " + parsing_resp + '\n\n\n')

    else:
        print("\n\nresultCd: %d\n" % response.resultCd)
        print("정상적인 음성인식이 되지 않았습니다.")
#     tts.getText2VoiceStream(result_text, "result_mesg.wav")
#     MS.play_file("result_mesg.wav")
    time.sleep(2)
    return result_text, request_text


def main():
    result, text = queryByVoice()
    if result != "":
        tts.getText2VoiceStream(result, "result_mesg.wav")
        MS.play_file("result_mesg.wav")
        print("text : ", text)
    else:
        print("xxxxx")
    # print(tts_result)

    '''
    time.sleep(5)
    tts_result = tts.getText2VoiceStream(result, "result_mesg.wav")
    time.sleep(0.5)
    '''


if __name__ == '__main__':
    main()
