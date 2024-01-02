#!/bin/bash

set -x


if [ $# -eq 2 ]; then

    odin build src -out:soroban.bin -o:speed -reloc-mode:static && echo "OK"

elif [ $# -eq 1 ]; then

    odin build src -debug -out:soroban.bin && echo "OK"
else

    odin build src -out:soroban.bin && echo "OK"

fi
