{ config, pkgs, ... }:

{
  environment = 
    let
      git_minimal = ((pkgs.git.overrideAttrs (oldAttrs: rec { doInstallCheck = false; })).override {
        guiSupport = false;
        pythonSupport = false;
        perlSupport = false;
        withManual = false;
        withLibsecret = true;
      });
    in
    {
      systemPackages = [ (git_minimal) ];
      etc.gitconfig = if config.services.xserver.enable then
      {
        text = ''
[credential]
  helper = ${git_minimal}/bin/git-credential-libsecret
        '';
      } else {
        text = "";
      };
    };
}

