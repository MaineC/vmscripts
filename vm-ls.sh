#!/bin/bash -ue
#
# 'vmscripts' low-level VM management scripts - active VMs listing
#
# Copyright © 2015 Thilo Fromm. Released under the terms of the GNU GLP v3.
#
#    vmscripts is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    vmscripts is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with vmscripts. If not, see <http://www.gnu.org/licenses/>.#
#


usage() {
    echo " Usage:"
    echo "    vm ls [-a]  - List VMs. '-a' limits the list to active VMs."
    echo
    exit 1
}
# ----

vm_ls_active() {
    local line=""
    for line in $(screen -ls | grep '\-vmscripts' | awk '{print $1}'); do
        echo "${line/-vmscripts/}" | sed 's/[0-9]\+\.//g'
    done

}
# ----

vm_ls() {
    if [ "${1-}" = "-a" ] ; then
        vm_ls_active
        return
    fi

    local active="$(vm_ls_active)"
    local line=""
    for name in $(ls -1 "$VM_CONFIG_PATH/") ; do
        [ ! -d "$VM_CONFIG_PATH/$name" ] && continue
        local a=""
        if echo "$active" | grep -qw "$name"; then
            a="(active)"
        fi
        printf "%30s %20s\n" "$name" "$a"
    done
}
# ----

if [ `basename "$0"` = "vm-ls.sh" ] ; then
    [ "${vm_tools_initialized-NO}" != "YES" ] && {
        exec $(which vm) "ls" $@
        exit 1; }
    vm_ls $@
else
    true
fi
