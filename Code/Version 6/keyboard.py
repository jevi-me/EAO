#!/usr/bin/python
# -*- coding: utf-8 -*-
# https://stackoverflow.com/questions/24072790/how-to-detect-key-presses
# https://www.rapidtables.com/code/text/ascii-table.html?viewsel=on

import sys, tty, os, termios, subprocess, argparse
from signal import pause
from pythonosc import osc_message_builder
from pythonosc import udp_client
from time import sleep

def getkey():
    old_settings = termios.tcgetattr(sys.stdin)
    tty.setcbreak(sys.stdin.fileno())
    
    try:
        while True:
            b = os.read(sys.stdin.fileno(), 3).decode()
            if len(b) == 3:
                k = ord(b[2])
            else:
                k = ord(b)
            key_mapping = {
                127: 'backspace',
                10: 'return',
                32: 'space',
                9: 'tab',
                27: 'esc',
                65: 'up',
                66: 'down',
                67: 'right',
                68: 'left'
            }
            return key_mapping.get(k, chr(k))
    finally:
        termios.tcsetattr(sys.stdin, termios.TCSADRAIN, old_settings)

def wfi(spip):
    gate = 0.1
    sender = udp_client.SimpleUDPClient(spip, 4560) 
 
    try:
        while True:
            k = getkey()
            if k == 'esc':
                quit()
            else:
                sender.send_message('/key', k)
                print(k)

    except (KeyboardInterrupt, SystemExit):
        os.system('stty sane')
        print('stopping.')

if __name__=="__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--sp", default="10.0.0.240", help="The ip to send on")
    args = parser.parse_args()
    spip = args.sp
    print("Sending to Sonic PI on ip ",spip)
    sleep(2)
    wfi(spip)