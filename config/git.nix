{ config, pkgs, ... }:

{
  environment =
    let
      git-minimal = (
        (pkgs.git.overrideAttrs (oldAttrs: rec {
          doInstallCheck = false;
        })).override {
          guiSupport = false;
          pythonSupport = false;
          perlSupport = false;
          withManual = false; # time consuming
          withLibsecret = true;
        }
      );
    in
    {
      systemPackages = [ (git-minimal) ];
      etc.gitconfig =
        if config.services.xserver.enable then
          {
            text = ''
              [credential]
                helper = ${git-minimal}/bin/git-credential-libsecret
              [web]
                browser = "firefox"
              [browser "firefox"]
                path = "firefox"
            '';
          } else {
          text = ''
            [web]
              browser = "w3m"
          '';
        };
    };
}
