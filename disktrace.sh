#!/bin/bash
#Purushothaman K
#Keeps a history of the available free space in mounts

disktracefile=/tmp/disktrace.txt
N=${1-5}  #Default last 5 data will be printed 

(( "$N" < 1 )) && echo "Enter a number > 0" && exit 3

while IFS=' ' read -u 3 disk free ;do 

	if [[ $free == "Avail" ]];then  #Keep the header of df as date
		disk='Date'
		free="`date +'%b%d|%H:%M'`"
	fi

	if grep  -q "^$disk =" "$disktracefile" ;then
		#just add free to disk
		sed -i "\@$disk =@s@\$@ $free@" "$disktracefile"
	else
		#Append the disk and free space in the report
 		echo "$disk = $free" >> "$disktracefile"
	fi;

done 3< <(df -h | tr -s ' ' | awk -F ' ' '{ print $6,$4}' ) 

#print only the collected disks 
#Show only the last N history of the data

paste <( cat "$disktracefile" |  cut -d '=' -f1 ) <( cat "$disktracefile" | cut -d '=' -f 2 |  rev | cut -d' ' -f -${N} | rev ) | column -t -s" "  
