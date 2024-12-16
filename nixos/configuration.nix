{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./greetd.nix
  ];
  
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      kaan = import ../home/home.nix;
    };
  };

  services.tlp.enable = true;
  environment.sessionVariables = {
    "ELECTRON_OZONE_PLATFORM_HINT" = "wayland";
  };

  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
  };

  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;

    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  security.pam.services.hyprlock = {};
  
  networking.networkmanager.enable = true;
  environment.systemPackages = [
    pkgs.networkmanagerapplet
  ];
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  users.users = {
    kaan = {
      initialPassword = "password";
      isNormalUser = true;
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2J9YKlcGlhny06zjSme57qFOGarY/F0X9VvulUPrhm kaan@doyurur.xyz"];
      extraGroups = [ "wheel" "networkmanager" "docker" ];
    };
  };

  time.timeZone = "Europe/Paris";

  fonts.packages = with pkgs; [
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-emoji
  liberation_ttf
  fira-code
  fira-code-symbols
  mplus-outline-fonts.githubRelease
  dina-font
  proggyfonts
  nerdfonts
  ];

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };


  services.openssh = {
    enable = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services.tailscale.enable = true;


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
