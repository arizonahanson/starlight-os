{ config, pkgs, ... }:

{
  environment = 
    let
      git-minimal = ((pkgs.git.overrideAttrs (oldAttrs: rec { doInstallCheck = false; })).override {
        guiSupport = false;
        pythonSupport = false;
        perlSupport = false;
        withManual = false; # time consuming
        withLibsecret = true;
      });
      git-config = ''
        [core]
          filemode = true
          autocrlf = false
        [pack]
          threads = ${toString config.nix.maxJobs}
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
          ui = auto
        [color "grep"]
          separator = white
          filename = blue
          linenumber = black bold
          match = 15 8
        [color "diff"]
          commit = cyan bold
          meta = black bold
          frag = white
          old = red
          new = green
        [color "branch"]
          remote = cyan bold
          current = blue bold
          local = blue
        [color "decorate"]
          branch = blue bold
          remoteBranch = cyan bold
          tag = cyan bold
          HEAD = cyan
          stash = blue bold
        [color "status"]
          added = yellow
          changed = red bold
          untracked = red
          header = black bold
          branch = blue bold
          localBranch = blue
          remoteBranch = cyan bold
        [tig "color"]
          cursor = 15 8
          date = black default bold
          graph-commit = cyan default bold
          line-number = black default bold
          main-tracked = cyan default bold
          title-blur = 8 default
          title-focus = 15 8
          search-result = 15 8
          status = yellow default
      '';
      git-all = (with import <nixpkgs> {}; writeShellScriptBin "git-all" ''
        echo
        for repo in $(find -L . -maxdepth 7 -iname '.git' -type d -printf '%P\0' 2>/dev/null | xargs -0 dirname | sort); do
          echo -e "\e[0;37m  \e[0;34m$repo \e[0m(\e[0;33m$@\e[0m)"
          pushd $repo >/dev/null
          ${git-minimal}/bin/git "$@"
          popd >/dev/null
          echo
        done
      '');
    in
    {
      systemPackages = [ (git-minimal) (git-all) pkgs.tig ];
      etc.gitconfig = if config.services.xserver.enable then
      {
        text = ''
          [credential]
            helper = ${git-minimal}/bin/git-credential-libsecret
          ${git-config}
        '';
      } else {
        text = "${git-config}";
      };
    };
}

