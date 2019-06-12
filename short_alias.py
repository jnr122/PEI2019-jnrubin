#Python3 script for creating aliases inspired by jhchilds
#Last modified by Jonah Rubin 6/12/2019
#
#Best use is to make a shortcut for python3 <path>/short_alias.py
#input: alias, command

import sys
import os

#must use os for hidden file, bash_profile
def write_to_bash_profile(alias,cmd):
    with open(os.path.expanduser('~/.bash_profile'),'a+') as f:
        f.write("\nalias " + alias + "='" + cmd + "'")


def _main_():
    #user defined alias
    alias = sys.argv[1]
    cmd = sys.argv[2]

    write_to_bash_profile(alias,cmd)
    print("Update the bash_profile with source command")

_main_()
