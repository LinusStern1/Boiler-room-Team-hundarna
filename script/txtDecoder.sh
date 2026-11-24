#!/usr/bin/env bash

# Läser in filen.
qfile="q.txt"
# kontrollera att filen finns.
if [[ ! -r "$qfile" ]]; then
	echo "Error: cannot read '$qfile'" >&2
	exit 1
fi
# Läser in varje rad i filen och dekodar den.
while read -r q; do
	l=${q%%.*}
	s=$(echo "${l:1}" | tr a-z A-Z)
	while [ $(( ${#s} % 8 )) -ne 0 ]; do s="$s="; done
	echo "${l:0:1} $(echo "$s" | base32 -d 2>/dev/null | tr -c 'a-z\n' '.')"
done < "$qfile" > flagga.txt
# sorterar utt den och skriver ut den i terminalen.
sort -n flagga.txt
