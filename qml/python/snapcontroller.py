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
        return

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
