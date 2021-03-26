
#!/usr/bin/bash
# choose pulseaudio sink via rofi
# changes default sink and moves all streams to that sink

sink=$(ponymix -t sink list|awk '/^sink/ {s=$1" "$2;getline;gsub(/^ +/,"",$0);print s" "$0}'|rofi -theme themes/appsmenu.rasi -dmenu -p 'Audio'|grep -Po '[0-9]+(?=:)') &&

ponymix set-default -d $sink &&
for input in $(ponymix list -t sink-input|grep -Po '[0-9]+(?=:)');do
	echo "$input -> $sink"
	ponymix -t sink-input -d $input move $sink
done
