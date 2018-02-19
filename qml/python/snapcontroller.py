#!/usr/bin/python3

import sys
import os
import logging
import argparse
import asyncio
import json

import snapcast.control

class SnapController(object):

    def __init__(self, serverstring="127.0.0.1", verbose=0, debug=False):
       self._verbose = verbose
       self._debug = debug

       # Setup logging
       self._log = logging.getLogger('SnapController')
       if self._debug:
          logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)

       # Parse the server string
       try:
          self._host, self._port = serverstring.split(':')

       except ValueError:
          self._host = serverstring
          self._port = snapcast.control.CONTROL_PORT

       else:
          self._port   = int(self._port)

       self._log.info('connecting to snapserver on %s:%s', self._host, self._port)

       self._loop = asyncio.get_event_loop()
       self._snapserver = self._loop.run_until_complete(self._update_status())

    # Client information
    def showClient(self, client, multiline=True):
       if(type(client) is str):
          client = self._clientByNameOrId(client)

       clientname = getdefault(client.name, '-noname-')
       groupname = getdefault(client.group.name, '-noname-')

       if multiline or self._verbose:
          print('Client ID  : %s' %(client.identifier))
          print('   name    : %s' %(clientname))
          print('   host    : %s' %(client.hostname))
          print('   group   : %s' %(groupname))
          print('   muted   : %s' %(client.muted))
          print('   online  : %s' %(client.connected))
          print()

       elif client.connected:
          print('%s (%s)' %(clientname, groupname))

    def showAllClients(self):
        for client in self._snapserver.clients:
            self.showClient(client, multiline=False)

controller = SnapController()
controller.showAllClients()
