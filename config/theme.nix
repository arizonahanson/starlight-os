{ config, pkgs, ... }:

{
  environment.systemPackages = 
    let
      starlight-gtk-theme = with pkgs; stdenv.mkDerivation rec {
        name = "starlight-gtk-theme-v0.6";
        src = fetchFromGitHub {
          owner = "isaacwhanson";
          repo = "starlight-gtk-theme";
          rev = "v0.6";
          sha256 = "1y4s7c8vf8fzicxqqgd5ff7svd20kl1xvbbjjpirkjf0dv9dic54";
        };
            
        dontBuild = true;
        installPhase = ''
          mkdir -p $out/share/themes/starlight/
          cp -r . $out/share/themes/starlight/
        '';
      };
      starlight-icon-theme = with pkgs; stdenv.mkDerivation rec {
        name = "starlight-icon-theme-v0.3";
        src = fetchFromGitHub {
          owner = "isaacwhanson";
          repo = "starlight-icon-theme";
          rev = "v0.3";
          sha256 = "0bpv4xv7v9j3bxj0lwnzhz9h07nbp69zgq3kkdyilkzk0i4j3h25";
        };
            
        dontBuild = true;
        installPhase = ''
          mkdir -p $out/share/icons/starlight/
          cp -r . $out/share/icons/starlight/
        '';
      };
    in
  with pkgs; [
    capitaine-cursors gtk-engine-murrine
    (starlight-gtk-theme) (starlight-icon-theme)
  ];
}

