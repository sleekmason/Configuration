#!/bin/bash

# define layouts array

# mimic dwm style layout symbols
#
typeset -A layouts=(
[tile]="[T]"
[rtile]="[R]"
[mono]="[M]"
[none]="[F]"
[float]="[F]"
[grid]="[G]"
[spiral]="[S]"
[dwindle]="[D]"
[tstack]="[TT]"
)

# or use iconic font
# mimic dwm style layout symbols
#
#typeset -A layouts=(
#[tile]="[]="
#[rtile]="=[]"
#[mono]="[ ]"
#[none]="< >"
#[grid]="#"
#[spiral]="\@"
#[dwindle]="@/"
#[tstack]="="
#)

layout=$(dkcmd status num=1 | grep '^L' | sed 's/^L//')
layout="${layouts[$layout]}"
# echo "${$layout:-???}"  # ??? If current layout is unknown # error line 18: ${$layout:-???}: bad substitution

echo $layout

exit 0;
