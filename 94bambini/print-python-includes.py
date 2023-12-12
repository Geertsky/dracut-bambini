#!/usr/bin/python3
#excludes is a list or regexps to exclude
excludes=['^/home']
import os,sys,re
for P in sys.path:
    for R in excludes:
        if not re.search(R,P):
            if os.path.exists(P):
                print(P)
