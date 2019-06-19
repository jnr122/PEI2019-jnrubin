##########################################################
# Python3 script for creating aliases inspired by jhchilds.
# Overwrites duplicates, otherwise appends
#
# For best results make a shortcut for python3 <path>/short_alias.py
# Last modified by Jonah Rubin 6/13/2019
#
# input: "<alias>", "<cmd>"
#   Overwrites duplicates, otherwise appends
#
# input: "<alias>"
#   Deletes alias
##########################################################

import sys
import os
from enum import Enum

class Action(Enum):
    ADD = 1
    DELETE = 2

#must use os for hidden file, bash_profile
def edit_bash_profile(alias, cmd, action):

    overwrite = False

    with open(os.path.expanduser('~/.bash_profile'),'r') as f:
        data = f.readlines()

    to_write = []

    for line in data:
        if line.split(" ")[0] == "alias":

            #if currently selected alias == input alias, overwrite or delete
            if line.split(" ")[1].split("=")[0] == alias:
                overwrite = True
                sys.stdout.write('\nOverwriting previous cmd to: ')

                if action == Action.ADD:
                    line = "alias " + alias + "='" + cmd + "'\n"
                elif action == Action.DELETE:
                    line = ""

                sys.stdout.write(line + "\n")
        to_write.append(line)

    if overwrite:
        with open(os.path.expanduser('~/.bash_profile'),'w') as f:
            f.writelines(to_write)
    elif action == action.ADD:
        with open(os.path.expanduser('~/.bash_profile'), 'a+') as f:
            line = "alias " + alias + "='" + cmd + "'"
            f.write("\n" + line)
            sys.stdout.write("updated bash_profile with: " + line + "\n")
    else:
        sys.stdout.write("\nAlias: " + alias + " not found\n")



def _main_():

    # delete
    if len(sys.argv) == 2:
        alias = sys.argv[1]
        cmd = ""
        action = Action.DELETE

    # add/ update
    elif len(sys.argv) == 3:
        alias = sys.argv[1]
        cmd = sys.argv[2]
        action = Action.ADD

    edit_bash_profile(alias, cmd, action)
    sys.stdout.write("#####remember to source#####\n")



_main_()

