# Python 2.7 script for autokey-gtk 0.90.4 to ..
# make Mozilla Firefox (firefox-esr) hide and show like Yakuake
#
# Copyright (C) 2020 Sebastian Pipping <sebastian@pipping.org>
# Licensed under GPL v3 or later
#
# Version 2020-03-21 01:21 UTC+1

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
    return int(output.split('\n')[-1])


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


def start_application(app_name, command_basename):
    anounce_about_to('Starting', app_name)
    with_enriched_exeptions(subprocess.call, [command_basename])


def toggle_application(app_name, command_basename, window_name_pattern):
    if does_process_exist(command_basename):
        window_id = get_window_id(window_name_pattern)
        toggle_window(window_id, app_name)
    else:
        start_application(app_name, command_basename)


try:
    toggle_application('Firefox', 'firefox', 'Mozilla Firefox')
except Exception as e:
    announce('ERROR: {}'.format(e))