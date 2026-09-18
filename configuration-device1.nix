{ ... }:

{
  networking.hostName = "device1";

  imports = [
    ./configuration.nix
    ./hardware-configuration-device1.nix
  ];


  # %%% login / desktop / windows %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  services.xserver.displayManager.lightdm.enable = false;
  services.displayManager.ly.enable = true;
  programs.niri.enable = true;


  # %%% don't touch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  system.stateVersion = "26.05";  # TODO
}
