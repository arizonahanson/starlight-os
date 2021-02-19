{ config, pkgs, ... }:

{
  environment =
    let
      theme = config.starlight.theme;
      toANSI = num: if num <= 7 then "00;3${toString num}" else "01;3${toString (num - 8)}";
      git-minimal = (
        (pkgs.git.overrideAttrs (oldAttrs: rec {
          doInstallCheck = false;
          NIX_CFLAGS_COMPILE = "-march=native";
        })).override {
          guiSupport = false;
          pythonSupport = false;
          perlSupport = false;
          withManual = false; # time consuming
          withLibsecret = true;
        }
      );
      git-all = (
        with import <nixpkgs> { }; writeShellScriptBin "git-all" ''
          echo
          for repo in $(find -L . -maxdepth 7 -iname '.git' -type d -printf '%P\0' 2>/dev/null | xargs -0 dirname | sort); do
            echo -e "\e[${toANSI theme.executable}m  \e[${toANSI theme.path}m$repo \e[0m(\e[${toANSI theme.function}m$@\e[0m)"
            pushd $repo >/dev/null
            ${git-minimal}/bin/git "$@"
            popd >/dev/null
            echo
          done
        ''
      );
    in
    {
      systemPackages = [ (git-minimal) (git-all) ];
      etc.gitconfig =
        if config.services.xserver.enable then
          {
            text = ''
              [credential]
                helper = ${git-minimal}/bin/git-credential-libsecret
              [web]
                browser = "chrome"
              [browser "chrome"]
                path = "google-chrome-stable"
            '';
          } else {
          text = ''
            [web]
              browser = "w3m"
          '';
        };
    };
  programs.zsh.shellAliases = {
    gg = "git all";
    gga = "git all add";
    ggc = "git all commit";
    ggl = "git all pull";
    ggrp = "git all remote prune origin";
    ggs = "git all status -sb";
    ggx = "sudo git all clean -fxd";
    gdt = "git difftool";
  };
}
