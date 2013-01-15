sleep 5

rx_old=$(cat /sys/class/net/eth0/statistics/rx_bytes)
tx_old=$(cat /sys/class/net/eth0/statistics/tx_bytes)

while true 
do 
   case "$(xset -q|grep LED| awk '{ print $10 }')" in
     "00000000") KBD="EN" ;;
     "00001004") KBD="\x02HE" ;;
     *) KBD="unknown" ;;
   esac
   rx_now=$(cat /sys/class/net/eth0/statistics/rx_bytes)
   tx_now=$(cat /sys/class/net/eth0/statistics/tx_bytes)
   let rx_rate=($rx_now-$rx_old)/1024
   let tx_rate=($tx_now-$tx_old)/1024

   eval $(awk '/^cpu /{print "cpu_idle_now=" $5 "; cpu_total_now=" $2+$3+$4+$5 }' /proc/stat)
   cpu_interval=$((cpu_total_now-${cpu_total_old:-0}))

   # calculate cpu usage (%)
   let cpu_used="100 * ($cpu_interval - ($cpu_idle_now-${cpu_idle_old:-0})) / $cpu_interval"

   song_info="$(ncmpcpp --now-playing '{{{{%t Ý }%a}}|{%f}}' | head -c 50)"
   if [[ ! $song_info ]]; then
      song_info="Not playing"
   fi
   mem_used="$(free -m | awk '/buffers\/cache/ {print $3}')"
   if [[ $(echo $mem_used " > 1000" | bc) -eq "1" ]]; then
      mem_used=$(echo "\x03"$mem_used)
   fi

   #cpu_temp=$(cat /proc/acpi/ibm/thermal | awk '{printf("\x04 cpu: "$3"*"$4" ")}') 

   root_vol=$(df -h / | awk 'END {printf($5)}' | sed 's/Use%//') 
   if [[ $(echo $(echo $root_vol | cut -c 1-2) " > 80" | bc) -eq "1" ]]; then
      root_vol=$(echo "\x03"$root_vol)
   fi

   #home_vol=$(df -h /home| awk 'END {printf("\x01home: "$5)}' | sed 's/Use%//') 

   vol="$(amixer get PCM | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"
   if [[ $(echo $vol " > 80" | bc) -eq "1" ]]; then
      vol=$(echo "\x02"$vol)
   fi

   rx_prate="$(printf "%-13b" "${rx_rate}K")"
   tx_prate="$(printf "%-12b" "${tx_rate}K")"

   if [[ $(echo $cpu_used " > 50" | bc) -eq "1" ]]; then
      cpu_pused="$(printf "\x03%-12b" "${cpu_used}%")"
   else
      cpu_pused="$(printf "%-12b" "${cpu_used}%")"
   fi

   date="$(date "+%a %d %b %H:%M")"
   taskbar_info=$(echo -e "rx" $rx_prate "| tx" $tx_prate "| cpu" $cpu_pused "\x01| mem" $mem_used"Mb\x01" "|" $song_info $cpu_temp "| Disk" $root_vol "\x01| VOL" $vol"%\x01" "|\x02" $date "\x01" $uptime "|"  $KBD) 
   xsetroot -name "$taskbar_info" 

   # reset old rates
   rx_old=$rx_now
   tx_old=$tx_now
   cpu_idle_old=$cpu_idle_now
   cpu_total_old=$cpu_total_now
   sleep 5
done
