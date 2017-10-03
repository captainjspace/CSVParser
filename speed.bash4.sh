#!/usr/local/bin/bash
#BASH4
DATE=$(date  +'%Y%m%d%H%M%S');
echo $DATE

#CONSOLE AND FILE APPENDER
exec > >(tee -a speed-${DATE}.log)
exec 2>&1

#DECLARE BEFORE FUNCTIONS
declare -A SPEEDTEST

#FUNCTIONS
function join { local IFS="$1"; shift; echo "$*"; }
function executeTest() {
  L=$1; PRG=$2;
  ${PRG} | python -m json.tool;
  R="FAILED";
  if [[ $? -eq 0 ]]; then
    R="PASSED";
    SPEEDTEST[$L]="$({ time $PRG 1>/dev/null 2>&1; } 2>&1) jsontest:$R"
  fi
  echo $R
  return;
}

# SET YOUR OWN.
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_101.jdk/Contents/Home
export CLASSPATH=$CLASSPATH:./bin:.
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=/Users/joshualandman/golang

#EXECUTE TEST
declare -A -p LANG=([python]=CSVParser.py [perl]=CSVParser.pl [java]="java CSVParser" \
                    [go-run]="go run CSVParser.go" [go-native]=CSVParser);
for i in ${!LANG[*]}; do executeTest $i "${LANG[$i]}"; done;

#FORMAT RESULTS
for i in ${!SPEEDTEST[*]}
do
  TR=(${SPEEDTEST[$i]})
  SPEEDTEST[$i]="\"$i\":{\"${TR[0]}\":\"${TR[1]}\" \"${TR[2]}\":\"${TR[3]}\" \"${TR[4]}\":\"${TR[5]}\"}"
done;
echo "{" $(join , ${SPEEDTEST[@]}) "}" > speed.json
python -m SimpleHTTPServer >> speed-${DATE}.log &
PID=$!
echo "Python PID: $PID"
open "http://localhost:8000"
echo "see results.js, HIT ENTER to kill the server"
read
kill -9 $PID
