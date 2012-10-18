free=$(free | grep -o "[0-9]*")
r_total=$(echo "$free" | head -n 1)
r_used=$(echo "$free" | head -n 2 | tail -n 1)
s_total=$(echo "$free" | tail -n 3 | head -n 1)
s_used=$(echo "$free" | tail -n 2 | head -n 1)
r_per=$(((r_used * 100)/r_total))
s_per=$(((s_used * 100)/s_total))
s_per_r=$(((s_used * 100)/r_total))

clients=$(cat /tmp/dhcp.leases | grep "." | wc -l)

if [ "$1" = "-c" ] # compact
then echo "| $clients | $r_per%, $s_per_r% | $(uptime | cut -c 36-)"
else echo " $clients DHCP client(s)"
echo " U$(uptime | cut -c 12-)"
echo " Ram usage: $r_per% ( $r_used/$r_total )"
echo " Swap usage: $s_per_r% of ram size, $s_per% of swap size ( $s_used/$s_total )"
fi
