#!/usr/bin/python

data = []

def iterator(f):
    for line in f.readlines():
        data.append(line.split(":")[0])
    data.sort();
    for item in data:
        print "- " + item ,


with open("/etc/group","r") as f:
    print "\n* GROUPS *"
    iterator(f);
    print

with open("/etc/passwd","r") as f:
    print "\n* USERS *"
    iterator(f);
