#!/usr/bin/env python3
"""
Set opacity on unfocused windows, with per-app_id overrides.

Drop this in your sway config dir, add:
    exec ~/.config/sway/inactive-opacity.py
Then reload and tweak the OPACITIES dict below.

Focus events are debounced and de-duplicated: `opacity` commands that arrive
while containers are still mapping or unmapping can take swayfx down, so the
tree is left to settle first and only values that actually changed are sent.
"""

import threading

import i3ipc

# Opacity values (0 = fully transparent, 1 = fully opaque)
# The None key is the fallback for any app not listed.
OPACITIES = {
    None: 0.85,  # default for all other windows
    'com.mitchellh.ghostty': 0.75,
    # Examples
    # 'firefox': 0.6,
    # 'ghostty': 0.7,
    # 'thunderbird': 0.8,
}

# Opacity for focused windows (set to <1.0 for apps you want slightly transparent when focused)
FOCUSED_OPACITIES = {
    'com.mitchellh.ghostty': 0.95,
}

# Seconds to let focus events stop arriving before touching the tree.
DEBOUNCE_SECONDS = 0.15

_applied = {}                  # con_id -> last opacity value sent to it
_timer = None                  # pending debounce timer
_send_lock = threading.Lock()  # serialises IPC writes coming from the timer thread


def is_window(con):
    """True only for toplevel windows; outputs, workspaces and split containers have neither."""
    return bool(con.app_id or con.window_class)


def desired_value(con, focused_id):
    """The opacity this container should have right now."""
    app = con.app_id or con.window_class
    if con.id == focused_id:
        return FOCUSED_OPACITIES.get(app, 1.0)
    return OPACITIES.get(app, OPACITIES[None])


def apply(ipc):
    """Send `opacity` for every window whose value differs from the last one sent."""
    focused = ipc.get_tree().find_focused()
    focused_id = focused.id if focused else None

    with _send_lock:
        live = set()
        for con in ipc.get_tree():
            if not is_window(con):
                continue
            live.add(con.id)
            value = desired_value(con, focused_id)
            if _applied.get(con.id) == value:
                continue
            _applied[con.id] = value
            con.command(f'opacity {value}')
        for gone in set(_applied) - live:
            del _applied[gone]


def schedule(ipc):
    """Coalesce a burst of focus events into a single update."""
    global _timer
    if _timer is not None:
        _timer.cancel()
    _timer = threading.Timer(DEBOUNCE_SECONDS, apply, args=(ipc,))
    _timer.daemon = True
    _timer.start()


if __name__ == '__main__':
    ipc = i3ipc.Connection()
    apply(ipc)
    ipc.on('window::focus', lambda conn, _event: schedule(conn))
    ipc.main()
