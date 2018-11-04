{ config, pkgs, ... }:

{
  environment = 
    let
      my_git = ((pkgs.git.overrideAttrs (oldAttrs: rec { doInstallCheck = false; })).override {
        guiSupport = false;
        pythonSupport = false;
        perlSupport = false;
        withManual = false;
        withLibsecret = true;
      });
    in
    {
      systemPackages = [ (my_git) ];
      etc.gitconfig = {
        text = ''
[credential]
  helper = ${my_git}/bin/git-credential-libsecret
        '';
      };
    };
}

