#!/usr/bin/env python
import sys
import requests
import csv

# usage: python getmicro.py [microcode filename] [google sheet id]
# requires python 3 and requests

microcode_filename = sys.argv[1]
# google sheet needs to be link sharable without any authentication
doc_id = sys.argv[2]
url = f'https://docs.google.com/spreadsheets/d/{doc_id}/export?format=csv'

page = requests.get(url)
cr = csv.reader(page.text.splitlines())
microcode = []
ucode = open(microcode_filename, "w")
for line in cr:
    microcode.append(''.join(line[1:]))
microcode = microcode[1:]

for line in microcode:
    ucode.write(line + '\n')
