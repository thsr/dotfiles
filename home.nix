{ config, pkgs, ... }:

{
  home = {
    username = "user1";
    homeDirectory = "/home/user1";
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
    thunar = {
      "last-show-hidden" = true;
      "last-view" = "ThunarDetailsView";
      "last-details-view-column-widths" = "50,50,116,50,50,50,85,50,315,50,122,65,50,76";
      "last-details-view-visible-columns" = "THUNAR_COLUMN_DATE_MODIFIED,THUNAR_COLUMN_GROUP,THUNAR_COLUMN_NAME,THUNAR_COLUMN_OWNER,THUNAR_COLUMN_PERMISSIONS,THUNAR_COLUMN_SIZE,THUNAR_COLUMN_TYPE";
      "last-details-view-fixed-columns" = true;
      "last-details-view-column-order" = "THUNAR_COLUMN_NAME,THUNAR_COLUMN_SIZE,THUNAR_COLUMN_SIZE_IN_BYTES,THUNAR_COLUMN_TYPE,THUNAR_COLUMN_DATE_MODIFIED,THUNAR_COLUMN_LOCATION,THUNAR_COLUMN_MIME_TYPE,THUNAR_COLUMN_DATE_CREATED,THUNAR_COLUMN_PERMISSIONS,THUNAR_COLUMN_OWNER,THUNAR_COLUMN_GROUP,THUNAR_COLUMN_DATE_ACCESSED,THUNAR_COLUMN_RECENCY,THUNAR_COLUMN_DATE_DELETED";
    };
    xsettings = {
      "Net/ThemeName"         = "OS-X-Mavericks-1.2";
      "Net/IconThemeName"     = "Mac-OS-X-Lion-master";
      "Gtk/FontName"          = "Lucida Grande 9";
      "Gtk/MonospaceFontName" = "JetBrains Mono Medium 10";
      "Xft/DPI"               = 96;
      "Gtk/CursorThemeName"   = "Quintom_Ink";
      "Gtk/CursorThemeSize"   = 20;
    };
  };

  dconf.settings."org/gnome/desktop/interface" = {
    gtk-theme = "OS-X-Mavericks-1.2";
    icon-theme = "Mac-OS-X-Lion-master";
    color-scheme = "prefer-light";
    font-name = "Lucida Grande 9";
    monospace-font-name = "JetBrains Mono Medium 10";
    document-font-name = "Lucida Grande 9";
  };

  gtk = {
    enable = true;
    theme.name = "OS-X-Mavericks-1.2";
    iconTheme.name = "Mac-OS-X-Lion-master";
    colorScheme = "light";
    font = {
      name = "Lucida Grande";
      size = 9;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;

        desktop = "${config.home.homeDirectory}/Desktop";
        documents = "${config.home.homeDirectory}/Documents";
        download = "${config.home.homeDirectory}/Downloads";
        music = "${config.home.homeDirectory}/Music";
        pictures = "${config.home.homeDirectory}/Pictures";
        videos = "${config.home.homeDirectory}/Videos";
        templates = "${config.home.homeDirectory}/Templates";
        publicShare = "${config.home.homeDirectory}/Public";
      };

      # mimeApps = {
      #   enable = true;

      #   defaultApplications = {
      #     "text/plain" = [ "org.gnome.TextEditor.desktop" ];
      #     "image/png" = [ "org.gnome.eog.desktop" ];
      #     "image/jpeg" = [ "org.gnome.eog.desktop" ];
      #     "application/pdf" = [ "org.gnome.Evince.desktop" ];

      #     "x-scheme-handler/http" = [ "firefox.desktop" ];
      #     "x-scheme-handler/https" = [ "firefox.desktop" ];
      #   };
      # };

      desktopEntries.chrome-agent = {
        name = "Brave (agent debug :9222)";
        comment = "Brave with remote debugging for agent-browser";
        exec = "brave --remote-debugging-port=9222 --window-size=900,600 https://example.com";
        icon = "brave";
        terminal = false;
        categories = [ "Network" "WebBrowser" ];
      };
    };


  # %%% dotfiles %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  home.file.".themes/OS-X-Mavericks-1.2".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.themes/OS-X-Mavericks-1.2";
  home.file.".icons/Mac-OS-X-Lion-master".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.icons/Mac-OS-X-Lion-master";
  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/niri/config.kdl";
  xdg.stateFile."noctalia/settings.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/noctalia/settings.toml";
  xdg.configFile."zed/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/zed/settings.json";
  xdg.configFile."zed/keymap.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/zed/keymap.json";
  xdg.configFile."zed/themes/Alabaster.json".source = ./.config/zed/themes/Alabaster.json;
  xdg.configFile."zed/themes/AlabasterALT.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/zed/themes/AlabasterALT.json";
  xdg.configFile."ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/ghostty/config";


  # %%% packages / programs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  home.packages = with pkgs; [
    agent-browser
    brave
    ffmpeg
    ghostty
    gthumb
    nodejs
    obsidian
    openssh
    qalculate-qt
    spotify
    sublime3
    zed-editor
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
      {
        # ublock origin extension
        id = "ocaahdebbfolfmndjeplogmgcagdmblk";
        crxPath = pkgs.fetchurl {
          url = "https://github.com/gorhill/uBlock/releases/download/1.75.0/uBlock0_1.75.0.chromium.crx";
        };
        version = "1.75.0";
      }
    ];
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -lah --color=always --group-directories-first";
      gs = "git status";
      nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#(hostname -s)";
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
  #     nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#$(hostname -s)";
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
    settings.user.name = "thsr";
    settings.user.email = "14094094+thsr@users.noreply.github.com";
  };
}
