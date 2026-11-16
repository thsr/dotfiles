{ ... }:

{
  imports = [ ./home.nix ];

  programs.git.settings.user.signingkey = "470880335232BAF5!";
  programs.git.settings.commit.gpgsign = true;

  # %%% don't touch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  home.stateVersion = "26.05";
}
