#!/usr/bin/env bash

BASE="$(dirname $0)"
CODE=0

cp $BASE/curl.orig.exe $BASE/curl.tmp.exe

function assertEqual() {
    if [[ "$1" == "$2" ]]; then
        echo "ok - $3"
    else
        echo "not ok - $1 != $2 ($3)"
        CODE=1
    fi
}

echo "# test windowsign"

VAL="$(chktrust $BASE/curl.tmp.exe | grep ERROR)"
assertEqual "$VAL" "ERROR! curl.tmp.exe doesn't contain a digital signature!" "unsigned exe"

VAL="$($BASE/../windowsign)"
assertEqual "$VAL" "Usage: N=<name> I=<info> P=<pw> SPC=<spc file> PVK=<pvk file> windowsign <file.exe>" "shows usage"

VAL="$(N=testing I=http://www.example.com P=testing SPC=$BASE/testing.spc PVK=$BASE/testing.pvk $BASE/../windowsign $BASE/curl.tmp.exe)"
assertEqual "$VAL" "Signed $BASE/curl.tmp.exe" "signs exe"

VAL="$(chktrust $BASE/curl.tmp.exe | grep ERROR)"
assertEqual "$VAL" "ERROR! curl.tmp.exe use an unsupported hash algorithm. Verification is impossible!" "signed but chktrust can't verify sha1 (dumb)"

# cleanup
rm -f $BASE/curl.tmp.exe $BASE/curl.tmp.exe.bak

exit $CODE
