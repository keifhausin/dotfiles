# Danny's dotfiles #

Opinionated dotfiles repository for Mac OS with zsh. Including Homebrew, Solarised and oh-my-zsh with the Agnoster theme.

Based on Zach Holman's dotfiles - https://github.com/holman/dotfiles.

## Prerequisites ##

- Set `zsh` as your default shell: `chsh -s /bin/zsh`. Optionally, use Homebew to install the latest zsh and use `/usr/local/bin/zsh`
- For best results, use iTerm2 as your terminal. Fonts, color schemes and settings are automatically installed for you

## Install ##

- For a quick start, clone the repository `git clone ssh://git@stash.cloud.local/~dthomas/dotfiles.git ~/.dotfiles`
- Run the bootstrap to install the files `cd ~/.dotfiles; ./bootstrap.sh`
- Restart your terminal

Use `~/.localrc` to configure anything that you want to keep outside of the repository or private. For more than the most basic use, you should fork the repository as a basis for your own.

## Update ##

Use `cd ~/.dotfiles; ./update.sh` to automatically update cloned git repositories.

## Features ##

The repository is ordered by topic. Refer to the readme files in the individual topic directories for details of the features they provide.

## How it works ##

Files are processed automatically by `.zshrc` or the bootstrap process depending on their extension. Scripts set the environment, manage files or perform installation steps depending on the file name or extension.

### Environment ###

These files set your shell's environment:

- `path.zsh`: Loaded first, and expected to setup `$PATH`
- `*.zsh`: Get loaded into your environment
- `completion.zsh`: Loaded last, and expected to setup autocomplete

### Files ###

The following extensions will cause files created in your home directory:

- `*.symlink`: Automaticlly symlinked into your `$HOME` as a dot file during bootstrap. For example, `myfile.symlink` will be linked as `$HOME/.myfile`
- `*.gitrepo`: Contains a URL to a Git repository to be cloned as a dotfile. For example `myrepo.symlink` will be cloned to `$HOME/.myrepo`
- `*.gitpatch`: Name `repo-<number>.gitpatch` to apply custom patches to a `gitrepo` repository
- `*.otf`: Open type files are copied to `~/Library/Fonts` during bootstrap
- `*.plist`: Preference lists are copied to `~/Library/Preferences` during bootstrap

### Installers ###

Installation steps during bootstrap can be handled in three ways:

- `install.sh`: An installation shellscript
- `install.homebrew`: A list of Homebrew formulas to install
- `install.open`: A list of files to be handled by the default application association using the `open` command
