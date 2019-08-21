{ config, pkgs, ... }:

{
  environment = let
    theme = config.starlight.theme;
    toANSI = num: if num <= 7 then "00;3${toString num}" else "01;3${toString (num - 8)}";
    git-minimal = ((pkgs.git.overrideAttrs (oldAttrs: rec { doInstallCheck = false; })).override {
      guiSupport = false;
      pythonSupport = false;
      perlSupport = false;
      withManual = false; # time consuming
      withLibsecret = true;
    });
    git-config = ''
      [core]
        autocrlf = false
        filemode = true
      [diff]
        algorithm = minimal
        colorMoved = blocks
      [difftool]
        prompt = false
      [fetch]
        prune = true
        pruneTags = true
      [help]
        autocorrect = 30
        format = html
        htmlpath = "https://git-scm.com/docs"
      [merge]
        conflictstyle = diff3
        tool = vimdiff
      [mergetool]
        keepBackup = false
        prompt = false
      [pack]
        threads = ${toString config.nix.maxJobs}
      [push]
        default = current
      [color]
        ui = auto
      [color "grep"]
        filename = ${toString theme.path}
        linenumber = ${toString theme.background-alt}
        match = ${toString theme.match}
        separator = ${toString theme.foreground-alt}
      [color "diff"]
        commit = ${toString theme.number}
        frag = ${toString theme.foreground-alt}
        meta = ${toString theme.background-alt}
        new = ${toString theme.diff-add}
        newMoved = ${toString theme.diff-add-moved}
        old = ${toString theme.diff-remove}
        oldMoved = ${toString theme.diff-remove-moved}
      [color "branch"]
        current = ${toString theme.currentBranch}
        local = ${toString theme.localBranch}
        remote = ${toString theme.remoteBranch}
      [color "decorate"]
        HEAD = ${toString theme.localBranch}
        branch = ${toString theme.currentBranch}
        remoteBranch = ${toString theme.remoteBranch}
        stash = ${toString theme.localBranch}
        tag = ${toString theme.remoteBranch}
      [color "remote"]
        hint = ${toString theme.foreground-alt}
        success = ${toString theme.info}
        warning = ${toString theme.warning}
        error = ${toString theme.error}
      [color "status"]
        header = ${toString theme.background-alt}
        added = ${toString theme.info}
        changed = ${toString theme.diff-change}
        untracked = ${toString theme.diff-remove}
        branch = ${toString theme.currentBranch}
        localBranch = ${toString theme.currentBranch}
        remoteBranch = ${toString theme.remoteBranch}
      [tig "color"]
        cursor = ${toString theme.select} default
        date = ${toString theme.background-alt} default
        graph-commit = ${toString theme.number} default
        line-number = ${toString theme.background-alt} default
        main-tracked = ${toString theme.currentBranch} default
        search-result = ${toString theme.match} default
        status = ${toString theme.info} default
        title-blur = ${toString theme.background-alt} default
        title-focus = ${toString theme.foreground} ${toString theme.background-alt}
    '';
    git-all = (with import <nixpkgs> {}; writeShellScriptBin "git-all" ''
      echo
      for repo in $(find -L . -maxdepth 7 -iname '.git' -type d -printf '%P\0' 2>/dev/null | xargs -0 dirname | sort); do
        echo -e "\e[${toANSI theme.foreground-alt}m  \e[${toANSI theme.path}m$repo \e[0m(\e[${toANSI theme.function}m$@\e[0m)"
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
          [web]
            browser = "chromium"
          ${git-config}
        '';
      } else {
        text = ''
          [web]
            browser = "w3m"
          ${git-config}
        '';
      };
    };
  programs.zsh.shellAliases = {
    gg = "git all";
    gga = "";
    ggl = "git all pull";
    ggc = "git all gc";
    ggs = "git all status -sb";
    ggrp = "git all remote prune origin";
    ggx = "sudo git all clean -fxd";
  };
}

