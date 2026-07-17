#!/usr/bin/env python3
"""
Set opacity on unfocused windows, with per-app_id overrides.

Drop this in your sway config dir, add:
    exec ~/.config/sway/inactive-opacity.py
Then reload and tweak the OPACITIES dict below.
"""

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


def apply(ipc):
    """Apply opacity to all windows: focused uses FOCUSED_OPACITIES, rest uses OPACITIES."""
    focused = ipc.get_tree().find_focused()
    for win in ipc.get_tree():
        if win.id == focused.id:
            app = win.app_id or win.window_class
            val = FOCUSED_OPACITIES.get(app, 1.0)
            win.command(f'opacity {val}')
        else:
            app = win.app_id or win.window_class
            val = OPACITIES.get(app, OPACITIES[None])
            win.command(f'opacity {val}')


def on_focus(ipc, event):
    focused = event.container
    app = focused.app_id or focused.window_class
    focused_val = FOCUSED_OPACITIES.get(app, 1.0)
    focused.command(f'opacity {focused_val}')
    for win in ipc.get_tree():
        if win.id != focused.id:
            app = win.app_id or win.window_class
            val = OPACITIES.get(app, OPACITIES[None])
            win.command(f'opacity {val}')


if __name__ == '__main__':
    ipc = i3ipc.Connection()
    apply(ipc)
    ipc.on('window::focus', on_focus)
    ipc.main()
