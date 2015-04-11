#!/bin/sh

### LICENSE // ###
#
# Copyright (c) 2015, Daniel Plominski (Plominski IT Consulting)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice, this
# list of conditions and the following disclaimer in the documentation and/or
# other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
### // LICENSE ###

### ### ### PLITC // ### ### ###

### stage0 // ###
DEBIAN=$(grep "ID" /etc/os-release | egrep -v "VERSION" | sed 's/ID=//g')
DEBVERSION=$(grep "VERSION_ID" /etc/os-release | sed 's/VERSION_ID=//g' | sed 's/"//g')
MYNAME=$(whoami)
### // stage0 ###

case "$1" in
'create')
### stage1 // ###
case $DEBIAN in
debian)
### stage2 // ###

### // stage2 ###
#
### stage3 // ###
if [ "$MYNAME" = "root" ]; then
   : # dummy
else
   echo "" # dummy
   echo "" # dummy
   echo "[Error] You must be root to run this script"
   exit 1
fi
if [ "$DEBVERSION" = "8" ]; then
   : # dummy
else
   echo "" # dummy
   echo "" # dummy
   echo "[Error] You need Debian 8 (Jessie) Version"
   exit 1
fi

#
### stage4 // ###
#
### ### ### ### ### ### ### ### ###

echo "Please enter the new LXC Container name: "
read LXCNAME

if [ -z "$LXCNAME" ]; then
   echo "ERROR: empty name"
   exit 1
fi

zfs clone rpool/jessie@_0000_DEFAULT rpool/"$LXCNAME"
if [ $? -eq 0 ]
then
   : # dummy
else
   exit 1
fi

sed -i 's/jessie/'"$LXCNAME"'/g' /rpool/"$LXCNAME"/config

RANDOM1=$(shuf -i 10-99 -n 1)
RANDOM2=$(shuf -i 10-99 -n 1)

sed -i 's/aa:bb:01:01:bb:aa/aa:bb:'"$RANDOM1"':'"$RANDOM2"':bb:aa/' /rpool/"$LXCNAME"/config

CHECKMAC1=$(grep "aa:bb" /rpool/"$LXCNAME"/config | sed 's/lxc.network.hwaddr=//')
CHECKMAC2=$(grep -c "$CHECKMAC1" /var/lib/lxc/*/config | egrep -v ":0")
if [ -z "$CHECKMAC2" ]; then
   : # dummy
else
   sed -i 's/aa:bb:01:01:bb:aa/aa:bb:'"$RANDOM1"':'"$RANDOM2"':bb:aa/' /rpool/"$LXCNAME"/config
   echo "try random mac for the second time"
fi

ln -s /rpool/"$LXCNAME" /var/lib/lxc/"$LXCNAME"
ln -s /rpool/"$LXCNAME"/rootfs /lxc-container/"$LXCNAME"

echo "$LXCNAME" > /lxc-container/"$LXCNAME"/etc/hostname

read -p "Do you wish to start this LXC Container: "$LXCNAME" ? (y/n) " LXCSTART
if [ "$LXCSTART" = "y" ]; then
  screen -d -m -S "$LXCNAME" -- lxc-start -n "$LXCNAME"
  echo "... starting screen session ..."
  sleep 2
  screen -x | grep "$LXCNAME"
  echo ""
  echo "That's it"
else
  echo ""
  echo "That's it"
fi

### ### ### ### ### ### ### ### ###
#
### // stage4 ###
#
### // stage3 ###
#
### // stage2 ###
   ;;
*)
   # error 1
   echo "" # dummy
   echo "" # dummy
   echo "[Error] Plattform = unknown"
   exit 1
   ;;
esac
#
### // stage1 ###
;;
'delete')
### stage1 // ###
case $DEBIAN in
debian)
### stage2 // ###

### // stage2 ###
#
### stage3 // ###
if [ "$MYNAME" = "root" ]; then
   : # dummy
else
   echo "" # dummy
   echo "" # dummy
   echo "[Error] You must be root to run this script"
   exit 1
fi
if [ "$DEBVERSION" = "8" ]; then
   : # dummy
else
   echo "" # dummy
   echo "" # dummy
   echo "[Error] You need Debian 8 (Jessie) Version"
   exit 1
fi

#
### stage4 // ###
#
### ### ### ### ### ### ### ### ###

echo "Please enter the LXC Ccontainer name: "
read LXCNAME

if [ -z "$LXCNAME" ]; then
   echo "ERROR: empty name"
   exit 1
fi

LXCDELETE=$(zfs list rpool/"$LXCNAME")
if [ -z "$LXCDELETE" ]; then
   echo "ERROR: can't find lxc container"
   exit 1
fi

echo ""
echo "... shutdown & delete the lxc container ..."
lxc-stop -n "$LXCNAME" > /dev/null 2>&1

rm -f /lxc-container/"$LXCNAME"
rm -f /var/lib/lxc/"$LXCNAME"

zfs destroy rpool/"$LXCNAME"

echo ""
echo "That's it"

### ### ### ### ### ### ### ### ###
#
### // stage4 ###
#
### // stage3 ###
#
### // stage2 ###
;;
*)
   # error 1
   echo "" # dummy
   echo "" # dummy
   echo "[Error] Plattform = unknown"
   exit 1
   ;;
esac
#
### // stage1 ###
;;
*)
echo ""
echo "usage: $0 { create | delete }"
;;
esac
exit 0
### ### ### PLITC ### ### ###
# EOF
