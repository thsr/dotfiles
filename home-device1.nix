{ ... }:

{
  imports = [ ./home.nix ];

  # programs.git.settings.user.signingkey = "123456789!";  # TODO
  # programs.git.settings.commit.gpgsign = true;  # TODO

  # %%% don't touch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  home.stateVersion = "26.05";  # TODO
}
