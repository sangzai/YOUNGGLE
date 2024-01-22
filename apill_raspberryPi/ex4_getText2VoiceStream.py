#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Example 4: TTS - getText2VoiceStream"""

from __future__ import print_function

from ctypes import *

import MicrophoneStream as MS
import gigagenieRPC_pb2
import gigagenieRPC_pb2_grpc
import grpc
import user_auth as UA

HOST = 'openapi.gigagenie.ai'
PORT = 50051
ERROR_HANDLER_FUNC = CFUNCTYPE(None, c_char_p, c_int, c_char_p, c_int, c_char_p)


def py_error_handler(filename, line, function, err, fmt):
    dummy_var = 0

c_error_handler = ERROR_HANDLER_FUNC(py_error_handler)
asound = cdll.LoadLibrary('libasound.so')
asound.snd_lib_error_set_handler(c_error_handler)


# TTS : getText2VoiceStream
def getText2VoiceStream(input_text, input_filename):
    channel = grpc.secure_channel('{}:{}'.format(HOST, PORT), UA.getCredentials())
    stub = gigagenieRPC_pb2_grpc.GigagenieStub(channel)

    message = gigagenieRPC_pb2.reqText()
    message.lang = 0
    message.mode = 0
    message.text = input_text
    output_file = open(input_filename, 'wb')
    for response in stub.getText2VoiceStream(message):
        if response.HasField("resOptions"):
            print("\n\nResVoiceResult: %d" % response.resOptions.resultCd)
        if response.HasField("audioContent"):
            print("Audio Stream\n\n")
            output_file.write(response.audioContent)
    output_file.close()
    return response.resOptions.resultCd


def main():
    output_file = "default_sound.wav"
    getText2VoiceStream("안녕하세요.  무엇을 도와드릴까요?", output_file)
    MS.play_file(output_file)
    print(output_file + "이 생성되었으니 파일을 확인바랍니다. \n\n\n")


if __name__ == '__main__':
    main()

