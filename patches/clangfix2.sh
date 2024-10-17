#!/bin/bash
row1=$(sed -n -e '/^KBUILD_CFLAGS[[:space:]]*:=.*/=' ./Makefile)
touch test2.txt
sed -n -e '/^KBUILD_CFLAGS[[:space:]]*:=.*/,/^[a-zA-Z]/p' ./Makefile >> test2.txt
row2=$(cat test2.txt | wc -l)
row3=$(echo `expr $row1 + $row2 - 2`)
sed -i "$row1,$row3 d" ./Makefile
uuu="KBUILD_CFLAGS   := -Wall -Wundef -Wno-trigraphs -Wno-strict-prototypes -pipe -fno-strict-aliasing -fno-common -fshort-wchar -Wno-pointer-sign -Wno-format-security -Wno-unused-command-line-argument -w -std=gnu89 -Wno-gnu-variable-sized-type-not-at-end"
sed -i "$row1 i$uuu" ./Makefile
sed -i "/^KBUILD_CFLAGS[[:space:]]*+=.*-Werror=strict-prototypes.*/d" ./Makefile
