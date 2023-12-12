#!/usr/bin/python3
#excludes is a list or regexps to exclude
excludes=['^/home']
import os,sys,re

for P in sys.path:
    RES=True
    for R in excludes:
        if re.search(R,P):
            RES=False
    if RES and os.path.exists(P):
        print(P)
