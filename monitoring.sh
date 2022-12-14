#!/bin/bash
architecture=$(uname -a)
CPU_physical=$(cat /proc/cpuinfo | grep "physical id" | uniq | wc -l)
vCPU=$(cat /proc/cpuinfo | grep processor | wc -l)
mem_usage=$(free --mega | awk '/Mem/ {printf("%d/%dMB (%.1f%%)\n", $3, $2, (100 * $3/$2))}')
disk_usage=$(df -B MB --total | awk '/total/ {sub("MB","",$3); sub("MB","",$2); printf("%d/%dMB (%s)\n"), $3, $2, $5}')
cpu_load=$(vmstat | awk '/[0-9]/ {printf("%d%%",100-$15)}')
last_boot=$(who -b | awk '{printf("%s %s\n", $3, $4)}')
if [ "$(lsblk | grep lvm | wc -l)" -gt 0 ]; then lmv_use="yes"; else lmv_use="no"; fi
connections_TCP=$(netstat --tcp | grep ESTABLISHED | wc -l)" ESTABLISHED"
user_log=$(who | awk '{print $1}' | sort -u | wc -l)
ip=$(ip -o -f inet addr | awk '/enp/ {split($4, array, "/"); print array[1]}')
mac=$(ip link | awk '/ether/ {print $2}')
nr_sudo=$(cat /var/log/sudo/sudo.log | grep COMMAND | wc -l)

wall "
    #Architecture: ${architecture}
    #CPU physical : ${CPU_physical}
    #vCPU : ${vCPU}
    #Memory Usage: ${mem_usage}
    #Disk Usage: ${disk_usage}
    #CPU load: ${cpu_load}
    #Last boot: ${last_boot}
    #LVM use: ${lmv_use}
    #Connections TCP: ${connections_TCP}
    #User log: ${user_log}
    #Network: "IP "${ip}" \("${mac}"\)"
    #Sudo : ${nr_sudo}" cmd"
"
