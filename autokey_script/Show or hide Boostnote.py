# Python 3.6 script for autokey-gtk 0.95.10 to ..
# make Boostnote hide and show like Yakuake
#
# Copyright (C) 2020 Sebastian Pipping <sebastian@pipping.org>
# Copyright (C) 2020 Heuna Kim
# Licensed under GPL v3 or later
#
# Version 2020-03-21 01:21 UTC+1
# modified
# - for Boostnote from Firefox
# - for python3 adaptation for debian bullseye by Heuna Kim

import errno
import os
import subprocess


def announce(message):
    with_enriched_exeptions(subprocess.call, ['notify-send', message])


def anounce_about_to(gerund, app_name):
    message = '{} {}...'.format(gerund, app_name)
    announce(message)


def with_enriched_exeptions(func, *popenargs, **argv):
    executable = popenargs[0][0]
    try:
        return func(*popenargs, **argv)
    except OSError as e:
        if e.errno != errno.ENOENT:
            raise
        raise OSError(errno.ENOENT, '{}:\n{}'.format(
                os.strerror(errno.ENOENT), executable))


def get_window_id(window_name_pattern):
    output = with_enriched_exeptions(
            subprocess.check_output,
            ['xdotool', 'search', '--name',
             window_name_pattern]).strip()
    return int(output.decode().split('\n')[-1])


def get_active_window_id():
    return int(with_enriched_exeptions(
            subprocess.check_output,
            ['xdotool', 'getactivewindow']).strip())


def does_process_exist(command_basename):
    return subprocess.call(['pidof', command_basename]) == 0


def is_active_window(window_id):
    return window_id == get_active_window_id()


def toggle_window(window_id, app_name):
    if is_active_window(window_id):
        xdotool_action, gerund = 'windowminimize', 'Iconifying'
    else:
        xdotool_action, gerund = 'windowactivate', 'Activating'

    anounce_about_to(gerund, app_name)
    with_enriched_exeptions(
            subprocess.call,
            ['xdotool', xdotool_action, '--sync', str(window_id)])


def start_application(app_name, command):
    anounce_about_to('Starting', app_name)
    with_enriched_exeptions(subprocess.call, command)


def toggle_application(app_name, window_name_pattern,
                       command_basename, command_args):
    if does_process_exist(command_basename):
        window_id = get_window_id(window_name_pattern)
        toggle_window(window_id, app_name)
    else:
        command = [command_basename] + command_args
        start_application(app_name, command)


try:
    toggle_application('Boost Note', 'Boost Note',
                       'boostnote.next', ['--no-sandbox'])
except Exception as e:
    announce('ERROR: {}'.format(e))
