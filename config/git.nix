{ config, pkgs, ... }:

{
  environment = 
    let
      git_minimal = ((pkgs.git.overrideAttrs (oldAttrs: rec { doInstallCheck = false; })).override {
        guiSupport = false;
        pythonSupport = false;
        perlSupport = false;
        withManual = false; # time consuming
        withLibsecret = true;
      });
      git_config = ''
        [core]
          filemode = true
          autocrlf = false
        [push]
          default = current
        [help]
          autocorrect = 30
        [merge]
          tool = vimdiff
          conflictstyle = diff3
        [mergetool]
          prompt = false
          keepBackup = false
        [difftool]
          prompt = false
        [color]
          ui = always
        [color "grep"]
          separator = magenta
          filename = blue
          linenumber = black bold
        [color "diff"]
          commit = magenta
          meta = black bold
          frag = magenta bold
          old = red
          new = green
        [color "branch"]
          remote = red bold
          current = yellow bold
          local = yellow
        [color "status"]
          added = yellow bold
          changed = red bold
          untracked = red
          header = black bold
          branch = yellow bold
        [pack]
          threads = ${toString config.nix.maxJobs}
      '';
      git-all = (with import <nixpkgs> {}; writeShellScriptBin "git-all" ''
        echo
        for repo in $(find -L . -maxdepth 7 -iname '.git' -type d -printf '%P\0' 2>/dev/null | xargs -0 dirname | sort); do
          echo -e "\e[1;31m  \e[1;34m$repo \e[0m(\e[1;33m$@\e[0m)"
          pushd $repo >/dev/null
          ${git_minimal}/bin/git "$@"
          popd >/dev/null
          echo
        done
      '');
    in
    {
      systemPackages = [ (git_minimal) (git-all) pkgs.tig ];
      etc.gitconfig = if config.services.xserver.enable then
      {
        text = ''
          [credential]
            helper = ${git_minimal}/bin/git-credential-libsecret
          ${git_config}
        '';
      } else {
        text = "${git_config}";
      };
    };
}

