{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./networking.nix
    ./zsh.nix
    ./git.nix
    ./tmux.nix
    ./vim.nix
  ];
  config = mkMerge [{
    # btrfs auto-scrub
    #services.btrfs.autoScrub.enable = true;
    #nix.autoOptimiseStore = true;
    boot = {
      # /tmp on tmpfs
      tmpOnTmpfs = true;
      kernelParams = [ "quiet" ];
      consoleLogLevel = 0;
      kernel.sysctl = {
        "vm.max_map_count" = 262144;
      };
    };
    fileSystems = {
      "/".options = [ "compress=lzo" ];
      "/home".options = [ "compress=lzo" ];
    };
    nixpkgs.config.allowUnfree = true;
    environment.variables = {
      NIX_CFLAGS_COMPILE = "-march=native";
    };
    environment.pathsToLink = [ "/include" ];
    environment.systemPackages = with pkgs; [
      gnumake bc gcc
      psmisc pciutils
      tree ag fzf
      zip unzip
      duperemove
      nox
      (with import <nixpkgs> {}; writeShellScriptBin "palette" ''
        for b in 0 1; do
          for n in {0..7}; do
            echo -en "\e[$b;3''${n}m "
          done
        echo
        done
        echo
        for n in 1 3 2 6 4 5 0 7; do
          for b in 0 1; do
            echo -en "\e[$b;3''${n}m "
          done
        done
        echo
      '')
    ];
    services.journald.extraConfig = ''
      Storage=volatile
    '';
    # default user account
    users.users.admin = {
      isNormalUser = true;
      uid = 1000;
      description = "Administrator";
      extraGroups = [ "wheel" ];
      initialHashedPassword = "$6$D85LJu3AY7$CSbcP8wY9qNgp6zA.PXAmZo6JMy4nHDldvfUDzom7XglfgRUPW6wnLJ1l0dRUQAy4SReAO85GEISAs6tZE6TV/";
    };
    users.defaultUserShell = "/run/current-system/sw/bin/zsh";
    users.mutableUsers = true;

    # This value determines the NixOS release with which your system is to be
    # compatible, in order to avoid breaking some software such as database
    # servers. You should change this only after NixOS release notes say you
    # should.
    system.stateVersion = "unstable"; # Did you read the comment?
  }];
}
