RougeAP
===========

Scripts and tools used for running a rogue access point using karma (patched hostapd)

The rouge AP is launched by running rougeAP.sh

Requirements:
karma'd version of hostapd is installed
/lib/wifi/mac80211.sh to have been replaced with mac80211.sh
dhcp-watcher.py to be in the /root/ directory
https://github.com/synap5e/FakeHTTPServers to be installed in /mnt/data/FakeHTTPServers
https://github.com/synap5e/FakeServers to be installed in /mnt/data/FakeServers
status.sh to be copied to /usr/bin/status (and be marked as executable)
tmux, dnsmasq, python, python-twisted, several extra python libraries (list coming)

Extras:

nbsn_server.py:		spoofs responses to netbios queries, this is largely unneeded as dnsmasq is set to respond to all queries.


---
Following imported from some tutorial I was writing

OpenWrt Setup

Change the 'lan' config to being a dhcp client:
Move the curser over the lines after config interface 'lan' and type 'dd' for each one. This deletes the lines. Then type 'i' to use insert mode. Add the lines:

        option proto 'dhcp'
        option ifname 'eth0'
        option gateway '0.0.0.0'
'<esc>:x<enter>' then closes and saves the file. If make a mistake you can exit without saving '<esc>quit!<enter>'. Once done poweroff the router and plug it into a router. It will get an IP address itself and you should be able to SSH in.


Setup log
```
opkg --force-overwrite install hostapd_20111103-3_ar71xx.ipk

opkg update
# read http://wiki.openwrt.org/doc/howto/usb.storage
opkg install kmod-usb-storage block-mount kmod-fs-ext4 kmod-scsi-generic
# edit /etc/config/fstab
config mount
option target /mnt
option device /dev/sda1
option fstype ext3
option options rw,sync,relatime
option enabled 1
option enabled_fsck 0

config swap
option device /dev/sda2
option enabled 1

# Enable packages externally
cd /mnt
mkdir ext-install
vi /etc/opkg.conf
# add "dest mnt /mnt/ext-install"

opkg -d mnt install python twisted python-openssl python-crypto twisted-conch tmux git arpd


#link across
ln -s /mnt/ext-install/lib/* /lib/ln -s /mnt/ext-install/usr/bin/* /usr/bin/ln -s /mnt/ext-install/usr/sbin/* /usr/sbin/mkdir /usr/includeln -s /mnt/ext-install/usr/include/python2.7/ /usr/include/ln -s /mnt/ext-install/usr/lib/* /usr/lib/ln -s /mnt/ext-install/usr/share/terminfo/ /usr/share/ # TODO: fix zope

opkg --force-overwrite install hostapd-karma.ipk
mkdir /etc/hostapd
touch /etc/hostapd/hostapd.deny
touch /etc/hostapd/hostapd.accept

nc 10.0.0.5 6666 > rougeAP.sh
nc 10.0.0.5 6666 > hostapd-karma.conf
nc 10.0.0.5 6666 > dhcp-watcher.py
nc 10.0.0.5 6666 > /usr/bin/status
nc 10.0.0.5 6666 > /lib/wifi/mac80211.sh
chmod +x rougeAP.sh
chmod +x /usr/bin/status
chmod +x /lib/wifi/mac80211.sh
mkdir /etc/flag

# test:
touch /etc/flag/karma
/etc/init.d/network restart
# cat /tmp/dhcp.leases

# grab zope-interface and openssl from somewhere else (any python installation will do)
cp /mnt/data/_/ext-install/usr/lib/python2.7/site-packages/zope/ . -r
cp /mnt/data/_/ext-install/usr/lib/python2.7/site-packages/OpenSSL/ . -r
cp /mnt/data/_/ext-install/usr/lib/python2.7/site-packages/twisted/ . -r
cp /mnt/data/_/ext-install/usr/lib/python2.7/site-packages/pyasn1/ . -r

cd /tmp
git clone git://github.com/seb-m/pyinotify.git
cd pyinotify
python setup.py install
```
