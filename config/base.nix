{ config, pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./git.nix
    ./tmux.nix
    ./vim.nix
  ];
  # latest kernel
  nixpkgs.config.allowUnfree = true;
  nix.autoOptimiseStore = true;
  environment.systemPackages = with pkgs; [
    gnumake bc
    psmisc pciutils
    tree ag
    zip unzip
    duperemove
    nox
  ];
  environment.variables = {
      EDITOR = "vim";
  };

  services.openssh.enable = true;
  services.journald.extraConfig = ''
    Storage=volatile
  '';
  # btrfs auto-scrub
  services.btrfs.autoScrub.enable = true;
  boot = {
    # /tmp on tmpfs
    tmpOnTmpfs = true;
    kernelParams = [ "quiet" ];
    consoleLogLevel = 0;
    loader.grub.useOSProber = true;
    kernel.sysctl = {
      "vm.max_map_count" = 262144;
    };
  };
  fileSystems = {
    "/".options = [ "compress=lzo" ];
    "/home".options = [ "compress=lzo" ];
  };

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
}
