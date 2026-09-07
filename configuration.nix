# System configuration for host "nixos".
# User-level programs and dotfiles live in home.nix (home-manager).

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.wireless.enable = true;
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

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."user1" = {
    isNormalUser = true;
    description = "user1";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  # programs.zsh.enable = true;

  programs.firefox.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    fastfetch
    git
    vim
    wget
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

    lucidaGrande
  ];

  system.stateVersion = "26.05";
}
