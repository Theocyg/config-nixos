{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Import des modules nécessaires
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./greetd.nix
  ];

  # Configuration Home Manager
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      masterchief = import ../home/home.nix;
    };
  };

  # Active TLP pour économiser la batterie
  services.tlp.enable = true;

  # Variables de session pour Wayland
  environment.sessionVariables = {
    "ELECTRON_OZONE_PLATFORM_HINT" = "wayland";
  };

  # Activer Hyprland
  programs.hyprland.enable = true;

  # Activer les portals xdg pour Wayland
  xdg.portal = {
    enable = true;
  };

  # Configuration des overlays et autorisation des paquets non libres
  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
    };
  };

  # Configuration Nix (flakes et features expérimentales)
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;

    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Configuration du chargeur de démarrage
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Sécurité avec PAM et Hyprlock
  security.pam.services.hyprlock = {};

  # Configuration réseau via NetworkManager
  networking.networkmanager.enable = true;
  environment.systemPackages = [
    pkgs.networkmanagerapplet
  ];

  # Configuration Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Utilisateurs et groupes
  users.users = {
    masterchief = {
      initialPassword = "password";  # Remplace par un mot de passe plus sécurisé
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" ]; # Groupes supplémentaires
    };
  };

  # Configuration de l'heure
  time.timeZone = "Europe/Paris";

  # Configuration des polices de caractères
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

  # RTKit pour des performances audio optimisées (optionnel)
  security.rtkit.enable = true;

  # Configuration PipeWire (audio)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Désactivation du service OpenSSH (si non nécessaire)
  services.openssh = {
    enable = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Activation de Tailscale (VPN)
  services.tailscale.enable = true;

  # Mise à jour de l'état du système
  system.stateVersion = "23.05"; # Assure-toi de correspondre à ta version NixOS
}
