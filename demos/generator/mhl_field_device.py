# -*- coding: utf-8 -*-
import socket
import sys
import json
import datetime as dt
import threading
import time
import math
import random

class FieldDevice():
    
    def __init__(self, user_id, ip="localhost", port=9595, append="", disconnect_callback=None):
        self.user_id = user_id
        self.append = append
        self.ip = ip
        self.port = port
        self.sensor_thread = None
        self.sensors_running = False
        self.process_type = "synthetic-field-device"
        self.messages = []
        
        # establish the connection for sending data to the server 
        self.mhl_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        self.mhl_socket.connect((ip, port))

        self.disconnect_callback = disconnect_callback
        
        self.stopped = False
        self.shutdown_complete = False
            
    def connect(self, process_type, pertains_to=None, messages=None):
        """
        Establishes both incoming (receive) and outgoing (send) connections to the server 
        and authenticates the user.
        """
        if messages is None:
            messages = self.messages
            
        try:
            print("Attempting to contact server " + self.ip)
            sys.stdout.flush()
            self._authenticate(self.mhl_socket, pertains_to)
            
            threading.Thread(target=self.check_for_incoming_message, args=([])).start()
            
            print("Successfully connected to {}. Transmitting data.\n".format(self.ip))
            sys.stdout.flush()
            
            sys.stdout.flush()
                
            previous_json = ''
                
            while not self.stopped:
            
                try:
                    if len(self.messages) > 0:
                        message = self.messages.pop(0)
                        message["header"]["timestamps"].append({"process": process_type, 
                                                                "location": "transmission", 
                                                                "t": dt.datetime.now().timestamp() * 1000})
        
                        self.send_message("{}\n".format(json.dumps(message)).encode())
            
#                         print("sent message:\n" + json.dumps(message))

                except KeyboardInterrupt: 
                    # occurs when the user presses Ctrl-C
                    print("User Interrupt. Quitting...")
                    sys.stdout.flush()
                    
                    break
                except Exception as e:
                    # ignore exceptions, such as parsing the json
                    # if a connection timeout occurs, also ignore and try again. Use Ctrl-C to stop
                    # but make sure the error is displayed so we know what's going on
                    if (e.message != "timed out"):  # ignore timeout exceptions completely       
                        print(e)
                    else:
                        previous_json=''
                    pass
        except KeyboardInterrupt: 
            # occurs when the user presses Ctrl-C
            print("User Interrupt. Quitting...")
            sys.stdout.flush()
        finally:
            self.mhl_socket.shutdown(socket.SHUT_RDWR)
            self.mhl_socket.close()
            
            if self.disconnect_callback != None:
                self.disconnect_callback()   
                
            self.shutdown_complete = True
            print("{} shutdown complete\n".format(self.ip))
            sys.stdout.flush()
        
    def send_message(self, message):    
        try:
            self.mhl_socket.send(message)
#             print("thread: sent message: {}\n".format(message))
            
        except Exception as e:
            print("something blew up")
            print(e)
            self.stop_me()
            
    def check_for_incoming_message(self):
        while not self.stopped:
            message = self.mhl_socket.recv(1024).strip().decode()
            json_strings = message.split("\n")
            for json_string in json_strings:
                try:
                    data = json.loads(json_string)

                    receipt_time = {"process": "analytics", 
                                    "location": "receipt", 
                                    "t": dt.datetime.now().timestamp() * 1000}

                    data["header"]["timestamps"].append(receipt_time)

    #                     messages.append(data)

                    print("received:\n{}".format(data))

                    if data["header"]["message-type"] == "response-request" and data["metadata"]["request-type"] == "stress-rating":

    #                     print("about to create stress rating message")

                        stress_rating_message = self.create_stress_rating_message(data["header"]["badge-id"], data["metadata"]["serial"])

    #                     print("created stress rating:\n{}".format(stress_rating_message))

                        self.messages.append(stress_rating_message)
                        print("added outgoing stress rating message:\n{}".format(stress_rating_message))

                    else:
                        print("didn't send response")

                except:
                    break
                    
        print("incoming thread reader checking out")
        
    def start_sensor_readings(self, sensors):
        # start sensor-generation thread
        self.sensors_running = True
        threading.Thread(target=self.sensor_reading_generator, args=([sensors])).start()
    
    def stop_sensor_readings(self):
        # stop sensor generation thread
        self.sensors_running = False
    
    def sensor_reading_generator(self, sensors):
        # target for start_sensor_readings()
        # includes loop and thread sleep
        while self.sensors_running:
            for sensor in sensors:
                self.messages.append(self.create_synthetic_sensor_message(self.user_id, sensor["type"], sensor["traces"]))
                time.sleep(0.02)
#         pass
    
    def get_time(self):
        return int(dt.datetime.now().timestamp() * 1000)
    
    def create_synthetic_sensor_message(self, badge_id, sensor_type, trace_names, t=None, val_dict=None):
        if t is None:
            t = dt.datetime.now().timestamp() * 1000

        message = {}

        header = {}
        header["message-type"] = "sensor-message"
        header["badge-id"] = badge_id
        header["channel"] = "data-message"
        header["timestamps"] = [{"process": "synthetic-sensor", "location": "generation", "t": t}]
        message["header"] = header

        metadata = {}
        metadata["sensor-type"] = sensor_type
        metadata["ring"] = 2
        message["metadata"] = metadata
        

        payload = {}
        payload["t"] = t

        if val_dict:
            payload["vals"] = [val_dict]

        else:
            payload["vals"] = []
            
            for i in range(len(trace_names)):
                payload["vals"].append({trace_names[i]: math.sin(t / 550 + 5 * i) + math.sin(t) / 20})

        message["payload"] = payload

        return message
    
    # to get stress rating: stress_rating_message["payload"]["vals"][0]["stress-rating"]
    def create_stress_rating_message(self, badge_id, serial):
        print("create_stress_rating...()")
        
        t = self.get_time()

        message = {}

        header = {}
        header["message-type"] = "self-report"
        header["badge-id"] = badge_id
        header["channel"] = "data-message"
        header["timestamps"] = [{"process": "stress-detection-app", "location": "generation", "t": t}]
        header["ring"] = 1
        message["header"] = header

        metadata = {}
        metadata["self-report-type"] = "stress-rating"
        metadata["serial"] = serial
        message["metadata"] = metadata

        payload = {}
        payload["t"] = t
        payload["vals"] = [{"stress-rating": random.randint(0, 100)}]
        message["payload"] = payload
        
        print("returning stress rating message")

        return message
            
    def print_message(self, message):
        print(message)
      
    def set_disconnect_callback(self, disconnect_callback):
        """
        Sets a callback function to be called when the server-client connection ends
        """
        self.disconnect_callback = disconnect_callback
        
    def stop_me(self):
        print("Stopping generator thread")
        self.stop_sensor_readings()
        
        print("Shutting down connection to " + self.ip)
        sys.stdout.flush()
        
        self.stopped = True
        
    def _authenticate(self, sock, pertains_to_list=None):
        """
        Authenticates the user by performing a handshake with the data collection server.
        
        If it fails, it will raise an appropriate exception.
        """
        message = sock.recv(256).strip()

        print("Received handshake.  Responding...")
        sys.stdout.flush()

        import json
        prompt = json.loads(message)

        prompt["type"] = "shibboleth"
        prompt["response-version"] =  "2.0"
        prompt["badge-id"] = self.user_id
        prompt["process-type"] = "field-device"
        
        if pertains_to_list:
            prompt["pertains-to"] = pertains_to_list

        prompt_str = json.dumps(prompt) + "\n"
        
        sock.send(prompt_str.encode())
    
        message = sock.recv(256).strip()
        sys.stdout.flush()

