set -x PATH $HOME/miniconda3/bin $PATH
set -x PATH $HOME/go/bin $PATH
set -x PATH $HOME/.npm-global/bin $PATH
set -g -x RANGER_LOAD_DEFAULT_RC FALSE
set -g -x HOMEBREW_NO_AUTO_UPDATE TRUE
function fish_greeting
end
function fish_title
 if test $TERM_PROGRAM
  echo $TERM_PROGRAM
 else
  echo $TERM|egrep -o "^\w*"
 end
end
if test -f /Users/xingzheng/.autojump/share/autojump/autojump.fish; . /Users/xingzheng/.autojump/share/autojump/autojump.fish; end
