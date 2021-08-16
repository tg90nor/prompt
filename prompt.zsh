# tg90nor/prompt
# A simple theme that displays relevant, contextual information.
#
# Based on the sorin prompt by
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# 16 Terminal Colors
# -- ---------------
#  0 black
#  1 red
#  2 green
#  3 yellow
#  4 blue
#  5 magenta
#  6 cyan
#  7 white
#  8 bright black
#  9 bright red
# 10 bright green
# 11 bright yellow
# 12 bright blue
# 13 bright magenta
# 14 bright cyan
# 15 bright white

# For my own and others sanity
# git:
# %b => current branch
# %a => current action (rebase/merge)
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)
# terminal codes:
# \e7   => save cursor position
# \e[2A => move cursor 2 lines up
# \e[1G => go to position 1 in terminal
# \e8   => restore cursor position
# \e[K  => clears everything after the cursor on the current line
# \e[2K => clear everything on the current line

function prompt_tg90nor_pwd {
  local pwd="${PWD/#$HOME/~}"

  printf "\033k${${PWD/#$HOME/~}:t}\033\\"

  if [[ "$pwd" == (#m)[/~] ]]; then
    _prompt_tg90nor_pwd="$MATCH"
    unset MATCH
  else
    _prompt_tg90nor_pwd="${${${${(@j:/:M)${(@s:/:)pwd}##.#?}:h}%/}//\%/%%}/${${pwd:t}//\%/%%}"
  fi
}

function prompt_tg90nor_precmd {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS

  # Format PWD.
  prompt_tg90nor_pwd
  _prompt_tg90nor_poop='%(?:: 💩)'
}

function prompt_tg90nor_setup {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS
  prompt_opts=(cr percent subst)
  _prompt_tg90nor_precmd_async_pid=0
  _prompt_tg90nor_precmd_async_data="${TMPPREFIX}-prompt_tg90nor_data"

  autoload -Uz add-zsh-hook
  add-zsh-hook precmd prompt_tg90nor_precmd

  # Define prompts.
  PROMPT='${SSH_TTY:+"%F{2}%n@%m%f "}%F{5}[${_prompt_tg90nor_pwd}]%(!. %B%F{1}#%f%b.)${_prompt_tg90nor_poop} %F{2}❯%f '
  RPROMPT=''
  SPROMPT='zsh: correct %F{1}%R%f to %F{2}%r%f [nyae]? '
}

prompt_tg90nor_setup "$@"