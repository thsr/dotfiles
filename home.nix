{ config, pkgs, ... }:

{
  home = {
    username = "user1";
    homeDirectory = "/home/user1";
    stateVersion = "26.05";
    pointerCursor = {
      enable = true;
      name = "Quintom_Ink";
      size = 20;
      package = pkgs.quintom-cursor-theme;
      gtk.enable = true;
      x11.enable = true;
    };
    sessionVariables = {
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
      AGENT_BROWSER_AUTO_CONNECT = "1";
      AGENT_BROWSER_HEADED = "1";
    };
    sessionPath = [ "$HOME/.npm-global/bin" ];
  };


  # %%% services %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  services.gammastep = {
    enable = true;
    tray = true;
    provider = "manual";
    latitude = 39.49;
    longitude = -0.48;
    temperature.day = 6500;
    temperature.night = 2700;
    # settings.general.adjustment-method = "randr";  # or "wayland"
  };

  xfconf.settings = {
    xsettings = {
      "Gtk/FontName"          = "Lucida Grande 9";
      "Gtk/MonospaceFontName" = "JetBrains Mono Medium 10";
      "Xft/DPI"               = 96;
      "Gtk/CursorThemeName"   = "Quintom_Ink";
      "Gtk/CursorThemeSize"   = 20;
    };
  };

  dconf.settings."org/gnome/desktop/interface" = {
    font-name = "Lucida Grande 9";
    monospace-font-name = "JetBrains Mono Medium 10";
    document-font-name = "Lucida Grande 9";
  };

  gtk = {
    enable = true;
    font = {
      name = "Lucida Grande";
      size = 9;
    };
  };


  # %%% dotfiles %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/niri/config.kdl";
  xdg.configFile."noctalia/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/noctalia/settings.json";
  xdg.configFile."zed/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/zed/settings.json";
  xdg.configFile."zed/keymap.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/zed/keymap.json";
  xdg.configFile."zed/themes/Alabaster.json".source = ./.config/zed/themes/Alabaster.json;
  xdg.configFile."zed/themes/AlabasterALT.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/zed/themes/AlabasterALT.json";
  xdg.configFile."ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/ghostty/config";


  # %%% packages / programs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  home.packages = with pkgs; [
    agent-browser
    nodejs
    zed-editor

    openssh

    ghostty
    obsidian
    qalculate-qt
    sublime3
  ];

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = [
      {
        # chromium-web-store extension
        id = "ocaahdebbfolfmndjeplogmgcagdmblk";
        crxPath = pkgs.fetchurl {
          url = "https://github.com/NeverDecaf/chromium-web-store/releases/download/v1.5.5.4/Chromium.Web.Store.crx";
          hash = "sha256-Y8B1tKJbEa8sU22tGRlG6NlUf5LVtsJXss5BONKZbzI=";
        };
        version = "1.5.5.4";
      }
    ];
  };

  xdg.desktopEntries.chrome-agent = {
    name = "Chromium (agent debug :9222)";
    comment = "Chromium with remote debugging for agent-browser";
    exec = "chromium --remote-debugging-port=9222 --window-size=900,600 https://example.com";
    icon = "chromium";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
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

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-qt;
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "thsr";
      email = "14094094+thsr@users.noreply.github.com";
      signingkey = "948EEE199CC4A95A!";
    };
    settings.commit.gpgsign = true;
  };
}
