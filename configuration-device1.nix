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

  services.xserver = {
    libinput.enable = true;

    inputClassSections = [
      ''
        Identifier "Custom touchpad response"
        MatchIsTouchpad "on"
        Driver "libinput"

        Option "AccelProfile" "custom"
        Option "AccelStepMotion" "033"
        Option "AccelPointsMotion" "0.00 0.07 0.16 0.29 0.46 0.67 0.92 1.21 1.53 1.88 2.26 2.67 3.11 3.58 4.08 4.61 5.17 5.76 6.38 7.03 7.71"

        Option "AccelPointsFallback" "0.0 0.35 0.85 1.60 2.70 4.20"
        Option "AccelStepFallback" "1.0"
      ''
    ];
  };

  # %%% don't touch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  system.stateVersion = "26.05";  # TODO
}
