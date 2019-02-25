{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./grub.nix
    ./base.nix
    ./locale.nix
    ./server.nix
    ./desktop.nix
    ./docker.nix
  ];
  config = let osupdate = (with import <nixpkgs> {}; writeShellScriptBin "os-update" ''
    renice 19 -p $$
    echo -e "Fetching configuration..."
    gitdir="$(mktemp -d --tmpdir starlight-os_XXXXXX)"
    git clone -q --depth 1 https://github.com/isaacwhanson/starlight-os.git $gitdir
    cd $gitdir
    make upgrade
    cd /tmp
    #rm $gitdir -rf
  '');
  in
  {
    environment.systemPackages = with pkgs; [
      (osupdate)
      (with import <nixpkgs> {}; writeShellScriptBin "os-drop" ''
        sudo nix-collect-garbage -d
        nix-env --delete-generations old
      '')
    ];
    systemd.services.auto-update = {
      serviceConfig.Type = "oneshot"; 
      wantedBy = [ "multi-user.target" ];
      unitConfig.X-StopOnRemoval = false;
      environment = config.nix.envVars // {
        inherit (config.environment.sessionVariables) NIX_PATH;
        HOME = "/root";
      } // config.networking.proxy.envVars;
      path = with pkgs; [ (osupdate) gnumake gitMinimal utillinux sudo nix gnutar xz.bin config.nix.package.out config.system.build.nixos-rebuild ];
      restartIfChanged = false;
      enable = false;
      script = ''
        os-update
      ''; 
    }; 
  };
}

