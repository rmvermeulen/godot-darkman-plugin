# Godot Darkman Plugin

For users of [i3][i3] and [darkman][darkman] who, like me, did
not setup their `XDG_DESKTOP_PORTAL` implementation correctly.

To do so, ensure your `~/.config/darkman/config.yaml` contains at least:

```
dbusserver: true
portal: true
```

And add `~/.config/xdg-desktop-portal/portals.conf` with the following:

```
[preferred]
default=gtk
org.freedesktop.impl.portal.Settings=darkman
```

In the Godot editor settings, enable `Interface` > `Theme` > `follow_system_theme`.

Otherwise, install this plugin, to periodically run `darkman get` to get the
current editor theme.

Comes with the following settings:

## `interface/darkman/shell`

Which shell to use (default: `sh`)

## `interface/darkman/cmd`

What command to run (default: `darkman get`)

## `interface/darkman/interval`

Check interval in seconds (default: `3`)

## `interface/darkman/fallback_mode`

What mode to assume if anything goes wrong (default: `light`)

## `interface/darkman/dark_mode_theme`

What theme to use in dark mode (default: `Dark`)

## `interface/darkman/light_mode_theme`

What theme to use in light mode (default: `Light`)

<!-- references  -->

[darkman]: https://gitlab.com/WhyNotHugo/darkman/
[i3]: https://i3wm.org/
