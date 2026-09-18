{ ... }:

{
  imports = [
    ./configuration.nix
    ./hardware-configuration-device1.nix
  ];

  networking.hostName = "device1";

  # %%% don't touch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  system.stateVersion = "26.05";  # TODO
}
