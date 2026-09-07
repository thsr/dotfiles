DOTFILES(7)                   User Manual                    DOTFILES(7)

NAME
       dotfiles -- NixOS system and user configuration, host "nixos"

DESCRIPTION
       NixOS system configuration (configuration.nix) plus home-manager
       user configuration (home.nix) for user1, built as one unit from a
       flake.  /etc/nixos is not used; everything is built from this repo.

FILES
       flake.nix                    flake entry point
       configuration.nix            system-level NixOS configuration
       hardware-configuration.nix   generated, machine-specific
       home.nix                     home-manager configuration (user1)
       fonts/lucida-grande/         Lucida Grande ttf files, packaged by
                                    configuration.nix and installed into
                                    the system font dir

INSTALLATION (new machine)
       1. Install NixOS.  Create user "user1".

       2. Clone this repo:

            git clone <url> ~/dotfiles

       3. Generate hardware configuration for the machine and overwrite
          the copy in the repo:

            sudo nixos-generate-config --show-hardware-config > ~/dotfiles/hardware-configuration.nix

       4. First switch.  Flakes are not yet enabled on a fresh install,
          so enable them for this one command via NIX_CONFIG
          (nixos-rebuild does not accept --extra-experimental-features):

            cd ~/dotfiles
            sudo NIX_CONFIG="experimental-features = nix-command flakes" nixos-rebuild switch --flake .#nixos

          After this switch flakes stay enabled permanently
          (see nix.settings in configuration.nix).

REBUILDING
            sudo nixos-rebuild switch --flake ~/dotfiles#nixos

       or, from a login shell, the alias:

            nrs

       Commit before rebuilding: flakes only see files tracked by git.

UPDATING INPUTS
            nix flake update        # inside ~/dotfiles
            nrs

NOTES
       o  home-manager runs as a NixOS module; one rebuild command covers
          system and user.

       o  Do not symlink from this repo into /etc/nixos.  The repo is the
          source of truth.

DOTFILES(7)                   User Manual                    DOTFILES(7)
