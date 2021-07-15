set -x PATH $HOME/application/miniconda3/bin $PATH
set -x PATH $HOME/go/bin $PATH
set -g -x RANGER_LOAD_DEFAULT_RC FALSE
set -g -x QT_AUTO_SCREEN_SCALE_FACTOR 0
function fish_greeting
end
function fish_title
 if test $TERM_PROGRAM
  echo $TERM_PROGRAM
 else
  echo $TERM|egrep -o "^\w*"
 end
end
if status --is-login
	startx
end
