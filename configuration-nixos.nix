{ config, ... }:

{
  networking.hostName = "nixos";

  imports = [
    ./configuration.nix
    ./hardware-configuration-nixos.nix
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
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
  programs.niri.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  # %%% don't touch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  system.stateVersion = "26.05";
}
