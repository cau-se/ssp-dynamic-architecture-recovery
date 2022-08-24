#!/bin/bash

if [ -d "$1" ] ; then
	cd "$1"
fi

if [ ! -f "assembly-model.xmi" ] ; then
	exit
fi

echo "Processing $1"

for I in *.xmi ; do
	cat "$I" | sed 's/href=".*\/\([a-z]*-model.xmi\)/href="\1/g' | sed 's/file://g' > temp
	cat "temp" | sed 's/assemblyOperations/operations/g' | sed 's/assemblyStorages/storages/g' | sed 's/containedOperations/operations/g' | sed 's/containedStorages/storages/g' > "$I"
done

rm temp

# end
