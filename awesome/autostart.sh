#!/bin/sh
# Place items you want started when awesome starts.
# ensure only one instance..
run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}
# Add programs to run @ startup "run" insures the check.
run "xfsettingsd"
run "nm-applet"
run "pnmixer"
run "picom"
# Keep from startup in xfce4.
if ! test -e "/usr/share/xfwm4";then
run "lxpolkit"
run "$HOME/.fehbg"
fi

## Start conkys on login if present
if test -f  "$HOME/.config/awesome/conky-awesome/scripts/conky-restart-list"; then
	"$HOME/.config/awesome/conky-awesome/scripts/conky-restart-list" >/dev/null 2>&1
fi

## Run awesome-user-autostart.sh for additional user items.
if test -f  "$HOME/.config/awesome/awesome-user-autostart.sh"; then
	"$HOME/.config/awesome/awesome-user-autostart.sh"
fi
