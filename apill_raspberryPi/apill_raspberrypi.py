import serial
import time
import server_pub as pub
import threading

ser = serial.Serial('/dev/ttyACM0', 115200)  # 포트 이름은 위에서 확인한 이름으로 변경

user_cnt = 0

def main():
    try:
        while True:
            data = ser.readline().decode('utf-8').strip()
            print("Received Pillow sensor:", data)
            # 여기에서 데이터를 활용하여 필요한 동작 수행
            time.sleep(3)
            threading.Thread(target=pub.pill_pressure, args=(data,)).start() 

    except KeyboardInterrupt:
        ser.close()
        print("Serial connection closed.")
