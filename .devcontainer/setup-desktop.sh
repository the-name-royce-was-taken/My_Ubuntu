#!/usr/bin/env bash
set -e

sudo apt update
sudo apt install -y \
  gnome-session-flashback \
  gnome-panel \
  metacity \
  gnome-settings-daemon \
  dbus-x11 \
  x11vnc \
  xvfb \
  novnc \
  websockify \
  xterm \
  wget \
  x11-utils

cat > /workspaces/${PWD##*/}/start-desktop.sh <<'STARTEOF'
#!/usr/bin/env bash
export DISPLAY=:1
Xvfb :1 -screen 0 1366x768x24 > /tmp/xvfb.log 2>&1 &
sleep 2
dbus-launch --exit-with-session gnome-session --session=gnome-flashback-metacity > /tmp/gnome.log 2>&1 &
sleep 4
x11vnc -display :1 -forever -shared -nopw -rfbport 5901 > /tmp/x11vnc.log 2>&1 &
sleep 2
websockify --web=/usr/share/novnc/ 8080 localhost:5901 > /tmp/novnc.log 2>&1 &
STARTEOF

chmod +x /workspaces/${PWD##*/}/start-desktop.sh
