#!/bin/bash
#Purushothaman K
#Keeps a history of the available free space in mounts

disktracefile=/tmp/disktrace.txt 

df -h | tr -s ' ' | awk -F ' ' '{ print $6,$4}' | while IFS=' ' read -u 3 disk free ;do 

	if grep  -q "^$disk :" "$disktracefile" ;then
		#just add free to disk
		sed -i "\@$disk :@s@\$@ $free@" "$disktracefile"
	else 
		#Append the disk and free space in the report
 		echo "$disk : $free" >> "$disktracefile"
	fi;

done

cat "$disktracefile" | column -t -s" " 
