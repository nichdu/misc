#!/usr/bin/env python

# BEGIN global settings
PIN = 24
COMMAND = "pilight-send -p elro_he -s 31 -u 8 -t"
# END global settings

import RPi.GPIO as GPIO
import time
import os

GPIO.setmode(GPIO.BCM)

GPIO.setup(PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

try:
    while True:
        input_state = GPIO.input(PIN)
        if input_state == False:
            print('Turning on the switch')
            os.system(COMMAND)
            time.sleep(0.2)
finally:
    GPIO.cleanup()
