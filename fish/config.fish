set -x PATH $HOME/application/miniconda3/bin $PATH
set -g -x RANGER_LOAD_DEFAULT_RC FALSE
function fish_greeting
end
function fish_title
    echo $TERM_PROGRAM
end
