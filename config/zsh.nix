{ config, lib, pkgs, ... }:

with lib;

{
  config = let
    theme = config.starlight.theme;
    toANSI = num: if num <= 7 then "00;3${toString num}" else "01;3${toString (num - 8)}";
  in {
    programs.zsh.enable = true;
    programs.zsh.autosuggestions = {
      enable = true;
      strategy = "match_prev_cmd";
      highlightStyle = "fg=${toString theme.background-alt}";
    };
    programs.zsh.syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "cursor" "root" "line" ];
    };
    programs.zsh.ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "colored-man-pages"
      ];
      cacheDir = "/tmp/.ohmyzsh-$USER";
      customPkgs = [ pkgs.zsh-completions pkgs.nix-zsh-completions ];
    };
    # zprofile (once, before zshrc)
    programs.zsh.loginShellInit = ''
      eval `dircolors -b /etc/dircolors`
    '';
    # zshrc (start)
    programs.zsh.enableGlobalCompInit = false;
    environment.interactiveShellInit = ''
      # keep zcompdump in tmpfs
      mkdir -p "/tmp/.zcompdump-''${USER}"
      autoload -U compinit && compinit -d "/tmp/.zcompdump-''${USER}/zcompdump"
      bindkey -v
      # spellcheck commands
      setopt correct
      # backspace
      bindkey -a '^?' vi-backward-delete-char
      # home
      bindkey -a '\e[1~' vi-first-non-blank
      bindkey '\e[1~' vi-first-non-blank
      # insert
      bindkey -a '\e[2~' vi-insert
      bindkey '\e[2~' vi-insert # noop?
      # delete
      bindkey '\e[3~' vi-delete-char
      bindkey -a '\e[3~' vi-delete-char
      # end
      bindkey -a '\e[4~'  vi-end-of-line
      bindkey '\e[4~'  vi-end-of-line
      bindkey  "''${terminfo[khome]}" vi-beginning-of-line
      bindkey -a "''${terminfo[khome]}" vi-beginning-of-line
      bindkey  "''${terminfo[kend]}" vi-end-of-line
      bindkey -a "''${terminfo[kend]}" vi-end-of-line
      # complete word
      bindkey '^w' vi-forward-word
    '';
    # zshrc (end)
    programs.zsh.promptInit = let
      toFG = num: "$FG[${fixedWidthString 3 "0" (toString num)}]";
    in ''
      # vi-like editing
      bindkey -v
      # save prompt status
      zle-line-init() {
        typeset -g __prompt_status="$?"
      }
      zle -N zle-line-init
      # cursor shows mode
      zle-keymap-select () {
        if [ ! "$TERM" = "linux" ]; then
          if [ $KEYMAP = vicmd ]; then
            echo -ne "\e[1 q"
          else
            echo -ne "\e[3 q"
          fi
        fi
        () { return $__prompt_status }
        zle reset-prompt
      }
      zle -N zle-keymap-select

      # better 'help'
      autoload -Uz run-help
      unalias run-help
      alias help=run-help

      bindkey '^ ' autosuggest-accept
      ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=vi-forward-char
      #ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=""

      export ZSH_HIGHLIGHT_STYLES[cursor]='fg=${toString theme.select}'
      export ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='fg=${toString theme.match}'
      export ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=${toString theme.error}'
      export ZSH_HIGHLIGHT_STYLES[path]='fg=${toString theme.path}'
      export ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=${toString theme.pattern}'
      export ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=${toString theme.pattern}'
      export ZSH_HIGHLIGHT_STYLES[globbing]='fg=${toString theme.pattern}'
      export ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=${toString theme.character}'
      export ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=${toString theme.character}'
      export ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=${toString theme.string}'
      export ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=${toString theme.alias}'
      export ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=${toString theme.alias}'
      export ZSH_HIGHLIGHT_STYLES[alias]='fg=${toString theme.alias}'
      export ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=${toString theme.alias}'
      export ZSH_HIGHLIGHT_STYLES[function]='fg=${toString theme.executable}'
      export ZSH_HIGHLIGHT_STYLES[precommand]='fg=${toString theme.warning}'
      export ZSH_HIGHLIGHT_STYLES[command]='fg=${toString theme.executable}'
      export ZSH_HIGHLIGHT_STYLES[builtin]='fg=${toString theme.keyword}'
      export ZSH_HIGHLIGHT_STYLES[redirection]='fg=${toString theme.keyword}'
      export ZSH_HIGHLIGHT_STYLES[arg0]='fg=${toString theme.keyword}'
      export ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=${toString theme.keyword}'
      export ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=${toString theme.statement}'
      export ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=${toString theme.constant}'
      export ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=${toString theme.number}'
      
      # fzf with tmux
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS} ma='${toANSI theme.select}'

      # last to pickup other zsh-widgets
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      ZSH_THEME_PROMPT=""
      ZSH_THEME_PROMPT2=" "
      ZSH_THEME_PROMPT_ROOT=""
      ZSH_THEME_AHEAD_PROMPT=''
      ZSH_THEME_BEHIND_PROMPT=''
      ZSH_THEME_UNTRACKED_PROMPT=" "
      ZSH_THEME_NOUPSTREAM_PROMPT=" "
      ZSH_THEME_STASHED_PROMPT=" "
      ZSH_THEME_STAGED_PROMPT=" "
      ZSH_THEME_CHANGED_PROMPT=" "
      ZSH_THEME_HOME_PROMPT=" "

      # bash/zsh git prompt support
      #
      # Copyright (C) 2006,2007 Shawn O. Pearce <spearce@spearce.org>
      # Distributed under the GNU General Public License, version 2.0.
      #
      # if you set GIT_PS1_SHOWDIRTYSTATE to a nonempty value,
      # unstaged (*) and staged (+) changes will be shown next to the branch
      # name.  You can configure this per-repository with the
      # bash.showDirtyState variable, which defaults to true once
      # GIT_PS1_SHOWDIRTYSTATE is enabled.
      GIT_PS1_SHOWDIRTYSTATE=1
      #
      # You can also see if currently something is stashed, by setting
      # GIT_PS1_SHOWSTASHSTATE to a nonempty value. If something is stashed,
      # then a '$' will be shown next to the branch name.
      GIT_PS1_SHOWSTASHSTATE=1
      # If you would like to see if there're untracked files, then you can set
      # GIT_PS1_SHOWUNTRACKEDFILES to a nonempty value. If there're untracked
      # files, then a '%' will be shown next to the branch name.  You can
      # configure this per-repository with the bash.showUntrackedFiles
      # variable, which defaults to true once GIT_PS1_SHOWUNTRACKEDFILES is
      # enabled.
      GIT_PS1_SHOWUNTRACKEDFILES=1
      # If you would like to see the difference between HEAD and its upstream,
      # set GIT_PS1_SHOWUPSTREAM="auto".  A "<" indicates you are behind, ">"
      # indicates you are ahead, "<>" indicates you have diverged and "="
      # indicates that there is no difference. You can further control
      # behaviour by setting GIT_PS1_SHOWUPSTREAM to a space-separated list
      # of values:
      GIT_PS1_SHOWUPSTREAM="verbose"
      #     verbose       show number of commits ahead/behind (+/-) upstream
      #     name          if verbose, then also show the upstream abbrev name
      #     legacy        don't use the '--count' option available in recent
      #                   versions of git-rev-list
      #     git           always compare HEAD to @{upstream}
      #     svn           always compare HEAD to your SVN upstream
      #
      # You can change the separator between the branch name and the above
      # state symbols by setting GIT_PS1_STATESEPARATOR. The default separator
      # is SP.
      GIT_PS1_STATESEPARATOR=' '
      # By default, __git_ps1 will compare HEAD to your SVN upstream if it can
      # find one, or @{upstream} otherwise.  Once you have set
      # GIT_PS1_SHOWUPSTREAM, you can override it on a per-repository basis by
      # setting the bash.showUpstream config variable.
      #
      # If you would like to see more information about the identity of
      # commits checked out as a detached HEAD, set GIT_PS1_DESCRIBE_STYLE
      # to one of these values:
      #
      #     contains      relative to newer annotated tag (v1.6.3.2~35)
      #     branch        relative to newer tag or branch (master~4)
      #     describe      relative to older annotated tag (v1.6.3.1-13-gdd42c2f)
      #     default       exactly matching tag
      #
      # If you would like __git_ps1 to do nothing in the case when the current
      # directory is set up to be ignored by git, then set
      # GIT_PS1_HIDE_IF_PWD_IGNORED to a nonempty value. Override this on the
      # repository level by setting bash.hideIfPwdIgnored to "false".
      ZLE_RPROMPT_INDENT=0
      # check whether printf supports -v
      __git_printf_supports_v=
      printf -v __git_printf_supports_v -- '%s' yes >/dev/null 2>&1

      # stores the divergence from upstream in $p
      # used by GIT_PS1_SHOWUPSTREAM
      __git_ps1_show_upstream ()
      {
              local key value
              local svn_remote svn_url_pattern count n
              local upstream=git legacy="" verbose="" name=""

              svn_remote=()
              # get some config options from git-config
              local output="$(git config -z --get-regexp '^(svn-remote\..*\.url|bash\.showupstream)$' 2>/dev/null | tr '\0\n' '\n ')"
              while read -r key value; do
                      case "$key" in
                      bash.showupstream)
                              GIT_PS1_SHOWUPSTREAM="$value"
                              if [[ -z "''${GIT_PS1_SHOWUPSTREAM}" ]]; then
                                      p=""
                                      return
                              fi
                              ;;
                      svn-remote.*.url)
                              svn_remote[$((''${#svn_remote[@]} + 1))]="$value"
                              svn_url_pattern="$svn_url_pattern\\|$value"
                              upstream=svn+git # default upstream is SVN if available, else git
                              ;;
                      esac
              done <<< "$output"

              # parse configuration values
              for option in ''${GIT_PS1_SHOWUPSTREAM}; do
                      case "$option" in
                      git|svn) upstream="$option" ;;
                      verbose) verbose=1 ;;
                      legacy)  legacy=1  ;;
                      name)    name=1 ;;
                      esac
              done

              # Find our upstream
              case "$upstream" in
              git)    upstream="@{upstream}" ;;
              svn*)
                      # get the upstream from the "git-svn-id: ..." in a commit message
                      # (git-svn uses essentially the same procedure internally)
                      local -a svn_upstream
                      svn_upstream=($(git log --first-parent -1 \
                                              --grep="^git-svn-id: \(''${svn_url_pattern#??}\)" 2>/dev/null))
                      if [[ 0 -ne ''${#svn_upstream[@]} ]]; then
                              svn_upstream=''${svn_upstream[''${#svn_upstream[@]} - 2]}
                              svn_upstream=''${svn_upstream%@*}
                              local n_stop="''${#svn_remote[@]}"
                              for ((n=1; n <= n_stop; n++)); do
                                      svn_upstream=''${svn_upstream#''${svn_remote[$n]}}
                              done

                              if [[ -z "$svn_upstream" ]]; then
                                      # default branch name for checkouts with no layout:
                                      upstream=''${GIT_SVN_ID:-git-svn}
                              else
                                      upstream=''${svn_upstream#/}
                              fi
                      elif [[ "svn+git" = "$upstream" ]]; then
                              upstream="@{upstream}"
                      fi
                      ;;
              esac

              # Find how many commits we are ahead/behind our upstream
              if [[ -z "$legacy" ]]; then
                      count="$(git rev-list --count --left-right \
                                      "$upstream"...HEAD 2>/dev/null)"
              else
                      # produce equivalent output to --count for older versions of git
                      local commits
                      if commits="$(git rev-list --left-right "$upstream"...HEAD 2>/dev/null)"
                      then
                              local commit behind=0 ahead=0
                              for commit in $commits
                              do
                                      case "$commit" in
                                      "<"*) ((behind++)) ;;
                                      *)    ((ahead++))  ;;
                                      esac
                              done
                              count="$behind	$ahead"
                      else
                              count=""
                      fi
              fi

              # calculate the result
              if [[ -z "$verbose" ]]; then
                      case "$count" in
                      "") # no upstream
                              p="" ;;
                      "0	0") # equal to upstream
                              p="" ;;
                      "0	"*) # ahead of upstream
                              p=">" ;;
                      *"	0") # behind upstream
                              p="<" ;;
                      *)	    # diverged from upstream
                              p="<>" ;;
                      esac
              else
                      case "$count" in
                      "") # no upstream
                              p="${toFG theme.error}$ZSH_THEME_NOUPSTREAM_PROMPT%{$reset_color%}" ;;
                      "0	0") # equal to upstream
                              p="" ;;
                      "0	"*) # ahead of upstream
                              p="${toFG theme.diff-add}''${count#0	}$ZSH_THEME_AHEAD_PROMPT%{$reset_color%}" ;;
                      *"	0") # behind upstream
                              p="${toFG theme.warning}''${count%	0}$ZSH_THEME_BEHIND_PROMPT%{$reset_color%}" ;;
                      *)	    # diverged from upstream
                              p="${toFG theme.diff-remove}''${count#*	}''${ZSH_THEME_AHEAD_PROMPT/ /}''${count%	*}$ZSH_THEME_BEHIND_PROMPT%{$reset_color%}" ;;
                      esac
                      if [[ -n "$count" && -n "$name" ]]; then
                              __git_ps1_upstream_name=$(git rev-parse \
                                      --abbrev-ref "$upstream" 2>/dev/null)
                              if [ $pcmode = yes ] && [ $ps1_expanded = yes ]; then
                                      p="$p \''${__git_ps1_upstream_name} "
                              else
                                      p="$p ''${__git_ps1_upstream_name} "
                                      # not needed anymore; keep user's
                                      # environment clean
                                      unset __git_ps1_upstream_name
                              fi
                      fi
              fi

      }

      __git_eread ()
      {
              local f="$1"
              shift
              test -r "$f" && read "$@" <"$f"
      }

      # __git_ps1 accepts 0 or 1 arguments (i.e., format string)
      # when called from PS1 using command substitution
      # in this mode it prints text to add to bash PS1 prompt (includes branch name)
      #
      # __git_ps1 requires 2 or 3 arguments when called from PROMPT_COMMAND (pc)
      # in that case it _sets_ PS1. The arguments are parts of a PS1 string.
      # when two arguments are given, the first is prepended and the second appended
      # to the state string when assigned to PS1.
      # The optional third parameter will be used as printf format string to further
      # customize the output of the git-status string.
      # In this mode you can request colored hints using GIT_PS1_SHOWCOLORHINTS=true
      __git_ps1 ()
      {
              # preserve exit status
              local exit=$?
              local pcmode=no
              local detached=no
              local ps1pc_start='\u@\h:\w '
              local ps1pc_end='\$ '
              local printf_format=' (%s)'

              case "$#" in
                      2|3)	pcmode=yes
                              ps1pc_start="$1"
                              ps1pc_end="$2"
                              printf_format="''${3:-$printf_format}"
                              # set PS1 to a plain prompt so that we can
                              # simply return early if the prompt should not
                              # be decorated
                              PS1="$ps1pc_start$ps1pc_end"
                      ;;
                      0|1)	printf_format="''${1:-$printf_format}"
                      ;;
                      *)	return $exit
                      ;;
              esac

              # ps1_expanded:  This variable is set to 'yes' if the shell
              # subjects the value of PS1 to parameter expansion:
              #
              #   * bash does unless the promptvars option is disabled
              #   * zsh does not unless the PROMPT_SUBST option is set
              #   * POSIX shells always do
              #
              # If the shell would expand the contents of PS1 when drawing
              # the prompt, a raw ref name must not be included in PS1.
              # This protects the user from arbitrary code execution via
              # specially crafted ref names.  For example, a ref named
              # 'refs/heads/$(IFS=_;cmd=sudo_rm_-rf_/;$cmd)' might cause the
              # shell to execute 'sudo rm -rf /' when the prompt is drawn.
              #
              # Instead, the ref name should be placed in a separate global
              # variable (in the __git_ps1_* namespace to avoid colliding
              # with the user's environment) and that variable should be
              # referenced from PS1.  For example:
              #
              #     __git_ps1_foo=$(do_something_to_get_ref_name)
              #     PS1="...stuff...\''${__git_ps1_foo}...stuff..."
              #
              # If the shell does not expand the contents of PS1, the raw
              # ref name must be included in PS1.
              #
              # The value of this variable is only relevant when in pcmode.
              #
              # Assume that the shell follows the POSIX specification and
              # expands PS1 unless determined otherwise.  (This is more
              # likely to be correct if the user has a non-bash, non-zsh
              # shell and safer than the alternative if the assumption is
              # incorrect.)
              #
              local ps1_expanded=yes
              [ -z "''${ZSH_VERSION-}" ] || [[ -o PROMPT_SUBST ]] || ps1_expanded=no
              [ -z "''${BASH_VERSION-}" ] || shopt -q promptvars || ps1_expanded=no

              local repo_info rev_parse_exit_code
              repo_info="$(git rev-parse --git-dir --is-inside-git-dir \
                      --is-bare-repository --is-inside-work-tree \
                      --short HEAD 2>/dev/null)"
              rev_parse_exit_code="$?"

              if [ -z "$repo_info" ]; then
                      return $exit
              fi

              local short_sha=""
              if [ "$rev_parse_exit_code" = "0" ]; then
                      short_sha="''${repo_info##*$'\n'}"
                      repo_info="''${repo_info%$'\n'*}"
              fi
              local inside_worktree="''${repo_info##*$'\n'}"
              repo_info="''${repo_info%$'\n'*}"
              local bare_repo="''${repo_info##*$'\n'}"
              repo_info="''${repo_info%$'\n'*}"
              local inside_gitdir="''${repo_info##*$'\n'}"
              local g="''${repo_info%$'\n'*}"

              if [ "true" = "$inside_worktree" ] &&
                 [ -n "''${GIT_PS1_HIDE_IF_PWD_IGNORED-}" ] &&
                 [ "$(git config --bool bash.hideIfPwdIgnored)" != "false" ] &&
                 git check-ignore -q .
              then
                      return $exit
              fi

              local r=""
              local b=""
              local step=""
              local total=""
              if [ -d "$g/rebase-merge" ]; then
                      __git_eread "$g/rebase-merge/head-name" b
                      __git_eread "$g/rebase-merge/msgnum" step
                      __git_eread "$g/rebase-merge/end" total
                      if [ -f "$g/rebase-merge/interactive" ]; then
                              r="|REBASE-i"
                      else
                              r="|REBASE-m"
                      fi
              else
                      if [ -d "$g/rebase-apply" ]; then
                              __git_eread "$g/rebase-apply/next" step
                              __git_eread "$g/rebase-apply/last" total
                              if [ -f "$g/rebase-apply/rebasing" ]; then
                                      __git_eread "$g/rebase-apply/head-name" b
                                      r="|REBASE"
                              elif [ -f "$g/rebase-apply/applying" ]; then
                                      r="|AM"
                              else
                                      r="|AM/REBASE"
                              fi
                      elif [ -f "$g/MERGE_HEAD" ]; then
                              r="|MERGING"
                      elif [ -f "$g/CHERRY_PICK_HEAD" ]; then
                              r="|CHERRY-PICKING"
                      elif [ -f "$g/REVERT_HEAD" ]; then
                              r="|REVERTING"
                      elif [ -f "$g/BISECT_LOG" ]; then
                              r="|BISECTING"
                      fi

                      if [ -n "$b" ]; then
                              :
                      elif [ -h "$g/HEAD" ]; then
                              # symlink symbolic ref
                              b="$(git symbolic-ref HEAD 2>/dev/null)"
                      else
                              local head=""
                              if ! __git_eread "$g/HEAD" head; then
                                      return $exit
                              fi
                              # is it a symbolic ref?
                              b="''${head#ref: }"
                              if [ "$head" = "$b" ]; then
                                      detached=yes
                                      b="$(
                                      case "''${GIT_PS1_DESCRIBE_STYLE-}" in
                                      (contains)
                                              git describe --contains HEAD ;;
                                      (branch)
                                              git describe --contains --all HEAD ;;
                                      (describe)
                                              git describe HEAD ;;
                                      (* | default)
                                              git describe --tags --exact-match HEAD ;;
                                      esac 2>/dev/null)" ||

                                      b="$short_sha..."
                                      b="${toFG theme.error}%{$reset_color%}($b)"
                              fi
                      fi
              fi

              if [ -n "$step" ] && [ -n "$total" ]; then
                      r="$r $step/$total"
              fi
        if [ -n "$r" ]; then
          r="$r "
        fi

              local w=""
              local i=""
              local s=""
              local u=""
              local c=""
              local p=""

              if [ "true" = "$inside_gitdir" ]; then
                      if [ "true" = "$bare_repo" ]; then
                              c="%{$reset_color%}BARE:"
                      else
                              b="%{$reset_color%}${toFG theme.error}GIT_DIR!"
                      fi
              elif [ "true" = "$inside_worktree" ]; then
                      if [ -n "''${GIT_PS1_SHOWDIRTYSTATE-}" ] &&
                         [ "$(git config --bool bash.showDirtyState)" != "false" ]
                      then
                              git diff --no-ext-diff --quiet || w="${toFG theme.warning}$ZSH_THEME_CHANGED_PROMPT%{$reset_color%}"
                              git diff --no-ext-diff --cached --quiet || i="${toFG theme.info}$ZSH_THEME_STAGED_PROMPT%{$reset_color%}"
                              if [ -z "$short_sha" ] && [ -z "$i" ]; then
                                      i="#"
                              fi
                      fi
                      if [ -n "''${GIT_PS1_SHOWSTASHSTATE-}" ] &&
                         git rev-parse --verify --quiet refs/stash >/dev/null
                      then
                              s="${toFG theme.localBranch}$ZSH_THEME_STASHED_PROMPT%{$reset_color%}"
                      fi

                      if [ -n "''${GIT_PS1_SHOWUNTRACKEDFILES-}" ] &&
                         [ "$(git config --bool bash.showUntrackedFiles)" != "false" ] &&
                         git ls-files --others --exclude-standard --directory --no-empty-directory --error-unmatch -- ':/*' >/dev/null 2>/dev/null
                      then
                              u="${toFG theme.error}$ZSH_THEME_UNTRACKED_PROMPT%{$reset_color%}"
                      fi

                      if [ -n "''${GIT_PS1_SHOWUPSTREAM-}" ]; then
                              __git_ps1_show_upstream
                      fi
              fi

              local z="''${GIT_PS1_STATESEPARATOR-" "}"

              b="${toFG theme.currentBranch}''${b##refs/heads/}%{$reset_color%}"
              if [ $pcmode = yes ] && [ $ps1_expanded = yes ]; then
                      __git_ps1_branch_name=$b
                      b="\''${__git_ps1_branch_name}"
              fi

              local f="$u$w$i$s"
              #local gitstring="''${f:+$z$f}$r$p $c$b"
        local gitstring="$f$r$c$p $b "

              if [ $pcmode = yes ]; then
                      if [ "''${__git_printf_supports_v-}" != yes ]; then
                              gitstring=$(printf -- "$printf_format" "$gitstring")
                      else
                              printf -v gitstring -- "$printf_format" "$gitstring"
                      fi
                      PS1="$ps1pc_start$gitstring$ps1pc_end"
              else
                      printf -- "$printf_format" "$gitstring"
              fi

              return $exit
      }

      function git_prompt_info {
        local branch
        local branch_symbol=""
        local w=""
        local i=""
        local s=""
        # git
        if hash git 2>/dev/null; then
          if branch=$( { git symbolic-ref --quiet HEAD || git rev-parse --short HEAD; } 2>/dev/null ); then
            printf "%s" "''${branch_symbol}$(__git_ps1 "%s")"
            return
          fi
        fi
        return 1
      }

      function host_info() {
        if [ -n "$SSH" ]; then
          echo ' ${toFG theme.remoteBranch}%n@%m%{$reset_color%}'
        fi
      }

      function get_pwd(){
        git_root=$PWD
        while [[ $git_root != / && ! -e $git_root/.git ]]; do
          git_root=$git_root:h
        done
        if [[ $git_root = / ]]; then
          unset git_root
          if [ "$PWD" = "$HOME" ]; then
            prompt_short_dir="$ZSH_THEME_HOME_PROMPT"
          else
            prompt_short_dir="%3~"
            if [[ "$PWD" == "$HOME"* ]]; then
              prompt_short_dir="''${PWD#$HOME/}"
            fi
          fi
        else
          parent=''${git_root%\/*}
          prompt_short_dir="''${PWD#$parent/}"
        fi
        echo "$prompt_short_dir"
      }

      precmd() {
        if [ ! "$TERM" = "linux" ]; then
          echo -ne "\e[3 q"
        fi
        if [ -z "$TMUX" ]; then
          spc=" "
        fi
        PROMPT='%(?.${toFG theme.foreground-alt}.${toFG theme.error})%(!.$ZSH_THEME_PROMPT_ROOT.$ZSH_THEME_PROMPT)%{$reset_color%}$spc '
        RPROMPT=" \$(git_prompt_info)${toFG theme.path}$(get_pwd)$(host_info)%{\$reset_color%}"
        PS2="%{$reset_color%}${toFG theme.warning}$ZSH_THEME_PROMPT2$spc %{$reset_color%}"
      }

    '';
    programs.zsh.shellAliases = with pkgs; {
      l = "ls -hF";
      la = "ls -AhF";
      ll = "ls -lAhF";
      cp = "cp --reflink=auto";
      xz = "xz --threads=0";
      ag = "${pkgs.ag}/bin/ag --color-line-number '${toANSI theme.background-alt}' --color-path '${toANSI theme.path}' --color-match '${toANSI theme.match}'";
    };
    environment.variables = {
      # shorter delay on cmd-mode
      KEYTIMEOUT = "1";
      LESS = "-erFX";
      FZF_TMUX = "1";
      FZF_DEFAULT_COMMAND = "ag -f -g '' --hidden --depth 16 --ignore dosdevices";
      FZF_CTRL_T_COMMAND = "ag -f -g '' --hidden --depth 16 --ignore dosdevices";
      FZF_DEFAULT_OPTS = "-m --ansi --color=16,bg:-1,bg+:-1 --tac";
      FZF_ALT_C_COMMAND = "find -L . -maxdepth 16 -type d 2>/dev/null";
      GREP_COLORS="mt=${toANSI theme.match}:sl=:cx=:fn=${toANSI theme.path}:ln=${toANSI theme.background-alt}:bn=${toANSI theme.number}:se=${toANSI theme.foreground-alt}";
    };
    environment.etc.dircolors = {
      text = ''
        TERM ansi
        TERM color-xterm
        TERM con132x25
        TERM con132x30
        TERM con132x43
        TERM con132x60
        TERM con80x25
        TERM con80x28
        TERM con80x30
        TERM con80x43
        TERM con80x50
        TERM con80x60
        TERM cons25
        TERM console
        TERM gnome
        TERM gnome-256color
        TERM linux
        TERM linux-c
        TERM rxvt
        TERM rxvt-256color
        TERM rxvt-cygwin
        TERM rxvt-cygwin-native
        TERM rxvt-unicode
        TERM rxvt-unicode-256color
        TERM rxvt-unicode256
        TERM screen
        TERM screen-256color
        TERM screen-256color-bce
        TERM screen-bce
        TERM screen-w
        TERM screen.Eterm
        TERM screen.rxvt
        TERM screen.linux
        TERM screen.xterm
        TERM st
        TERM st-256color
        TERM terminator
        TERM vt100
        TERM xterm
        TERM xterm-16color
        TERM xterm-256color
        TERM xterm-color
        TERM xterm-termite
        # Below are the color init strings for the basic file types. A color init
        # string consists of one or more of the following numeric codes:
        # Attribute codes:
        # 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
        # Text color codes:
        # 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
        # Background color codes:
        # 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
        #NORMAL 00 # no color code at all
        #FILE 00 # regular file: use no color at all
        RESET 0 # reset to "normal" color
        DIR ${toANSI theme.path} # directory
        LINK target # symbolic link. (If you set this to 'target' instead of a
        # numerical value, the color is as for the file pointed to.)
        MULTIHARDLINK 00 # regular file with more than one link
        SOCK ${toANSI theme.socket} # socket
        DOOR ${toANSI theme.socket};7 # door
        FIFO ${toANSI theme.socket};4 # pipe
        BLK ${toANSI theme.string} # block device driver
        CHR ${toANSI theme.character} # character device driver
        ORPHAN ${toANSI theme.error} # symlink to nonexistent file, or non-stat'able file ...
        MISSING ${toANSI theme.background-alt} # ... and the files they point to
        SETUID ${toANSI theme.warning} # file that is setuid (u+s)
        SETGID ${toANSI theme.warning};4 # file that is setgid (g+s)
        CAPABILITY ${toANSI theme.warning};7 # file with capability
        STICKY_OTHER_WRITABLE ${toANSI theme.path};4;7 # dir that is sticky and other-writable (+t,o+w)
        OTHER_WRITABLE ${toANSI theme.path};7 # dir that is other-writable (o+w) and not sticky
        STICKY ${toANSI theme.path};4 # dir with the sticky bit set (+t) and not other-writable
        EXEC ${toANSI theme.executable}
        .cmd ${toANSI theme.alias}
        .exe ${toANSI theme.alias}
        .com ${toANSI theme.alias}
        .btm ${toANSI theme.alias}
        .bat ${toANSI theme.alias}
        .sh ${toANSI theme.alias}
        .csh ${toANSI theme.alias}
        .tcsh ${toANSI theme.alias}

        # archives or compressed
        .tar ${toANSI theme.warning}
        .tgz ${toANSI theme.warning}
        .arc ${toANSI theme.warning}
        .arj ${toANSI theme.warning}
        .taz ${toANSI theme.warning}
        .lha ${toANSI theme.warning}
        .lz4 ${toANSI theme.warning}
        .lzh ${toANSI theme.warning}
        .lzma ${toANSI theme.warning}
        .tlz ${toANSI theme.warning}
        .txz ${toANSI theme.warning}
        .tzo ${toANSI theme.warning}
        .t7z ${toANSI theme.warning}
        .zip ${toANSI theme.warning}
        .z ${toANSI theme.warning}
        .Z ${toANSI theme.warning}
        .dz ${toANSI theme.warning}
        .gz ${toANSI theme.warning}
        .lrz ${toANSI theme.warning}
        .lz ${toANSI theme.warning}
        .lzo ${toANSI theme.warning}
        .xz ${toANSI theme.warning}
        .bz2 ${toANSI theme.warning}
        .bz ${toANSI theme.warning}
        .tbz ${toANSI theme.warning}
        .tbz2 ${toANSI theme.warning}
        .tz ${toANSI theme.warning}
        .deb ${toANSI theme.warning}
        .rpm ${toANSI theme.warning}
        .jar ${toANSI theme.warning}
        .war ${toANSI theme.warning}
        .ear ${toANSI theme.warning}
        .sar ${toANSI theme.warning}
        .rar ${toANSI theme.warning}
        .alz ${toANSI theme.warning}
        .ace ${toANSI theme.warning}
        .zoo ${toANSI theme.warning}
        .cpio ${toANSI theme.warning}
        .7z ${toANSI theme.warning}
        .rz ${toANSI theme.warning}
        .cab ${toANSI theme.warning}
        # image formats
        .jpg ${toANSI theme.pattern}
        .jpeg ${toANSI theme.pattern}
        .gif ${toANSI theme.pattern}
        .bmp ${toANSI theme.pattern}
        .pbm ${toANSI theme.pattern}
        .pgm ${toANSI theme.pattern}
        .ppm ${toANSI theme.pattern}
        .tga ${toANSI theme.pattern}
        .xbm ${toANSI theme.pattern}
        .xpm ${toANSI theme.pattern}
        .tif ${toANSI theme.pattern}
        .tiff ${toANSI theme.pattern}
        .png ${toANSI theme.pattern}
        .svg ${toANSI theme.pattern}
        .svgz ${toANSI theme.pattern}
        .mng ${toANSI theme.pattern}
        .pcx ${toANSI theme.pattern}
        .mov ${toANSI theme.pattern}
        .mpg ${toANSI theme.pattern}
        .mpeg ${toANSI theme.pattern}
        .m2v ${toANSI theme.pattern}
        .mkv ${toANSI theme.pattern}
        .webm ${toANSI theme.pattern}
        .ogm ${toANSI theme.pattern}
        .mp4 ${toANSI theme.pattern}
        .m4v ${toANSI theme.pattern}
        .mp4v ${toANSI theme.pattern}
        .vob ${toANSI theme.pattern}
        .qt ${toANSI theme.pattern}
        .nuv ${toANSI theme.pattern}
        .wmv ${toANSI theme.pattern}
        .asf ${toANSI theme.pattern}
        .rm ${toANSI theme.pattern}
        .rmvb ${toANSI theme.pattern}
        .flc ${toANSI theme.pattern}
        .avi ${toANSI theme.pattern}
        .fli ${toANSI theme.pattern}
        .flv ${toANSI theme.pattern}
        .gl ${toANSI theme.pattern}
        .dl ${toANSI theme.pattern}
        .xcf ${toANSI theme.pattern}
        .xwd ${toANSI theme.pattern}
        .yuv ${toANSI theme.pattern}
        .cgm ${toANSI theme.pattern}
        .emf ${toANSI theme.pattern}
        # http://wiki.xiph.org/index.php/MIME_Types_and_File_Extensions
        .ogv ${toANSI theme.pattern}
        .ogx ${toANSI theme.pattern}
        # documents
        .pdf   ${toANSI theme.string}
        .doc   ${toANSI theme.string}
        .docx  ${toANSI theme.string}
        .xps   ${toANSI theme.string}
        .xpsx  ${toANSI theme.string}
        .odg   ${toANSI theme.string}
        .odt   ${toANSI theme.string}
        .odf   ${toANSI theme.string}
        .xls   ${toANSI theme.string}
        .xlsx  ${toANSI theme.string}
        .dia   ${toANSI theme.string}
        .rtf   ${toANSI theme.string}
        .dot   ${toANSI theme.string}
        .dotx  ${toANSI theme.string}
        .ppt   ${toANSI theme.string}
        .pptx  ${toANSI theme.string}
        .fla   ${toANSI theme.string}
        .psd   ${toANSI theme.string}
        # audio formats
        .aac ${toANSI theme.number}
        .au ${toANSI theme.number}
        .flac ${toANSI theme.number}
        .m4a ${toANSI theme.number}
        .mid ${toANSI theme.number}
        .midi ${toANSI theme.number}
        .mka ${toANSI theme.number}
        .mp3 ${toANSI theme.number}
        .mpc ${toANSI theme.number}
        .ogg ${toANSI theme.number}
        .ra ${toANSI theme.number}
        .wav ${toANSI theme.number}
        # http://wiki.xiph.org/index.php/MIME_Types_and_File_Extensions
        .oga ${toANSI theme.number}
        .opus ${toANSI theme.number}
        .spx ${toANSI theme.number}
        .xspf ${toANSI theme.number}

        # encrypted/key formats
        .gpg  ${toANSI theme.number}
        .pgp  ${toANSI theme.number}
        .pub  ${toANSI theme.number}
        .crt  ${toANSI theme.number}
        .pem  ${toANSI theme.number}
        .asc  ${toANSI theme.number}
        .3des ${toANSI theme.number}
        .aes  ${toANSI theme.number}
        .enc  ${toANSI theme.number}
        .sig  ${toANSI theme.number}
        *key  ${toANSI theme.number}


        # source code files
        .c    ${toANSI theme.alias}
        .h    ${toANSI theme.alias}
        .java ${toANSI theme.alias}
        .js   ${toANSI theme.alias}
        .jsx  ${toANSI theme.alias}
        .vim  ${toANSI theme.alias}
        .py   ${toANSI theme.alias}
        .go   ${toANSI theme.alias}
        .nix  ${toANSI theme.alias}

        # data files
        .json         ${toANSI theme.string}
        .xml          ${toANSI theme.string}
        .iml          ${toANSI theme.string}
        .properties   ${toANSI theme.string}
        .yml          ${toANSI theme.string}
        .yaml         ${toANSI theme.string}
        .toml         ${toANSI theme.string}

        # txt files
        .txt     ${toANSI theme.foreground-alt}
        .TXT     ${toANSI theme.foreground-alt}
        .log     ${toANSI theme.foreground-alt}

        # readme, etc
        .md        ${toANSI theme.foreground-alt}
        *README    ${toANSI theme.foreground-alt}
        *README.TXT ${toANSI theme.foreground-alt}
        *README.txt ${toANSI theme.foreground-alt}

        # html
        .html   ${toANSI theme.pattern}
        .htm    ${toANSI theme.pattern}
        .css    ${toANSI theme.pattern}
        .less   ${toANSI theme.pattern}

        # other
        *~            ${toANSI theme.background-alt}
        *.pid         ${toANSI theme.background-alt}
        *desktop.ini  ${toANSI theme.background-alt}
        *Desktop.ini  ${toANSI theme.background-alt}
        .ICEauthority ${toANSI theme.background-alt}
        .Xauthority   ${toANSI theme.background-alt}
        .xsession-errors ${toANSI theme.background-alt}
        .old          ${toANSI theme.background-alt}
        .hidden       ${toANSI theme.background-alt}
        .zcompdump    ${toANSI theme.background-alt}
      '';
    };
  };
}
