
Background
==========
* create very simple and fast lxc container

Benefits of Goal Setting
========================
* rapid lxc deployment

WARNING
=======

Dependencies
============
* Linux (Debian)
   * ZFS on Linux
   * zfs parent dataset: "rpool"
   * jessie systemd-sysv lxc template
      * zfs snapshot "rpool/jessie@_0000_DEFAULT"
   * lxc
   * screen

Features
========
* create:
   * zfs clone jessie/systemd template dataset
   * change config values rpool/lxc-container/NEWLXC/config (name,mac address)
   * randomized eth0 mac address inside the lxc container
   * change lxc container hostname
   * starting screen session for the lxc container

* delete:
   * destroy the zfs clone
   * remove old sym.links (/var/lib/lxc) (/lxc-container)

Platform
========
* Linux (Debian 8/jessie)

Usage
=====
```
    # lxc-fancy       
 
    usage: lxc-fancy.sh { create | delete }
```

Example
=======
* lxc-fancy create
```
# lxc-fancy create
Please enter the new LXC Container name: 
test1
 
Do you wish to start this LXC Container: test1 ? (y/n) y

... starting screen session ...
        21110.test1     (04/11/15 06:39:37)     (Detached)
 
That's it
```

* lxc-fancy delete
```
# lxc-fancy delete
Please enter the LXC Container name: 
test1
 
... shutdown & delete the lxc container ...
 
That's it
```

Diagram
=======

Screencast
==========

Errata
======
* 11.04.2015 : 

TODO
====

