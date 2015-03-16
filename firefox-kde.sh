#!/bin/bash

ACTIVITY=$(qdbus org.kde.kactivitymanagerd /ActivityManager/Activities CurrentActivity)
FF_FOLDER="$HOME/.mozilla/firefox"
PROFDIR="$FF_FOLDER/$ACTIVITY"

if [ -d $FF_FOLDER/$ACTIVITY ]; then
	echo "loading profile $ACTIVITY"
else
	echo "creating new profile for $ACTIVITY"
	# this seems to be currently broken in FF 36.0.1.. You'll probably have to create the profile manually..
        firefox -CreateProfile "$ACTIVITY $PROFDIR"
	echo $?
fi

while [ ! -d $FF_FOLDER/$ACTIVITY ]; do
	sleep 0.1
done

url="http://www.google.com#q=$1"
if [[ "$1" == "http://"* ]]; then
	url=$1
elif [[ "$1" == "https://"* ]]; then
	url=$1
elif [[ "$1" == "www."* ]]; then
	url="http://$1"
elif [[ "$1" == "/"* ]]; then
	url="file://$1"
fi

firefox -P $ACTIVITY -remote "ping()" &> /dev/null
p=$?
if [ $p == 0 ]; then # profile already open
	# kdialog --msgbox "/usr/bin/firefox -P $ACTIVITY -remote \"openURL($url,new-tab)\""
	/usr/bin/firefox -P $ACTIVITY -remote "openURL($url,new-tab)" &> /tmp/firefox-kde.log
else # open new instance
	# kdialog --msgbox "/usr/bin/firefox -P $ACTIVITY -new-instance $url"
	/usr/bin/firefox -P $ACTIVITY -new-instance $ur &> /tmp/firefox-kde.log
fi

