#!/bin/sh

usage()
{

echo "Usage:      "${0##*/}" [-d day -m month -y year] [-p processname] [-P port] [-r protocol]

OPTIONS:
   -d   day
   -m   month
   -y   year
   -p   Name of OSX Process to block, default is all
   -P   Port # to block
   -r   Protocol o block (6 = IP)
   -?   List this help page"
}

DAY=""
MONTH=""
YEAR=""

#block mail only
PROCESS="/Applications/Mail.app/Contents/MacOS/Mail
via: /System/Library/Frameworks/WebKit.framework/Versions/A/XPCServices/com.apple.WebKit.WebContent.xpc/Contents/MacOS/com.apple.WebKit.WebContent"
PORT=80
PROTOCOL=6

#block any access
PROCESS="any"
PORT="any"
PROTOCOL="any"



while getopts “p:P:r:d:m:y:?” OPTION
do
     case $OPTION in
         p)
           PROCESS=$OPTARG 
           ;;
        P)
           PORT=$OPTARG 
           ;;
        r)
           PROTOCOL=$OPTARG 
           ;;
        d)
           DAY=$OPTARG
           ;;
        m)
           MONTH=$OPTARG
           ;;
        y)
           if [ $OPTARG -lt 100 ]
           then
              let YEAR=$OPTARG+2000
           else
              YEAR=$OPTARG
           fi
           ;;
        ?)
           usage
           exit
           ;;
     esac
done

if [ -n "$DAY" ]
then
   STARTDATE=`date -j -f "%Y%m%d" "$YEAR$MONTH$DAY"`
   COMMENT="From http://pgl.yoyo.org/adservers/ - start date $STARTDATE"
else
   COMMENT="From http://pgl.yoyo.org/adservers/"
fi

RULES=`curl -fs "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=one-line&showintro=0&startdate%5Bday%5D=$DAY&startdate%5Bmonth%5D=$MONTH&startdate%5Byear%5D=$YEAR&mimetype=plaintext" | grep -v \#`
DATE=`curl -fs "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&startdate%5Bday%5D=&startdate%5Bmonth%5D=&startdate%5Byear%5D=" | grep "# last updated:"`
ENTRIES=`curl -fs "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&startdate%5Bday%5D=&startdate%5Bmonth%5D=&startdate%5Byear%5D=" | grep "entries"`

echo "# Ad server hostnames for the Little Snitch Mac OSX applications
#
# For more information about this list, see: http://pgl.yoyo.org/adservers/
# ----
$DATE
$ENTRIES
# format:         little-snitch
# credits:        Peter Lowe - pgl@yoyo.org - http://pgl.yoyo.org/ - https://twitter.com/pgl
# this URL:       http://pgl.yoyo.org/adservers/serverlist.php?hostformat=one-line&showintro=1&mimetype=plaintext
# other formats:  http://pgl.yoyo.org/adservers/formats.php
# policy:         http://pgl.yoyo.org/adservers/policy.php
#"
if [ -n "$DAY" ]
then
   echo "# start date:    $STARTDATE"
fi
echo ""

for RULE in $(echo $RULES | tr "," "\n")
do
  echo "
action: deny
direction: outgoing
process: $PROCESS
owner: me
destination: $RULE
port: $PORT
protocol: $PROTOCOL
help: $COMMENT
"
done

exit
