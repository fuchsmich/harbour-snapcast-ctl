#!/usr/bin/python3

import sys
#import os
import asyncio
#import json
import pyotherside

from snapcast.control.server import Snapserver, CONTROL_PORT
from snapcast.control import create_server

#for mon
import signal
import functools

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

    def serverStatus(self):
        pyotherside.send('serverStatus', self._run(self.server.status()))

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


controller = SnapController()
controller.serverStatus()
#serverStatus()
controller.test()


def mon():

    def _run(coro):
        return loop.run_until_complete(coro)

    def run_cmd(loop, server, port):
       return (yield from create_server(loop, server, port))

    def shutdown(signame):
        for task in asyncio.Task.all_tasks():
            task.cancel()

    def OnGroupUpdate(group):
        stream = snapserver.stream(group.stream)
        title = tag(stream.meta,'TITLE', '<unknown>')
        artist = tag(stream.meta,'ARTIST', '<unknown>')
        log("Zone '%s' playing '%s' by '%s'" %(group.friendly_name, title, artist))

    def OnNewClient(client):
        client.set_callback(OnClientUpdate)
        log('new client {}'.format(client.friendly_name))

    def OnClientUpdate(client):
        log('client {} updated'.format(client.friendly_name))

    @asyncio.coroutine
    def run_status(loop, snapserver):
        while True:
            yield from asyncio.sleep(1)


    port = CONTROL_PORT
    server = '127.0.0.1'

    log("Connecting to %s port %d" %(server, port))
    loop = asyncio.get_event_loop()

    for signame in ('SIGINT', 'SIGTERM'):
        loop.add_signal_handler(getattr(signal, signame), functools.partial(shutdown, signame))

    try:
        snapserver = _run(create_server(loop, server, port))
        #loop.run_until_complete(run_cmd(loop, server, port))

    except OSError:
        log("Can't connect to %s:%d" %(server, port))
        return

    for client in snapserver.clients:
        client.set_callback(OnClientUpdate)

    snapserver.set_new_client_callback(OnNewClient)

    log("Connected?")
    status = _run(snapserver.status())
    log(status)

    try:
        loop.run_until_complete(run_status(loop, snapserver))

    except CancelledError:
        pass

    log("Exiting!?")
    loop.close()
