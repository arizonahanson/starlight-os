{ config, lib, pkgs, ... }:

with lib;

{
  options.starlight = {
    # system colors
    palette = {
      color00 = mkOption {
        type = types.str;
        default = "#070707";
        description = ''
          color 0 (black)
        '';
      };
      color01 = mkOption {
        type = types.str;
        default = "#d08292";
        description = ''
          color 1 (red)
        '';
      };
      color02 = mkOption {
        type = types.str;
        default = "#73a561";
        description = ''
          color 2 (green)
        '';
      };
      color03 = mkOption {
        type = types.str;
        default = "#9e7040";
        description = ''
          color 3 (amber)
        '';
      };
      color04 = mkOption {
        type = types.str;
        default = "#689eca";
        description = ''
          color 4 (blue)
        '';
      };
      color05 = mkOption {
        type = types.str;
        default = "#bb86c5";
        description = ''
          color 5 (magenta)
        '';
      };
      color06 = mkOption {
        type = types.str;
        default = "#01ab9e";
        description = ''
          color 6 (cyan)
        '';
      };
      color07 = mkOption {
        type = types.str;
        default = "#989898";
        description = ''
          color 7 (medium gray)
        '';
      };
      color08 = mkOption {
        type = types.str;
        default = "#242424";
        description = ''
          color 8 (dark gray)
        '';
      };
      color09 = mkOption {
        type = types.str;
        default = "#c78a72";
        description = ''
          color 9 (orange)
        '';
      };
      color10 = mkOption {
        type = types.str;
        default = "#44aa7f";
        description = ''
          color 10 (aquamarine)
        '';
      };
      color11 = mkOption {
        type = types.str;
        default = "#b49457";
        description = ''
          color 11 (yellow)
        '';
      };
      color12 = mkOption {
        type = types.str;
        default = "#9991cf";
        description = ''
          color 12 (violet)
        '';
      };
      color13 = mkOption {
        type = types.str;
        default = "#cd80b0";
        description = ''
          color 13 (rose)
        '';
      };
      color14 = mkOption {
        type = types.str;
        default = "#2ba7b9";
        description = ''
          color 14 (azure)
        '';
      };
      color15 = mkOption {
        type = types.str;
        default = "#b9b9b9";
        description = ''
          color 15 (white)
        '';
      };
      gtk = mkOption {
        type = types.str;
        default = "#0b0b0b";
        description = ''
          GTK Background color
        '';
      };
      cursor = mkOption {
        type = types.str;
        default = "#5b5b5b";
        description = ''
          Cursor color
        '';
      };
    };
    theme = {
      bg = mkOption {
        type = types.int;
        default = 0;
        description = ''
          color number for background
          default: 0
        '';
      };
      fg = mkOption {
        type = types.int;
        default = 15;
        description = ''
          color number for foreground
          default: 15
        '';
      };
      bg-alt = mkOption {
        type = types.int;
        default = 8;
        description = ''
          color number for background-alt
          default: 8
        '';
      };
      fg-alt = mkOption {
        type = types.int;
        default = 7;
        description = ''
          color number for foreground-alt
          default: 7
        '';
      };
      accent = mkOption {
        type = types.int;
        default = 3;
        description = ''
          color number for accent
          default: 3
        '';
      };
      error = mkOption {
        type = types.int;
        default = 1;
        description = ''
          color number for errors/unknown
          default: 1
        '';
      };
      warning = mkOption {
        type = types.int;
        default = 9;
        description = ''
          color number for warnings
          default: 9
        '';
      };
      info = mkOption {
        type = types.int;
        default = 11;
        description = ''
          color number for info
          default: 11
        '';
      };
      pattern = mkOption {
        type = types.int;
        default = 12;
        description = ''
          color number for patterns
          default: 12
        '';
      };
      match = mkOption {
        type = types.int;
        default = 9;
        description = ''
          color number for matches
          default: 9
        '';
      };
      substitution = mkOption {
        type = types.int;
        default = 7;
        description = ''
          color number for substitutions
          default: 7
        '';
      };
      select = mkOption {
        type = types.int;
        default = 11;
        description = ''
          color number for selections
          default: 11
        '';
      };
      executable = mkOption {
        type = types.int;
        default = 2;
        description = ''
          color number for executable
          default: 2
        '';
      };
      function = mkOption {
        type = types.int;
        default = 6;
        description = ''
          color number for functions
          default: 6
        '';
      };
      keyword = mkOption {
        type = types.int;
        default = 12;
        description = ''
          color number for keywords
          default: 12
        '';
      };
      statement = mkOption {
        type = types.int;
        default = 10;
        description = ''
          color number for statements
          default: 10
        '';
      };
      type = mkOption {
        type = types.int;
        default = 4;
        description = ''
          color number for types
          default: 4
        '';
      };
      boolean = mkOption {
        type = types.int;
        default = 5;
        description = ''
          color number for booleans
          default: 5
        '';
      };
      constant = mkOption {
        type = types.int;
        default = 13;
        description = ''
          color number for constants
          default: 13
        '';
      };
      character = mkOption {
        type = types.int;
        default = 11;
        description = ''
          color number for characters
          default: 11
        '';
      };
      string = mkOption {
        type = types.int;
        default = 3;
        description = ''
          color number for strings
          default: 3
        '';
      };
      number = mkOption {
        type = types.int;
        default = 14;
        description = ''
          color number for numbers
          default: 14
        '';
      };
      path = mkOption {
        type = types.int;
        default = 4;
        description = ''
          color number for paths
          default: 4
        '';
      };
      socket = mkOption {
        type = types.int;
        default = 12;
        description = ''
          color number for sockets
          default: 12
        '';
      };
      localBranch = mkOption {
        type = types.int;
        default = 4;
        description = ''
          color number for local branches
          default: 4
        '';
      };
      currentBranch = mkOption {
        type = types.int;
        default = 12;
        description = ''
          color number for current branch
          default: 12
        '';
      };
      remoteBranch = mkOption {
        type = types.int;
        default = 5;
        description = ''
          color number for remote branches
          default: 5
        '';
      };
      staged = mkOption {
        type = types.int;
        default = 11;
        description = ''
          color number for staged items
          default: 11
        '';
      };
      diff-add = mkOption {
        type = types.int;
        default = 2;
        description = ''
          color number for diff-add
          default: 2
        '';
      };
      diff-add-moved = mkOption {
        type = types.int;
        default = 10;
        description = ''
          color number for diff-add-moved
          default: 10
        '';
      };
      diff-change = mkOption {
        type = types.int;
        default = 9;
        description = ''
          color number for diff-change
          default: 9
        '';
      };
      diff-remove-moved = mkOption {
        type = types.int;
        default = 9;
        description = ''
          color number for diff-remove-moved
          default: 9
        '';
      };
      diff-remove = mkOption {
        type = types.int;
        default = 1;
        description = ''
          color number for diff-remove
          default: 1
        '';
      };
    };
  };
  config =
    let
      theme = config.starlight.theme;
      colorMap = {
        "0" = 0;
        "8" = 1;
        "7" = 2;
        "15" = 3;
        "1" = 4;
        "9" = 5;
        "3" = 6;
        "11" = 7;
        "2" = 8;
        "10" = 9;
        "6" = 10;
        "14" = 11;
        "4" = 12;
        "12" = 13;
        "5" = 14;
        "13" = 15;
      };
      colorIndex = num: colorMap.${toString num};
      colorSort = a: b: lessThan (colorIndex theme.${a}) (colorIndex theme.${b});
      toANSI = num: "38;5;${toString num}";
      paletteScript = (
        with import <nixpkgs> { }; writeShellScriptBin "palette" ''
          for bold in 0 1; do
            for col in {0..7}; do
              echo -en "\e[$bold;3''${col}m $(printf '%X' $((col+bold*8))) "
            done; echo
          done; echo
          for col in 2 6 4 5 1 3 0 7; do
            echo -en "\e[0;3''${col}m \e[1;3''${col}m "
          done; echo
          for col in 2 6 4 5 1 3 0 7; do
            echo -en "\e[0;3''${col}m$(printf '%X' $col) \e[1;3''${col}m$(printf '%X' $((col+8))) "
          done; echo
        ''
      );
      themeScript = (
        with import <nixpkgs> { };
        writeShellScriptBin "theme"
          ((concatStringsSep "\n" (
            map (name: "echo -en '\\e[${toANSI theme.${name}}m" + name + "\\e[0m '")
              (sort colorSort (attrNames theme))))
          + "\necho"
          )
      );
    in
    {
      environment.systemPackages = [
        (paletteScript)
        (themeScript)
      ];
    };
}
