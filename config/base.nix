{ config, pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./git.nix
    ./tmux.nix
  ];
  # latest kernel
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  nixpkgs.config.allowUnfree = true;
  nix.autoOptimiseStore = true;
  environment.systemPackages = with pkgs; [
    gnumake bc nvi
    wget w3m
    psmisc pciutils
    tree ag
    ranger highlight
    zip unzip
    python
    duperemove
  ];
  environment.variables = {
      EDITOR = "vi";
  };

  services.openssh.enable = true;
  services.journald.extraConfig = ''
    Storage=volatile
  '';
  # btrfs auto-scrub
  services.btrfs.autoScrub.enable = true;
  # /tmp on tmpfs
  boot.tmpOnTmpfs = true;
  boot.loader.grub.useOSProber = true;
  boot.kernel.sysctl = {
    "vm.max_map_count" = 262144;
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
