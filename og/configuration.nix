# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

let
  lucidaGrande = pkgs.stdenvNoCC.mkDerivation {
    pname = "lucida-grande";
    version = "local";

    src = ./fonts/lucida-grande;

    installPhase = ''
      install -Dm644 *.ttf -t $out/share/fonts/truetype/lucida-grande
    '';
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = false;
  services.displayManager.ly.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # Use the WirePlumber session manager
    #wireplumber.enable = true;
  };

  users.users."user1" = {
    isNormalUser = true;
    description = "user1";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      nodejs
      zed-editor
    ];
  };

  programs.firefox.enable = true;

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -lah --color=always --group-directories-first";
      gs = "git status";
      nrs = "sudo nixos-rebuild switch";
    };
    promptInit = ''
      PROMPT=$'\n%B%F{green}%n@%m%f:%F{blue}%~%f$ %b'
    '';
    interactiveShellInit = ''
      fastfetch
    '';
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    btop
    fastfetch
    gammastep
    git
    wget

    ghostty

    sublime3
    vim

    xarchiver
    p7zip
    unrar

    adwaita-icon-theme
  ];

  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    corefonts
    inter
    iosevka
    jetbrains-mono
    liberation_ttf
    source-sans
    source-code-pro
  ];

  environment.variables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE  = "20";    # 3840x2160 — 32 if 48 feels large
  };

  environment.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    PATH = [ "$HOME/.npm-global/bin" ];
  };

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # services.openssh.enable = true;

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # Most users should NEVER change this value after the initial install, for any reason,
  system.stateVersion = "26.05";
}

