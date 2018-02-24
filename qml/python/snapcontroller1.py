#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import telnetlib
import json
import threading
import time
import pyotherside


def log(string):
    pyotherside.send('log', string)


class ReaderThread(threading.Thread):
    def __init__(self, tn, stop_event):
        super(ReaderThread, self).__init__()
        self.tn = tn
        self.stop_event = stop_event

    def run(self):
        while (not self.stop_event.is_set()):
            response = self.tn.read_until(b"\r\n", 2).decode('ascii')
            if response:
                #log("received: " + response)
                #jresponse = json.loads(response)
                #log(json.dumps(jresponse, indent=2))
                pyotherside.send('response', response)


def doRequest( str ):
    pyotherside.send('log', "sending: " + str)
    str = str + "\r\n"
    try:
        telnet.write(str.encode('ascii'))
    except IOError:
        log("Couldn't write")
        pyotherside.send('connected', False)

    time.sleep(1)
    return;

def connect(host, port):
    global telnet, t_stop, t
    try:
        telnet = telnetlib.Telnet(host, port)
    except IOError:
        pyotherside.send('connected', False)
        pyotherside.send('log', "Connection failed.")
        exit

    t_stop = threading.Event()
    t = ReaderThread(telnet, t_stop)
    t.start()
    pyotherside.send('connected', True)

def test():
    doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Server.GetStatus\", \"id\": 1}")
    s = input("")
    print(s)

def dest():
    t_stop.set();
    t.join()
    telnet.close

pyotherside.send('log', sys.version)

'''
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetStream\", \"params\": {\"client\": \"a0:b4:a5:3a:f1:db\", \"id\": \"file:///home/johannes/Musik/AnetteLouisiane.wav\"}, \"id\": 3}\r\n")
time.sleep(5)
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetStream\", \"params\": {\"client\": \"a0:b4:a5:3a:f1:db\", \"id\": \"pipe:///tmp/snapfifo\"}, \"id\": 3}\r\n")
time.sleep(5)
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetStream\", \"params\": {\"client\": \"a0:b4:a5:3a:f1:db\", \"id\": \"file:///home/johannes/Musik/AnetteLouisiane.wav\"}, \"id\": 3}\r\n")
time.sleep(5)
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetStream\", \"params\": {\"client\": \"00:21:6a:7d:74:fc\", \"id\": \"pipe:///tmp/snapfifo\"}, \"id\": 3}\r\n")
time.sleep(5)
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetStream\", \"params\": {\"client\": \"00:21:6a:7d:74:fc\", \"id\": \"file:///home/johannes/Musik/AnetteLouisiane.wav\"}, \"id\": 3}\r\n")
time.sleep(5)
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetStream\", \"params\": {\"client\": \"00:21:6a:7d:74:fc\", \"id\": \"pipe:///tmp/snapfifo\"}, \"id\": 3}\r\n")
time.sleep(5)
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetStream\", \"params\": {\"client\": \"00:21:6a:7d:74:fc\", \"id\": \"pipe:///tmp/snapfifo1\"}, \"id\": 3}\r\n")
time.sleep(5)
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetStream\", \"params\": {\"client\": \"00:21:6a:7d:74:fc\", \"id\": \"pipe:///tmp/snapfifo\"}, \"id\": 3}\r\n")
time.sleep(5)


#doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Server.GetStatus\", \"params\": {\"client\": \"80:1f:02:ed:fd:e0\"}, \"id\": 2}\r\n")

doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetVolume\", \"params\": {\"client\": \"80:1f:02:ed:fd:e0\", \"volume\": 10}, \"id\": 3}\r\n")
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetVolume\", \"params\": {\"client\": \"80:1f:02:ed:fd:e0\", \"volume\": 30}, \"id\": 4}\r\n")
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetVolume\", \"params\": {\"client\": \"80:1f:02:ed:fd:e0\", \"volume\": 50}, \"id\": 5}\r\n")
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetVolume\", \"params\": {\"client\": \"80:1f:02:ed:fd:e0\", \"volume\": 70}, \"id\": 6}\r\n")
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetMute\", \"params\": {\"client\": \"80:1f:02:ed:fd:e0\", \"mute\": true}, \"id\": 9}\r\n")
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetMute\", \"params\": {\"client\": \"80:1f:02:ed:fd:e0\", \"mute\": false}, \"id\": 9}\r\n")
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetMute\", \"params\": {\"client\": \"80:1f:02:ed:fd:e0\", \"mute\": true}, \"id\": 9}\r\n")
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetMute\", \"params\": {\"client\": \"80:1f:02:ed:fd:e0\", \"mute\": false}, \"id\": 9}\r\n")
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetLatency\", \"params\": {\"client\": \"80:1f:02:ed:fd:e0\", \"latency\": 0}, \"id\": 7}\r\n")
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetName\", \"params\": {\"client\": \"80:1f:02:ed:fd:e0\", \"name\": \"T400\"}, \"id\": 8}\r\n")
#invalid json
doRequest("some message to test invalid requests\r\n")
#missing id
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetName\", \"params\": {\"client\": \"80:1f:02:ed:fd:e0\", \"name\": \"living room\"}}\r\n")
#missing parameter
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetName\", \"params\": {\"client\": \"80:1f:02:ed:fd:e0\"}, \"id\": 8}\r\n")
#invalid method
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"NonExistingMethod\", \"params\": {\"client\": \"80:1f:02:ed:fd:e0\"}, \"id\": 8}\r\n")
#out of range
doRequest("{\"jsonrpc\": \"2.0\", \"method\": \"Client.SetVolume\", \"params\": {\"client\": \"80:1f:02:ed:fd:e0\", \"volume\": 101}, \"id\": 3}\r\n")
'''
