rls_stations=()
while read -r line; do
    read id endline <<<"$line"
    rls_stations+=("${line}")
done < <( ./list_rls_stations.sh )

handle_sigint()
{
    pid_dir=/tmp/GenTargets/StationPID
    for filename in $(ls -t1 "$pid_dir"); do
        pid_file=$pid_dir/$filename
        read last_pid <"$pid_file"
        kill -s 9 $last_pid
    done
    exit 0
}
trap handle_sigint SIGINT

for key in "${!rls_stations[@]}"; do
    ./start_station.sh ${rls_stations[$key]} &
done
disown -a

while true; do 
    #cat /tmp/GenTargets/log 
    #>/tmp/GenTargets/log
    sleep 1
done
