set -x PATH $HOME/go/bin $PATH
set -g -x RANGER_LOAD_DEFAULT_RC FALSE
function fish_greeting
end
function fish_title
 if test $TERM_PROGRAM
  echo $TERM_PROGRAM
 else
  echo $TERM|egrep -o "^\w*"
 end
end
switch (uname)
case Linux
	set -x PATH $HOME/application/mgltools/bin $PATH
	set -x PATH $HOME/application/miniconda3/bin $PATH
	set -x PATH $HOME/application/blender $PATH
	set -x PATH $HOME/application/MGLTools-1.5.6/bin $PATH
	set -x PATH $HOME/application/node/bin $PATH
	set -x PATH $HOME/application/proxychains/bin $PATH
	set -x PATH /usr/local/gromacs/bin $PATH
	set -x PATH $HOME/.npm_global/bin $PATH
	if test -f /home/zxing/.autojump/share/autojump/autojump.fish; . /home/zxing/.autojump/share/autojump/autojump.fish; end
case Darwin
	set -x PATH $HOME/miniconda3/bin $PATH
	set -g -x HOMEBREW_NO_AUTO_UPDATE TRUE
	set -x PATH $HOME/.npm-global/bin $PATH
	if test -f /Users/xingzheng/.autojump/share/autojump/autojump.fish; . /Users/xingzheng/.autojump/share/autojump/autojump.fish; end
end
