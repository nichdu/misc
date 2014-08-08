#!/usr/bin/python
# -*- coding: utf-8 -*-
# Example using a character LCD connected to a Raspberry Pi or BeagleBone Black.
import math
import time

import Adafruit_CharLCD as LCD

import sqlite3 as sql
import sys

# Raspberry Pi pin configuration:
lcd_rs        = 21 # braunes Kabel
lcd_en        = 20 # lila Kabel
lcd_d4        = 26 # blaues Kabel
lcd_d5        = 16 # grünes Kabel
lcd_d6        = 19 # gelbes Kabel
lcd_d7        = 13 # orangefarbenes Kabel
lcd_backlight = 6  # schwarzes Kabel

# Define LCD column and row size for 16x2 LCD.
lcd_columns = 16
lcd_rows    = 2

# Data configuration
db          = '/home/pi/sensoren/sensoren.db'
rows        = [
    { 'table': 'luft', 'name': 'Luft' },
    { 'table': 'wasser', 'name': 'Wasser' }
]

# Initialize the LCD using the pins above.
lcd = LCD.Adafruit_CharLCD(lcd_rs, lcd_en, lcd_d4, lcd_d5, lcd_d6, lcd_d7, 
                            lcd_columns, lcd_rows, lcd_backlight)

def get_value(table):
    global db
    con = None
    try:
        con = sql.connect(db)
        cur = con.cursor()
        cur.execute('SELECT wert FROM %s ORDER BY ts DESC LIMIT 1;' % table)
        # wir haben stets nur eine Row, also können wir fetchone benutzen
        data = cur.fetchone()
        return None if data is None else float(data[0])
    except sql.Error, e:
        print 'Konnte nicht die Daten für %s aus der Datenbank laden: %s' % table, e.args[0]
        sys.exit(1)
    finally:
        if con:
            con.close()

def print_values(values):
    global lcd, lcd_columns, lcd_rows # brauchen wir zum Zusammenbauen des Strings
    # wir bauen uns den String zusammen
    string = ''
    max_strlen = lcd_columns - (5 + 1 + 1 + 1) # Zeilenlänge minus Wert, Doppelpunkt, °C
    for row in values:
        name = row['name'] if len(row['name']) > max_strlen \
            else row['name'][:max_strlen]
        value = '%2.2f' % row['value'] if not row['value'] is None else ' -.--'
        spaces = ' ' * (lcd_columns - (5 + 1 + 1 + 1 + len(name)))
        line = '%s:%s%s%sC\n' % (name, spaces, value, str(unichr(0x6f)))
        string += line
    lcd.clear()
    lcd.message(string)
    for row in range(0, lcd_rows):
        lcd.set_cursor(lcd_columns-2, row)
        lcd.write8(223, True)

def main():
    global rows, lcd_rows
    if len(rows) > lcd_rows:
        print 'Wir sollen mehr Werte ausgeben als es Zeilen gibt. Nicht möglich'
        sys.exit(2)
    values = []
    for row in rows:
        values.append({ 'name': row['name'], 'value': get_value(row['table']) })
    print_values(values)

main()



