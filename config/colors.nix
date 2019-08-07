{ config, lib, pkgs, ... }:

with lib;

{
  options.starlight = {
    # system colors
    palette = {
      foreground = mkOption {
        type = types.str;
        default = "#cccccc";
        description = ''
          Foreground color
        '';
      };
      foreground-alt = mkOption {
        type = types.str;
        default = "#808080";
        description = ''
          Alternate foreground color
        '';
      };
      background = mkOption {
        type = types.str;
        default = "#1a1a1a";
        description = ''
          Background color
        '';
      };
      background-alt = mkOption {
        type = types.str;
        default = "#4d4d4d";
        description = ''
          Alternate Background color
        '';
      };
      cursor = mkOption {
        type = types.str;
        default = "#999999";
        description = ''
          Cursor color
        '';
      };
      info = mkOption {
        type = types.str;
        default = "#b3b36b";
        description = ''
          Info color
        '';
      };
      color0 = mkOption {
        type = types.str;
        default = "#1a1a1a";
        description = ''
          color 0 (black)
        '';
      };
      color1 = mkOption {
        type = types.str;
        default = "#b36b6b";
        description = ''
          color 1 (red)
        '';
      };
      color2 = mkOption {
        type = types.str;
        default = "#6bb36b";
        description = ''
          color 2 (green)
        '';
      };
      color3 = mkOption {
        type = types.str;
        default = "#b3b36b";
        description = ''
          color 3 (yellow)
        '';
      };
      color4 = mkOption {
        type = types.str;
        default = "#6b6bb3";
        description = ''
          color 4 (blue)
        '';
      };
      color5 = mkOption {
        type = types.str;
        default = "#b36bb3";
        description = ''
          color 5 (magenta)
        '';
      };
      color6 = mkOption {
        type = types.str;
        default = "#6bb3b3";
        description = ''
          color 6 (cyan)
        '';
      };
      color7 = mkOption {
        type = types.str;
        default = "#808080";
        description = ''
          color 7 (white)
        '';
      };
      color8 = mkOption {
        type = types.str;
        default = "#4d4d4d";
        description = ''
          color 8 (dark gray)
        '';
      };
      color9 = mkOption {
        type = types.str;
        default = "#b38f6b";
        description = ''
          color 9 (bright red)
        '';
      };
      color10 = mkOption {
        type = types.str;
        default = "#6bb38f";
        description = ''
          color 10 (bright green)
        '';
      };
      color11 = mkOption {
        type = types.str;
        default = "#8fb36b";
        description = ''
          color 11 (bright yellow)
        '';
      };
      color12 = mkOption {
        type = types.str;
        default = "#8f6bb3";
        description = ''
          color 12 (bright blue)
        '';
      };
      color13 = mkOption {
        type = types.str;
        default = "#b36b8f";
        description = ''
          color 13 (bright magenta)
        '';
      };
      color14 = mkOption {
        type = types.str;
        default = "#6b8fb3";
        description = ''
          color 14 (bright cyan)
        '';
      };
      color15 = mkOption {
        type = types.str;
        default = "#cccccc";
        description = ''
          color 15 (bright white)
        '';
      };
    };
    theme = {
      background = mkOption {
        type = types.int;
        default = 0;
        description = ''
          color number for background
          default: 0
        '';
      };
      foreground = mkOption {
        type = types.int;
        default = 15;
        description = ''
          color number for foreground
          default: 15
        '';
      };
      background-alt = mkOption {
        type = types.int;
        default = 8;
        description = ''
          color number for background-alt
          default: 8
        '';
      };
      foreground-alt = mkOption {
        type = types.int;
        default = 7;
        description = ''
          color number for foreground-alt
          default: 7
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
          color number for warnings/change
          default: 9
        '';
      };
      info = mkOption {
        type = types.int;
        default = 3;
        description = ''
          color number for info
          default: 3
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
      diff-add = mkOption {
        type = types.int;
        default = 2;
        description = ''
          color number for diff-add
          default: 2
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
      executable = mkOption {
        type = types.int;
        default = 3;
        description = ''
          color number for executable
          default: 3
        '';
      };
      alias = mkOption {
        type = types.int;
        default = 11;
        description = ''
          color number for executable
          default: 11
        '';
      };
      character = mkOption {
        type = types.int;
        default = 2;
        description = ''
          color number for characters
          default: 2
        '';
      };
      string = mkOption {
        type = types.int;
        default = 10;
        description = ''
          color number for strings
          default: 10
        '';
      };
      constant = mkOption {
        type = types.int;
        default = 6;
        description = ''
          color number for constants
          default: 6
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
      type = mkOption {
        type = types.int;
        default = 12;
        description = ''
          color number for types
          default: 12
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
      keyword = mkOption {
        type = types.int;
        default = 13;
        description = ''
          color number for keywords
          default: 13
        '';
      };
      statement = mkOption {
        type = types.int;
        default = 5;
        description = ''
          color number for statements
          default: 5
        '';
      };
    };
  };
}
