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
  options.starlight = {
    localTime = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, will use local time (dual boot)
      '';
    };
    insertCursor = mkOption {
      type = types.int;
      default = 5;
      description = ''
        cursor code for insert mode
      '';
    };
    replaceCursor = mkOption {
      type = types.int;
      default = 3;
      description = ''
        cursor code for replace mode
      '';
    };
    commandCursor = mkOption {
      type = types.int;
      default = 1;
      description = ''
        cursor code for command mode
      '';
    };
  };
  config = mkMerge [{
    boot = {
      tmpOnTmpfs = true;
      kernelParams = [ "quiet" ];
      consoleLogLevel = 0;
      kernel.sysctl = {
        "vm.max_map_count" = 262144;
      };
    };
    fileSystems = {
      "/".options = [ "compress-force=lzo" "noatime" ];
      "/home".options = [ "compress-force=lzo" "noatime" ];
    };
    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };
    nix.gc = {
      automatic = true;
      dates = "*-*-* 00/4:00:00";
      options = "--delete-older-than 30d";
    };
    nix.autoOptimiseStore = true;
    nixpkgs.config.allowUnfree = true;
    environment.variables = {
      NIX_CFLAGS_COMPILE = "-march=native";
    };
    environment.pathsToLink = [ "/include" ];
    environment.systemPackages = with pkgs; [
      gnumake bc gcc binutils
      psmisc pciutils
      tree ag fzf
      zip unzip
      duperemove compsize
      nox w3m ncdu stow bind highlight
      (with import <nixpkgs> {}; writeShellScriptBin "palette" ''
        for col in 1 3 2 6 4 5; do
          for bold in 0 1; do
            echo -en "\e[$bold;3''${col}m "
          done
        done
        echo
        for col in 7 0; do
          for bold in 1 0; do
            echo -en "\e[$bold;3''${col}m "
          done
        done
        echo
      '')
    ] ++ optional config.starlight.efi gptfdisk;
    services.journald.extraConfig = ''
      Storage=volatile
    '';
    time.hardwareClockInLocalTime = config.starlight.localTime;
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
    system.stateVersion = "19.09"; # Did you read the comment?
  }];
}
