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
        separator = ${toString theme.foreground-alt}
        filename = ${toString theme.path}
        linenumber = ${toString theme.background-alt}
        match = ${toString theme.foreground} ${toString theme.background-alt}
      [color "diff"]
        commit = cyan bold
        meta = ${toString theme.background-alt}
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
        added = ${toString theme.info}
        changed = ${toString theme.warning}
        untracked = ${toString theme.error}
        header = ${toString theme.background-alt}
        branch = blue bold
        localBranch = blue
        remoteBranch = cyan bold
      [tig "color"]
        cursor = ${toString theme.foreground} ${toString theme.background-alt}
        date = ${toString theme.background-alt} default
        graph-commit = cyan default bold
        line-number = ${toString theme.background-alt} default
        main-tracked = cyan default bold
        title-blur = ${toString theme.background-alt} default
        title-focus = ${toString theme.foreground} ${toString theme.background-alt}
        search-result = 15 8
        status = ${toString theme.info} default
    '';
    git-all = (with import <nixpkgs> {}; writeShellScriptBin "git-all" ''
      echo
      for repo in $(find -L . -maxdepth 7 -iname '.git' -type d -printf '%P\0' 2>/dev/null | xargs -0 dirname | sort); do
        echo -e "\e[${toANSI theme.foreground-alt}m  \e[${toANSI theme.path}m$repo \e[0m(\e[${toANSI theme.alias}m$@\e[0m)"
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

