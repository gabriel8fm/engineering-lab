#!/usr/bin/env python

import os, subprocess

not_removed = [
"9978113",
"997855",
"9978587",
"9983235",
"9983521",
"9987777",
"9987943",
"9989101",
"9990551",
"9991795",
"9993343",
"9993369",
"9993993",
"9996593",
"9996859",
"9996985",
"9998223",
]

cache = {}
for i in not_removed:
    cache[str(i)] = None

for directory in os.listdir('.'):
    if cache.has_key(directory):
        print('Skipping %s' % directory)
        continue
    #subprocess.Popen('echo %s' % directory, shell=True).wait()
