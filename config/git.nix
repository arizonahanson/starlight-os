{ config, pkgs, ... }:

{
  environment = {
    systemPackages = [
      ((pkgs.git.overrideAttrs (oldAttrs: rec { doInstallCheck = false; })).override {
        guiSupport = false;
        withLibsecret = true;
      })
    ];
    etc.gitconfig = {
      text = ''
[credential]
	helper = libsecret
      '';
    };
  };
}

