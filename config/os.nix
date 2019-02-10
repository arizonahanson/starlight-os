{ config, pkgs, ... }:

{
  environment.systemPackages = 
    let
      starlight-os = with pkgs; stdenv.mkDerivation rec {
        name = "starlight-os-v0.1";
        src = fetchFromGitHub {
          owner = "isaacwhanson";
          repo = "starlight-os";
          rev = "v0.1";
          sha256 = "1kx8rz0hiwc2xg2azfwqjhf0xwaxc680zxcllcg5m5g66cw8zjzi";
        };
            
        dontBuild = true;
        installPhase = ''
          mkdir -p $out/bin
          cp -r bin/. $out/bin/
          mkdir -p $out/src/starlight-os/
          cp -r . $out/src/starlight-os/
        '';
      };
    in
  with pkgs; [
    (starlight-os)
  ];
}

