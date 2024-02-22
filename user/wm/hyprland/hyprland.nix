{pkgs,config, ...}:
with pkgs;
{
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [ ];
    settings = { };
    xwayland.enable = true;
    systemd.enable = true;
    extraConfig = ''
      exec-once = dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY
      exec-once = waybar
      exec-once = blueman-applet
      exec-once = swayidle -w timeout 90 '${config.programs.swaylock.package}/bin/swaylock -f' timeout 210 'suspend-unless-render' resume '${pkgs.hyprland}/bin/hyprctl dispatch dpms on' before-sleep "${config.programs.swaylock.package}/bin/swaylock -f"
      exec-once = pypr
      exec-once = foot --server

      monitor=HDMI-A-1,1920x1080@144,0x0,auto
      monitor=HDMI-A-1,addreserved,-10,0,0,0
      monitor=eDP-1,1920x1080@120,1920x0,auto,mirror,HDMI-A-1

      env = WLR_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0
      env = QT_QPA_PLATFORMTHEME,qt5ct
      env = QT_QPA_PLATFORM,wayland
      env = GDK_BACKEND,wayland,x11
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = LIBVA_DRIVER_NAME,nvidia
      env = GTK_THEME,Adwaita:dark
      env = XCURSOR_SIZE,24
      env = __NV_PRIME_RENDER_OFFLOAD,1
      env = __NV_PRIME_RENDER_OFFLOAD_PROVIDER,NVIDIA-G0
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = __VK_LAYER_NV_optimus,NVIDIA_only
      env = BEMOJI_PICKER_CMD,fuzzel --dmenu

      input {
        kb_layout = us
        follow_mouse = 2
        repeat_rate = 45
        repeat_delay = 250
      }

      general {
        layout = master

        gaps_in = 7
        gaps_out = 7
        border_size = 2

        col.active_border = 0xff'' + config.lib.stylix.colors.base08 + ''

        col.inactive_border = 0x33'' + config.lib.stylix.colors.base00 + ''

        cursor_inactive_timeout = 30
        no_cursor_warps = false
        resize_on_border = true
      }

      decoration {
        rounding = 6
        blur {
           enabled = true
           size = 5
           passes = 2
           ignore_opacity = true
           contrast = 1.17
           brightness = 0.8
         }
      }

      misc {
        mouse_move_enables_dpms = false
        force_default_wallpaper = 0
      }

      xwayland {
        force_zero_scaling = true
      }

      animation = workspaces, 0 # Disable workspace animations

      layerrule = blur,waybar

      $scratchpadsize = size 80% 85%
      $scratchpad = class:^(scratchpad)$
      windowrulev2 = float,$scratchpad
      windowrulev2 = $scratchpadsize,$scratchpad
      windowrulev2 = workspace special silent,$scratchpad
      windowrulev2 = center,$scratchpad

      $pavucontrol = class:^(pavucontrol)$
      windowrulev2 = float,$pavucontrol
      windowrulev2 = size 86% 40%,$pavucontrol
      windowrulev2 = move 50% 6%,$pavucontrol
      windowrulev2 = workspace special silent,$pavucontrol
      windowrulev2 = opacity 0.80,$pavucontrol

      $mainMod = SUPER
      $terminal = footclient
      $menu = fuzzel

      bind = $mainMod, F, fullscreen, 1
      bind = $mainMod, T, togglegroup
      bind = $mainMod, Return, exec, $terminal
      bind = $mainMod, C, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, V, togglefloating,

      bind = $mainMod, R, exec, $menu
      bind = $mainMod, P, exec, wofi-pass
      bind = $mainMod, E, exec, bemoji
      bind = $mainMod SHIFT, P, exec, pypr toggle pavucontrol && hyprctl dispatch bringactivetotop
      bind = $mainMod, S, exec, grim -g "$(slurp -o)" - | wl-copy
      bind = $mainMod, X, exec, fnottctl dismiss
      bind = $mainMod SHIFT, X, exec, fnottctl dismiss all

      # Move focus with mainMod + arrow keys
      bind = $mainMod, H, movefocus, l
      bind = $mainMod, L, movefocus, r
      bind = $mainMod, K, movefocus, u
      bind = $mainMod, J, movefocus, d

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
    '';
  };
  home.packages = [
    libva-utils
    gsettings-desktop-schemas
    hyprland-protocols
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
  ];

  programs.swaylock = {
    enable = true;
    package = swaylock-effects;
  };

  services.swayidle = {
    enable = true;
  };
}
