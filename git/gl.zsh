#!/bin/sh
  
gl_help(){
    echo "Usage: gl <subcommand> [options]\n"
    echo "Subcommands:"
    echo "    browse   Open a Gitlab project page in the default browser"
    echo "    cd       Go to the directory of the specified repository"
    echo "    clone    Clone a remote repository"
    echo ""
    echo "For help with each subcommand run:"
    echo "gl <subcommand> -h|--help"
    echo ""
}
  
gl_browse() {
    open `git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#http://#' -e 's@com:@com/@'`| head -n1
}
  
gl_clone() {
    git clone "ssh://git@gitlab.com/$1.git" ~/Projects/gitlab/$1
    gl_cd "$1"
}

gl_cd() {
    cd ~/Projects/gitlab/$1
}

unalias gl  # oh-your-zsh git plugin defines 'gl' need to clear it first
gl() {
    subcommand=$1
    case $subcommand in
        "" | "-h" | "--help")
            gl_help
            ;;
        *)
            shift
            gl_${subcommand} $@
            if [ $? = 127 ]; then
                echo "Error: '$subcommand' is not a known subcommand." >&2
                echo "       Run 'gl --help' for a list of known subcommands." >&2
                return 1
            fi
            ;;
    esac
}

compdef '_files -W ~/Projects/gitlab' gl
