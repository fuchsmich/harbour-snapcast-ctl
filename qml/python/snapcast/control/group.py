"""Snapcast group."""

import logging


_LOGGER = logging.getLogger(__name__)


class Snapgroup(object):
    """Represents a snapcast group."""

    def __init__(self, server, data):
        """Initialize."""
        self._server = server
        self._callback_func = None
        self.update(data)

    def update(self, data):
        """Update group."""
        self._group = data

    @property
    def identifier(self):
        """Get group identifier."""
        return self._group.get('id')

    @property
    def name(self):
        """Get group name."""
        return self._group.get('name')

    @property
    def stream(self):
        """Get stream identifier."""
        return self._group.get('stream_id')

    def set_stream(self, stream_id):
        """Set group stream."""
        self._group['stream_id'] = stream_id
        yield from self._server.group_stream(self.identifier, stream_id)
        _LOGGER.info('set stream to %s on %s', stream_id, self.friendly_name)

    @property
    def stream_status(self):
        """Get stream status."""
        return self._server.stream(self.stream).status

    @property
    def muted(self):
        """Get mute status."""
        return self._group.get('muted')

    def set_muted(self, status):
        """Set group mute status."""
        self._group['muted'] = status
        yield from self._server.group_mute(self.identifier, status)
        _LOGGER.info('set muted to %s on %s', status, self.friendly_name)

    @property
    def volume(self):
        """Get volume."""
        volume_sum = 0
        for client in self._group.get('clients'):
            volume_sum += self._server.client(client.get('id')).volume
        return int(volume_sum / len(self._group.get('clients')))

    def set_volume(self, volume):
        """Set volume."""
        volume_sum = 0
        for data in self._group.get('clients'):
            volume_sum += self._server.client(data.get('id')).volume
        avg_volume = int(volume_sum / len(self._group.get('clients')))
        for data in self._group.get('clients'):
            client = self._server.client(data.get('id'))
            yield from client.set_volume(volume)
            client.update_volume({
                'volume': {
                    'percent': volume,
                    'muted': client.muted
                }
            })
        _LOGGER.info('set volume to %s on clients in %s', avg_volume, self.friendly_name)

    @property
    def friendly_name(self):
        """Get friendly name."""
        return self.name if self.name != '' else self.stream

    @property
    def clients(self):
        """Get client identifiers."""
        return [client.get('id') for client in self._group.get('clients')]

    def add_client(self, client_identifier):
        """Add a client."""
        if client_identifier in self.clients:
            _LOGGER.error('%s already in group %s', client_identifier, self.identifier)
            return
        new_clients = self.clients
        new_clients.append(client_identifier)
        yield from self._server.group_clients(self.identifier, new_clients)
        _LOGGER.info('added %s to %s', client_identifier, self.identifier)
        self._server.client(client_identifier).callback()
        self.callback()

    def remove_client(self, client_identifier):
        """Remove a client."""
        new_clients = self.clients
        new_clients.remove(client_identifier)
        yield from self._server.group_clients(self.identifier, new_clients)
        _LOGGER.info('removed %s from %s', client_identifier, self.identifier)
        self._server.client(client_identifier).callback()
        self.callback()

    def streams_by_name(self):
        """Get available stream objects by name."""
        return {stream.friendly_name: stream for stream in self._server.streams}

    def update_mute(self, data):
        """Update mute."""
        self._group['muted'] = data['mute']
        self.callback()
        _LOGGER.info('updated mute on %s', self.friendly_name)

    def update_stream(self, data):
        """Update stream."""
        self._group['stream_id'] = data['stream_id']
        self.callback()
        _LOGGER.info('updated stream to %s on %s', self.stream, self.friendly_name)

    def callback(self):
        """Run callback."""
        if self._callback_func and callable(self._callback_func):
            self._callback_func(self)

    def set_callback(self, func):
        """Set callback."""
        self._callback_func = func

    def __repr__(self):
        """String representation."""
        return 'Snapgroup ({}, {})'.format(self.friendly_name, self.identifier)