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
          filename = blue bold
          linenumber = black bold
          match = 15 8
        [color "diff"]
          commit = magenta
          meta = black bold
          frag = magenta bold
          old = red
          new = green bold
        [color "branch"]
          remote = red bold
          current = yellow bold
          local = yellow
        [color "decorate"]
          branch = yellow bold
          remoteBranch = red bold
          tag = cyan bold
          HEAD = cyan
          stash = magenta
        [color "status"]
          added = yellow bold
          changed = red bold
          untracked = red
          header = black bold
          branch = yellow bold
          localBranch = yellow bold
          remoteBranch = red bold
        [tig "color"]
          cursor = 15 8
          date = black default bold
          graph-commit = cyan default
          line-number = black default bold
          title-blur = 8 default
          title-focus = 15 8
          search-result = 15 8
          status = yellow default bold
      '';
      git-all = (with import <nixpkgs> {}; writeShellScriptBin "git-all" ''
        echo
        for repo in $(find -L . -maxdepth 7 -iname '.git' -type d -printf '%P\0' 2>/dev/null | xargs -0 dirname | sort); do
          echo -e "\e[0;37m  \e[0;34m$repo \e[0m(\e[0;32m$@\e[0m)"
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

