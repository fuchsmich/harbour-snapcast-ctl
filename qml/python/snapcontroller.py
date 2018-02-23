#!/usr/bin/python3

import sys
import asyncio
import pyotherside

from snapcast.control.server import Snapserver, CONTROL_PORT
from snapcast.control import create_server

#for mon
import signal
import functools

#for ReaderThread
import threading

def log(string):
    pyotherside.send('log', string)

class SnapController(object):

    def _run(self, coro):
        return self._loop.run_until_complete(coro)

    def __init__(self, host="127.0.0.1", port=CONTROL_PORT):
        self._host = host
        self._port = port
        log('connecting to snapserver on {}:{}'.format(self._host, self._port))

        self._loop = asyncio.get_event_loop()
        reconnect = True
        self.server = self._run(create_server(self._loop, self._host, self._port))
        self.server.set_on_connect_callback(self.onServerConnect)
        self.server.set_new_client_callback(self.onClientConnect)
        self.server.start()


    def onServerConnect(self):
        log('Server connected! {}:{}'.format(self._host, self._port))

    def onClientConnect(self, client):
        log('log', 'client {} connected'.format(client.friendly_name))

    def test(self):
        log(self.server.version)
        log(len(self.server.clients))
        log(len(self.server.groups))
        log(len(self.server.streams))
        log(self._loop.is_running())


#def serverStatus():
#    pyotherside.send('log', "heast!!", isinstance(controller, SnapController))
#    pyotherside.send('log', controller._loop.is_running())
#    controller.serverStatus()


#controller = SnapController()
#controller.serverStatus()
#serverStatus()
#controller.test()

def getServerStatus():
    log("getting server status")
    pyotherside.send('serverStatus', _run(snapserver.status()))

def _run(coro):
    return loop.run_until_complete(coro)


class ReaderThread(threading.Thread):
    def __init__(self, snapserver, stop_event):
        super(ReaderThread, self).__init__()
        self.tn = tn
        self.stop_event = stop_event

    def run(self):
        while (not self.stop_event.is_set()):
            response = self.tn.read_until("\r\n", 2)
            if response:
                print("received: " + response)
                jresponse = json.loads(response)
                print(json.dumps(jresponse, indent=2))
                print("\r\n")

#eigener Thread für Monitor???
def connect():
    
    def shutdown(signame):
        for task in asyncio.Task.all_tasks():
            task.cancel()

    def OnGroupUpdate(group):
        log("Zone '%s' playing" %(group.friendly_name))

    def OnNewClient(client):
        client.set_callback(OnClientUpdate)
        log('new client {}'.format(client.friendly_name))

    def OnClientUpdate(client):
        log('client {} updated'.format(client.friendly_name))

    def OnConnectedToServer():
        pyotherside.send('connected', True)
        getServerStatus()
        for client in snapserver.clients:
            client.set_callback(OnClientUpdate)
        for group in snapserver.groups:
            group.set_callback(OnGroupUpdate)
        snapserver.set_new_client_callback(OnNewClient)

    def OnDisconnectedFromServer():
        pyotherside.send('connected', False)


    @asyncio.coroutine
    def run_status(loop, snapserver):
        while True:
            yield from asyncio.sleep(1)


    port = CONTROL_PORT
    server = '127.0.0.1'
    #server = 'lemonpi'

    log("Connecting to %s port %d" %(server, port))
    global loop
    loop = asyncio.get_event_loop()

    for signame in ('SIGINT', 'SIGTERM'):
        loop.add_signal_handler(getattr(signal, signame), functools.partial(shutdown, signame))

    try:
        global snapserver
        snapserver = _run(create_server(loop, server, port))

    except OSError:
        log("Can't connect to %s:%d" %(server, port))
        OnDisconnectedFromServer()
        return

    OnConnectedToServer()

    try:
        loop.run_until_complete(run_status(loop, snapserver))

    except asyncio.CancelledError:
        pass

    log("Exiting!?")
    OnDisconnectedFromServer()
    loop.close()
