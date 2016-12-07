#!/bin/sh

(crontab -l 2>/dev/null; echo "*/30 * * * * export DISPLAY=:0.0 && notify-send -i /usr/share/icons/Humanity/emblems/48/emblem-OK.svg 棒棒哒，休息一会儿吧") |crontab -
