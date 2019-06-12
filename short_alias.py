##########################################################
# Python3 script for creating aliases inspired by jhchilds.
# Overwrites duplicates, otherwise appends
#
# For best results make a shortcut for python3 <path>/short_alias.py
# Last modified by Jonah Rubin 6/12/2019
#
# input: alias, cmd
#
# issues: selectively hangs on to arg1 between calls (rare)
##########################################################

import sys
import os

#must use os for hidden file, bash_profile
def write_to_bash_profile(alias,cmd):

    overwrite = False

    with open(os.path.expanduser('~/.bash_profile'),'r') as f:
        data = f.readlines()

    to_write = []

    for line in data:
        if line.split(" ")[0] == "alias":

            #if currently selected alias == input alias, overwrite
            if line.split(" ")[1].split("=")[0] == alias:
                overwrite = True
                sys.stdout.write('\nOverwriting previous cmd to: ')
                line = "alias " + alias + "='" + cmd + "'\n"
                sys.stdout.write(line + "\n")

        to_write.append(line)

    #if alias already contained
    if overwrite:
        with open(os.path.expanduser('~/.bash_profile'),'w') as f:
            f.writelines(to_write)
    else:
        with open(os.path.expanduser('~/.bash_profile'), 'a+') as f:
            line = "alias " + alias + "='" + cmd + "'"
            f.write("\n" + line)
            sys.stdout.write("updated bash_profile with: " + line + "\n")


def _main_():
    #user defined alias
    alias = sys.argv[1]
    cmd = sys.argv[2]

    write_to_bash_profile(alias,cmd)


_main_()
