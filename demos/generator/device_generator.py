import importlib
import mhl_field_device as fd
import threading
import json
import datetime as dt
import sys
import math
import time

importlib.reload(fd)

def get_time():
    return int(dt.datetime.now().timestamp() * 1000)

def create_ask_stress_message(badge_id, serial):
    t = get_time()
        
    message = {}
        
    header = {}
    header["message-type"] = "response-request"
    header["badge-id"] = badge_id
    header["channel"] = "outgoing-message"
    header["timestamps"] = [{"process": "active-learning", "location": "generation", "t": t}]
    message["header"] = header

    metadata = {}
    metadata["request-type"] = "stress-rating"
    metadata["serial"] = serial
    message["metadata"] = metadata

    payload = {}
    payload["t"] = t
    message["payload"] = payload
    
    return message

def all_devices_shut_down(devices):
    for d in devices:
        if not d.shutdown_complete:
            return False
    
    return True

def main():
    field_devices = []
    num_field_devices = 1

    for i in range(num_field_devices):
        field_devices.append(fd.FieldDevice("diagnostic_{}".format(i)))

    sensors = [{"type": "accelerometer", "traces": ["x", "y", "z"]}, 
                {"type": "gyroscope", "traces": ["x", "y", "z"]}, 
                {"type": "ppg", "traces": ["trace-1", "trace-2", "trace-3"]}]

    for field_device in field_devices:
        threading.Thread(target=field_device.connect, args=(["synthetic-field-device"])).start()
        field_device.start_sensor_readings(sensors)
        time.sleep(0.8)

    while not all_devices_shut_down(field_devices):
        try: 

            time.sleep(20)

#             for device in field_devices:
#                 device.stop_me()

        except (KeyboardInterrupt, SystemExit):
            print("Caught keyboard interrupt\n")
            for f in field_devices:
                f.stop_me()
                time.sleep(1)

    time.sleep(0.2)
    print("Total shutdown complete")
    
if __name__ == "__main__":
    main()
