# Shared system configuration.
# User-level programs and dotfiles live in home.nix (home-manager).

{ inputs, pkgs, ... }:

let
  lucidaGrande = pkgs.stdenvNoCC.mkDerivation {
    pname = "lucida-grande";
    version = "local";
    src = ./fonts/lucida-grande;
    installPhase = ''
      install -Dm644 *.ttf -t $out/share/fonts/truetype/lucida-grande
    '';
  };
  monaco = pkgs.stdenvNoCC.mkDerivation {
    pname = "moncao";
    version = "local";
    src = ./fonts/monaco;
    installPhase = ''
      install -Dm644 *.ttf -t $out/share/fonts/truetype/monaco
    '';
  };
in
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
    # timeout = 0;
  };

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
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;


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
      (pkgs.thunar-archive-plugin.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          install -Dm755 ${xarchiver}/libexec/thunar-archive-plugin/xarchiver.tap \
            $out/libexec/thunar-archive-plugin/xarchiver.tap
        '';
      }))
      xarchiver
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
        " Open netrw
        nnoremap <leader>cd :Ex<CR>
        "" Change cursor on mode
        :autocmd InsertEnter * set cul
        :autocmd InsertLeave * set nocul
      '';
    })
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    fastfetch
    ffmpeg
    git
    gparted
    librewolf
    unzip
    wget
    xarchiver
    xwayland-satellite
  ];

  # services.opensnitch.enable = true;
  services.portmaster.enable = true;

  virtualisation.docker ={
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    autoPrune.enable = true;
  };

  environment.etc."brave/policies/managed/BraveDebloater.json".source = ./chromium/BraveDebloater.json;


  # %%% fonts %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
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
      monaco  # from let block
      source-sans
      source-code-pro
    ];
    fontconfig.defaultFonts = {
      sansSerif = [ "Lucida Grande" ];
      serif = [ "IBM Plex Serif" ];
      monospace = [ "JetBrains Mono" ];
    };
  };
}
