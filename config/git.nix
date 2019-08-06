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
        commit = ${toString theme.number}
        meta = ${toString theme.background-alt}
        frag = ${toString theme.foreground-alt}
        new = ${toString theme.diff-add}
        old = ${toString theme.diff-remove}
      [color "branch"]
        remote = ${toString theme.remoteBranch}
        current = ${toString theme.currentBranch}
        local = ${toString theme.localBranch}
      [color "decorate"]
        HEAD = ${toString theme.localBranch}
        tag = ${toString theme.remoteBranch}
        branch = ${toString theme.currentBranch}
        stash = ${toString theme.localBranch}
        remoteBranch = ${toString theme.remoteBranch}
      [color "status"]
        added = ${toString theme.info}
        changed = ${toString theme.warning}
        untracked = ${toString theme.error}
        header = ${toString theme.background-alt}
        branch = ${toString theme.currentBranch}
        localBranch = ${toString theme.localBranch}
        remoteBranch = ${toString theme.remoteBranch}
      [tig "color"]
        graph-commit = ${toString theme.number} default
        main-tracked = ${toString theme.currentBranch} default
        cursor = ${toString theme.foreground} ${toString theme.background-alt}
        date = ${toString theme.background-alt} default
        line-number = ${toString theme.background-alt} default
        title-blur = ${toString theme.background-alt} default
        title-focus = ${toString theme.foreground} ${toString theme.background-alt}
        search-result = ${toString theme.foreground} ${toString theme.background-alt}
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

