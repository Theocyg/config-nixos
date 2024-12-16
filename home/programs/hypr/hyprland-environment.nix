{ config, pkgs, ... }:

{
  home = {
    sessionVariables = {
    EDITOR = "kitty";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    __GL_VRR_ALLOWED="1";
    CLUTTER_BACKEND = "wayland";
    WLR_RENDERER = "vulkan";

    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    GDK_SCALE = "2";
    XCURSOR_SIZE = "32";
    };
  };
}
