#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import telnetlib
import json
import threading
import time
import pyotherside

class ReaderThread(threading.Thread):
    def __init__(self, tn, stop_event):
        super(ReaderThread, self).__init__()
        self.tn = tn
        self.stop_event = stop_event

    def run(self):
        while (not self.stop_event.is_set()):
            response = self.tn.read_until(b"\r\n", 2).decode('ascii')
            if response:
                print("received: " + response)
                jresponse = json.loads(response)
                print(json.dumps(jresponse, indent=2))
                print("\r\n")
                pyotherside.send('response', response)

class SnapController():

    def __init__(self):
        self.telnet = telnetlib.Telnet('127.0.0.1', 1705)
        self.t_stop = threading.Event()
        self.t = ReaderThread(self.telnet, self.t_stop)
        self.t.start()

    def __del__(self):
        self.t_stop.set();
        self.t.join()
        self.telnet.close

    def doRequest(self, str):
        pyotherside.send('log', "send: " + str)
        str = str + "\r\n"
        self.telnet.write(str.encode('ascii'))
        time.sleep(1)
        return;


pyotherside.send('log', sys.version)
controller = SnapController()
