{ config, pkgs, ... }:

{
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;


  services.nixosManual.enable = true;
  services.nixosManual.showManual = true;
}
