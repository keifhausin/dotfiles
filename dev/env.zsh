export PATH=$PATH:$HOME/.cargo/bin
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
add-zsh-hook chpwd nvm_auto_use
nvm_auto_use