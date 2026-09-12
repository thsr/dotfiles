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

  services.printing.enable = true;


  # %%% audio %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  # %%% graphics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };


  # %%% login / desktop / windows %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = false;
  services.displayManager.ly.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.niri.enable = true;

  programs.dms-shell = {
    enable = true;
    enableSystemMonitoring = true;   # dgop widgets
    enableDynamicTheming  = true;    # matugen wallpaper theming
    enableAudioWavelength = true;    # cava visualizer
    enableCalendarEvents  = true;    # khal
    enableVPN             = true;
  };


  # %%% user %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  users.users."user1" = {
    isNormalUser = true;
    description = "user1";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };


  # %%% packages / programs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
  # programs.zsh.enable = true;

  programs.firefox.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
    ];
  };

  environment.systemPackages = with pkgs; [
    (vim-full.customize {
      name = "vim";
      vimrcConfig.customRC = ''
        set number
        set relativenumber

        filetype plugin indent on
        set softtabstop=4
        set tabstop=4
        set shiftwidth=4
        set autoindent
        set smartindent
        set expandtab
        set showmatch

        set list
        set listchars=tab:→\ ,lead:·,trail:·,nbsp:␣

        syntax on

        " Set leader key
        let mapleader = " "

        " Open netrw with <leader>cd
        nnoremap <leader>cd :Ex<CR>
      '';
    })
    fastfetch
    git
    gparted
    wget
    xwayland-satellite
  ];


  # %%% fonts %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    corefonts
    ia-writer-mono
    ia-writer-duospace
    ia-writer-quattro
    ibm-plex
    inter
    iosevka
    jetbrains-mono
    liberation_ttf
    lucidaGrande  # from let block
    source-sans
    source-code-pro
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "Lucida Grande" ];
    monospace = [ "JetBrains Mono" ];
  };


  # %%% don't touch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  system.stateVersion = "26.05";
}
