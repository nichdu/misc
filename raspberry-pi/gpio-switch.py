#!/usr/bin/env python

# Copyright 2014 Tjark Saul
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
