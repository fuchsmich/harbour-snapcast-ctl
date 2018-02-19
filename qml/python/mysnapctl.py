#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import asyncio
import pyotherside


import snapcast.control


def OnConnected():
    pyotherside.send('log', "connected!")

def OnDisconnected():
    pyotherside.send('log', "disconnected!")


pyotherside.send('log', sys.version)
snapserver = snapcast.control.Snapserver('localhost', snapcast.control.CONTROL_PORT)
snapserver.set_on_connect_callback(OnConnected)
snapserver.set_on_disconnect_callback(OnDisconnected)

