{ inputs, pkgs, ... }:

{
  networking.hostName = "device1";

  imports = [
    ./configuration.nix
    ./hardware-configuration-device1.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;

  powerManagement.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;
  services.tlp.enable = false;
  services.tuned.enable = false;


  # %%% login / desktop / windows %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  services.xserver.displayManager.lightdm.enable = false;
  services.displayManager.ly.enable = true;
  programs.niri = {
    enable = true;
    useNautilus = false;
  };
  programs.xfconf.enable = true;


  # %%% don't touch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  system.stateVersion = "26.05";  # TODO
}
