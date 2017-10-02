#!/bin/bash
DATE=$(date  +'%Y%m%d%H%M%S');
echo $DATE
exec > >(tee -a speed-${DATE}.log)
exec 2>&1
# SET YOUR OWN
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_101.jdk/Contents/Home
export CLASSPATH=$CLASSPATH:./bin:.
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=/Users/joshualandman/golang
echo "JSON VALIDITY TEST"
CSVParser.py | python -m json.tool
CSVParser.pl | python -m json.tool
go run CSVParser.go | python -m json.tool
node CSVParser.js | python -m json.tool
java CSVParser | python -m json.tool

echo "SPEED TESTS"
printf "Lang python"
time CSVParser.py >/dev/null
printf "Lang perl"
time CSVParser.pl >/dev/null
printf "Lang interpreted-go"
time go run CSVParser.go >/dev/null
printf "Lang compiled-go"
time CSVParser >/dev/null
printf "Lang node"
time node CSVParser.js >/dev/null
printf "Lang java"
time java CSVParser >/dev/null

SPEEDJSON=$(sed -n '/Lang/,$p' speed-${DATE}.log |
awk '{if (NR==1) {printf("{");};if ( (NR)%4==1 ) {
          printf("\n\"%s\":{",$2)}
      else {
        for (i=0;i<3;i++) {
          printf("\"%s\":\"%s\",", $1,$2);
          next;
        }
      }
  }' | sed -e 's/,$/},/'| sed '$ s/.$//'; echo "}");
  echo $SPEEDJSON
  echo "$SPEEDJSON" > speed.json
  python -m SimpleHTTPServer &
  PID=$!
  echo "Python PID: $PID"
  open "http://localhost:8000"
  echo "see results.js, HIT ENTER to kill the server"
  read
  kill -9 $PID
