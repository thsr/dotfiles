{ ... }:

{
  imports = [ ./home.nix ];

  programs.git.settings.user.signingkey = "948EEE199CC4A95A!";
  programs.git.settings.commit.gpgsign = true;

  # %%% don't touch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  home.stateVersion = "26.05";
}
