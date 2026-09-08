{ pkgs, ... }:

{
  home.username = "user1";
  home.homeDirectory = "/home/user1";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    nodejs
    zed-editor

    ghostty
    qalculate-qt
    sublime3

    xarchiver
    p7zip
    unrar
  ];

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      "--extension-mime-request-handling=always-prompt-for-install"
    ];
    extensions = [
      {
        # chromium-web-store: enables installing/updating extensions from the
        # Chrome Web Store on ungoogled-chromium
        id = "ocaahdebbfolfmndjeplogmgcagdmblk";
        crxPath = pkgs.fetchurl {
          url = "https://github.com/NeverDecaf/chromium-web-store/releases/download/v1.5.5.4/Chromium.Web.Store.crx";
          hash = "sha256-Y8B1tKJbEa8sU22tGRlG6NlUf5LVtsJXss5BONKZbzI=";
        };
        version = "1.5.5.4";
      }
    ];
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -lah --color=always --group-directories-first";
      gs = "git status";
      nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
    };
    interactiveShellInit = ''
      fastfetch
    '';
    functions.fish_prompt = ''
      echo
      set_color --bold green
      echo -n $USER@$hostname
      set_color normal --bold
      echo -n ':'
      set_color --bold blue
      echo -n (prompt_pwd)
      set_color normal --bold
      echo -n '$ '
      set_color normal
    '';
  };

  # previous zsh setup, kept for reference
  # programs.zsh = {
  #   enable = true;
  #   shellAliases = {
  #     ll = "ls -lah --color=always --group-directories-first";
  #     gs = "git status";
  #     nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
  #   };
  #   initContent = ''
  #     PROMPT=$'\n%B%F{green}%n@%m%f:%F{blue}%~%f$ %b'
  #     fastfetch
  #   '';
  # };

  programs.btop.enable = true;
  programs.git = {
    enable = true;
    settings.user = {
      name = "thsr";
      email = "14094094+thsr@users.noreply.github.com";
    };
  };

  home.pointerCursor = {
    enable = true;
    name = "Adwaita";
    size = 20;
    package = pkgs.adwaita-icon-theme;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };
  home.sessionPath = [ "$HOME/.npm-global/bin" ];

  services.gammastep = {
    enable = true;
    tray = true;
    provider = "manual";
    latitude = 39.49;
    longitude = -0.48;
    temperature.day = 6500;
    temperature.night = 2700;
    settings.general.adjustment-method = "randr";  # or "wayland"
  };
}
