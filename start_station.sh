pid_dir=/tmp/GenTargets/StationPID
if [ ! -d $pid_dir ]; then
  mkdir -p "$pid_dir"
fi

current_pid=$$
station_file=$pid_dir/$1.pid
if [ -e "$station_file" ]; then
    read last_pid <"$station_file"
    kill -s 9 $last_pid
fi

handle_sigint()
{
    rm "$station_file"
}

trap handle_sigint SIGINT

echo $$ >"$station_file"

./start_scanner.sh $@ &>/dev/null

