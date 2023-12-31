{ inputs, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    extraConfig = ''
/* Set mod key to SUPER key (aka Win key) */
$mod = SUPER

/* Environmental variables */
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = _JAVA_AWT_WM_NONREPARENTING,1
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
env = WLR_NO_HARDWARE_CURSORS,1
env = WLR_DRM_NO_ATOMIC,1
env = FLAKE,/home/heartblin/dots

/* Make Hyprland render at 144Hz */
monitor = eDP-1, 1920x1080@144, 0x0, 1
monitor = HDMI-A-1, 1920x1080@60, auto, 1, mirror, eDP-1

/* Start up programs*/
exec-once = swww init; swww kill; swww init
exec-once = dbus-update-activation-environment --all &
exec-once = sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = ${pkgs.wl-clipboard}/bin/wl-paste --watch cliphist store &
exec-once = ags

/* Misc options */
misc {
  disable_autoreload = true
  force_default_wallpaper = 0
  animate_manual_resizes = false
  animate_mouse_windowdragging = false
}

/* Touchpad gestures */
gestures {
  workspace_swipe = true
  workspace_swipe_forever = true
}

/* Change keyboard language & tweak mouse/touchpad */
input {
  kb_layout = ro

  follow_mouse = 1
  touchpad {
    scroll_factor = 0.3
    natural_scroll = false
  }
}

device:asue120a:00-04f3:319b-touchpad {
  clickfinger_behavior = true
  accel_profile = adaptive
  sensitivity = 0
}

/* Gaps & Colors - also tearing */
general {
  gaps_in = 10
  gaps_out = 20
  border_size = 1
  col.active_border = rgba(2F2F2FFF)
  col.inactive_border = rgba(2F2F2FFF)

  allow_tearing = true
}

/* Blur, Shadows and rounding */
decoration {
  rounding = 15
  blur {
    enabled = true
    size = 7
    passes = 4
    new_optimizations = true
    brightness = 1.0
    contrast = 1.0
    noise = 0.01
  }
  blurls = win11

  drop_shadow = true
  shadow_ignore_window = true
  shadow_offset = 0 2
  shadow_range = 15
  shadow_render_power = 6
  col.shadow = rgba(01010166)
}

/*
Animations shamelessly stolen from end-4
https://github.com/end-4/dots-hyprland/tree/illogical-impulse
*/

animations {
  enabled = true

  /* Curves */
  bezier = linear, 0, 0, 1, 1
  bezier = md3_standard, 0.2, 0, 0, 1
  bezier = md3_decel, 0.05, 0.7, 0.1, 1
  bezier = md3_accel, 0.3, 0, 0.8, 0.15
  bezier = overshot, 0.05, 0.9, 0.1, 1.1
  bezier = crazyshot, 0.1, 1.5, 0.76, 0.92 
  bezier = hyprnostretch, 0.05, 0.9, 0.1, 1.0
  bezier = fluent_decel, 0.1, 1, 0, 1
  bezier = easeInOutCirc, 0.85, 0, 0.15, 1
  bezier = easeOutCirc, 0, 0.55, 0.45, 1
  bezier = easeOutExpo, 0.16, 1, 0.3, 1

  /* Animations */
  animation = windows, 1, 3, md3_decel, popin 60%
  animation = border, 1, 10, default
  animation = fade, 1, 2.5, md3_decel
  # animation = workspaces, 1, 3.5, md3_decel, slide
  animation = workspaces, 1, 3.5, easeOutExpo, slide
  # animation = workspaces, 1, 7, fluent_decel, slidefade 15%
  # animation = specialWorkspace, 1, 3, md3_decel, slidefadevert 15%
  animation = specialWorkspace, 1, 3, md3_decel, slidevert
}

dwindle {
  pseudotile = true
  preserve_split = true
}

master {
  new_is_master = true
}

/* Window rules */
windowrulev2 = float,class:(Alacritty)
windowrulev2 = move 60 50, class:(Alacritty)
windowrulev2 = size 1015 585, class:(Alacritty)
windowrulev2 = tile,class:(Microsoft-edge-dev)

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = $mod, Return, exec, ${pkgs.alacritty}/bin/alacritty
bind = $mod, Q, killactive,
bind = $mod, M, exit,
bind = $mod, E, exec, dolphin
bind = $mod, F, togglefloating,
bind = $mod Shift, F, fullscreen
bind = $mod, Space, exec, ${pkgs.wofi}/bin/wofi --show drun
bind = $mod, P, pseudo, # dwindle
bind = $mod, J, togglesplit, # dwindle

/* Open common apps */
bind = $mod, W, exec, microsoft-edge-dev
bind = $mod, C, exec, code

# Move focus with mainMod + arrow keys
bind = $mod, left, movefocus, l
bind = $mod, right, movefocus, r
bind = $mod, up, movefocus, u
bind = $mod, down, movefocus, d

/* Cycle workspaces */
bind = $mod, bracketleft, workspace, m-1
bind = $mod, bracketright, workspace, m+1

/* Brightness */
bindle = , XF86MonBrightnessUp, exec, brillo -q -u 300000 -A 5
bindle = , XF86MonBrightnessDown, exec, brillo -q -u 300000 -U 5

/* Volume */
bindle = , XF86AudioRaiseVolume, exec, wpctl set-volume -l "1.0" @DEFAULT_AUDIO_SINK@ 6%+
bindle = , XF86AudioLowerVolume, exec, wpctl set-volume -l "1.0" @DEFAULT_AUDIO_SINK@ 6%-
bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bindl = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

# Switch workspaces with mainMod + [0-9]
bind = $mod, 1, workspace, 1
bind = $mod, 2, workspace, 2
bind = $mod, 3, workspace, 3
bind = $mod, 4, workspace, 4
bind = $mod, 5, workspace, 5
bind = $mod, 6, workspace, 6
bind = $mod, 7, workspace, 7
bind = $mod, 8, workspace, 8
bind = $mod, 9, workspace, 9
bind = $mod, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mod SHIFT, 1, movetoworkspace, 1
bind = $mod SHIFT, 2, movetoworkspace, 2
bind = $mod SHIFT, 3, movetoworkspace, 3
bind = $mod SHIFT, 4, movetoworkspace, 4
bind = $mod SHIFT, 5, movetoworkspace, 5
bind = $mod SHIFT, 6, movetoworkspace, 6
bind = $mod SHIFT, 7, movetoworkspace, 7
bind = $mod SHIFT, 8, movetoworkspace, 8
bind = $mod SHIFT, 9, movetoworkspace, 9
bind = $mod SHIFT, 0, movetoworkspace, 10

# Example special workspace (scratchpad)
bind = $mod, S, togglespecialworkspace, magic
bind = $mod SHIFT, S, movetoworkspace, special:magic

# Scroll through existing workspaces with mainMod + scroll
bind = $mod, mouse_down, workspace, e+1
bind = $mod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mod, mouse:272, movewindow
bindm = $mod, mouse:273, resizewindow
    '';
  };
}
