#!/bin/fish
# xclip required for this script.
# From scrapyer, https://github.com/zheng-oh
set chose (history | head -n 5 | dmenu -i -p 'Copy which command out?' -l 5)
eval $chose | xclip -sel clib 
