DOTFILES(7)                   thsr dotfiles                    DOTFILES(7)

NAME
       dotfiles -- shared NixOS system and user configuration

DESCRIPTION
       Shared NixOS system configuration plus home-manager user
       configuration for user1, built as one unit from a flake.  /etc/nixos
       is not used; everything is built from this repo.

MAIN FILES
       flake.nix                    flake entry point
       configuration.nix           shared system configuration
       configuration-<host>.nix    host-specific system configuration
       <host>.nix                  generated hardware configuration
       home.nix                    shared home-manager configuration
       home-<host>.nix             host-specific home-manager configuration

       Configured hosts are "nixos" and "device1".

INSTALLATION (new machine)
       1. Install NixOS.  Create user "user1".

       2. Clone this repo:

            git clone <url> ~/dotfiles

       3. Generate hardware configuration, using the machine hostname as the
          filename.  For device1:

            sudo nixos-generate-config --show-hardware-config > ~/dotfiles/device1.nix

       4. Add new files to Git.  Flakes do not include untracked files:

            cd ~/dotfiles
            git add device1.nix configuration-device1.nix home-device1.nix

       5. First switch.  Flakes are not yet enabled on a fresh install, so
          enable them this one time via NIX_CONFIG:

            sudo NIX_CONFIG="experimental-features = nix-command flakes" nixos-rebuild switch --flake .#device1

          After this switch flakes stay enabled permanently
          (see nix.settings in configuration.nix).

REBUILDING
            sudo nixos-rebuild switch --flake ~/dotfiles#$(hostname -s)

       or, from a Fish login shell, the alias:

            nrs

UPDATING INPUTS
            nix flake update        # inside ~/dotfiles
            nrs

NOTES
       o  home-manager runs as a NixOS module; one rebuild command covers
          system and user.

       o  Do not symlink from this repo into /etc/nixos.  The repo is the
          source of truth.

       o  Host-specific system and home-manager options belong in the
          corresponding configuration-<host>.nix and home-<host>.nix files.

DOTFILES(7)                   thsr dotfiles                    DOTFILES(7)
