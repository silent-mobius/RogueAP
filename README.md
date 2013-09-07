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
