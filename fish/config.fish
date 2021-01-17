set -x PATH $HOME/application/miniconda3/bin $PATH
set -g -x RANGER_LOAD_DEFAULT_RC FALSE
function fish_greeting
end
function fish_title
 if test $TERM_PROGRAM
  echo $TERM_PROGRAM
 else
  echo $TERM|egrep -o "\w*"
 end
end
