# Original code by Mike Weilgart
get_git_status_for_prompt() {
  local status
  if status="$(git status --porcelain 2>/dev/null)"; then
    # We are in a git repository
    local branch
    branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    [ "HEAD" = "$branch" ] && branch="-detached-"
    if [ "" = "$status" ]; then
      # Working directory and index fully clean, no further logic needed
      git_prompt=" $txtcyn($branch)$txtrst"
    else
      local workdir_status index_status
      workdir_status="$(printf %s\\n "$status" | cut -c 2)"
      index_status="$(printf %s\\n "$status" | cut -c 1)"

      local abbrev_status
      if [[ "$workdir_status" =~ '?' ]]; then
        abbrev_status="1"
      else
        abbrev_status="0"
      fi

      case "$workdir_status" in
        (*[DM]*)
          abbrev_status+="1" ;;
        (*)
          abbrev_status+="0" ;;
      esac

      case "$index_status" in
        (*[MADRC]*)
          abbrev_status+="1" ;;
        (*)
          abbrev_status+="0" ;;
      esac

      case "$abbrev_status" in
        (000) # Clean - should have been caught.  Odd.
          git_prompt=" $bldwht($branch WTF)$txtrst"
          ;;
        (100) # Untracked files otherwise clean
          git_prompt=" $txtcyn($branch)$bldwht*$txtrst"
          ;;
        (010) # Unadded tracked changes
          git_prompt=" $txtred($branch)$txtrst"
          ;;
        (110) # Same plus untracked files
          git_prompt=" $txtred($branch)$bldwht*$txtrst"
          ;;
        (001) # Staged changes
          git_prompt=" $txtgrn($branch)$txtrst"
          ;;
        (101) # Plus untracked files
          git_prompt=" $txtgrn($branch)$bldwht*$txtrst"
          ;;
        (011) # Unstaged and staged changes
          git_prompt=" $txtylw($branch)$txtrst"
          ;;
        (111) # Plus untracked files
          git_prompt=" $txtylw($branch)$bldwht*$txtrst"
          ;;
        (*) # Unexpected failure
          git_prompt=" $bldwht($branch WTFH)$txtrst"
          ;;
      esac
      case "$workdir_status$index_status" in
        (*U*)
          # Merge is in progress
          git_prompt=" $txtpur($branch - MERGING)$txtrst"

          # This logic could be improved, as evidently a merge
          # can be in progress (as shown by 'git status')
          # without being visible in the output of 'git status porcelain'
          # at all.  So not ALL "merge in progress" will be shown in
          # purple, only some of them.
          ;;
      esac
    fi
  else
    # We are not in a git repository
    git_prompt=""
  fi
}

PROMPT_COMMAND="get_git_status_for_prompt; $PROMPT_COMMAND"

# Example usage:
# PS1='\t [\u \W]$git_prompt \! \$ '
