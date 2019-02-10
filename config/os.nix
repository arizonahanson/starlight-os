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
          sha256 = "0jx6w251akc5q9m23hh8v1nykq7w84ryggybjp1lzkk77cf7806x";
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

