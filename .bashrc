export PATH="$HOME/bin:$(go env GOPATH)/bin:$GOROOT/bin:$PATH:/usr/local/bin:/usr/local/sbin"
export GITHUB_USER=sraisty1c
export GITHUB_TOKEN=e723fc9ee3d8e2166fc4d0f290d48c953c3d31be
export EMAIL=sraisty@oneconcern.com

# Tried to get code to work as the editor for kubectl edit , but it did not work well
# export EDITOR='/usr/local/bin/code'
# export VISUAL='/usr/local/bin/code'
export EDITOR='nano'
export VISUAL='nano'
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
export PS1='$(kube_ps1)'$PS1

eval "$(direnv hook bash)"

alias "ost"="open /Applications/Sourcetree.app/Contents/MacOS/Sourcetree"
alias "stree"="open /Applications/Sourcetree.app/Contents/MacOS/Sourcetree"

alias "k"="kubectl"

# DEPMON
# "kt" command shows tail of multiple Kubernetes pod logs at the same time
alias "kt-depmon"="kt '(depmon-[0-9]+|gatekeeper)' -e regex"
alias "mbdl"="make build-deploy-local"
alias "mwf"="make watch-frontend"

# Have my local version of node run with the full internationalization library with locale formats
# etc.
export NODE_ICU_DATA="/users/sraisty/Projects/depmon/frontend/node_modules/full_icu"
alias "treeproj"="tree -I 'node_modules|build|cache|coverage'"

# sudo mkdir -p /etc/paths.d &&
# echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp


### Keycloak themes require the GNU version of sed, not the standard MacOS version:
PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

##########  Consolidate my bash history into one file
export HISTTIMEFORMAT='%F %T  '

# Avoid duplicates in my bash history
export HISTCONTROL=ignoredups:erasedups
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# Command line autocompletion for the 'make' command (Makefiles). Autocompletees targets
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make
###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###
listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}
