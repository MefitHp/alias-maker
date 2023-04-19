# Alias Maker Plugin

The Alias Maker plugin is a zsh plugin that allows you to easily create and manage custom zsh aliases from the
command line.

## Installation

1.  Clone the Alias Maker repository:

```
git clone https://github.com/MefitHp/alias-maker.git ~/.oh-my-zsh/custom/plugins/alias_maker
```

2.  Then, add `alias_maker` to your Zsh plugins list in your `.zshrc` file:

If using you're using VSCode you can open the file with the following command:

```zsh
code ~/.zshrc
```

Then just update the plugins

```zsh
plugins=(...other plugis, alias_maker)
```

3.  Restart your zsh shell or update the shell.

```zsh
source ~/.zshrc
```

## Usage

The Alias Maker plugin provides the following subcommands:

```
amc <alias_name> <alias_command>  # Create a new custom zsh alias
amd <alias_name>                  # Delete an existing custom zsh alias
am --list, -l                     # List all custom zsh aliases defined in your .zshrc file
am --help, -h                     # Show help message
```

### Create a new custom zsh alias

To create a new custom zsh alias, use the `amc` (Just an `alias-maker-create` shortcut) subcommand followed by
the name and command for the new alias:

```
amc myalias 'ls -la'
```

This will create a new zsh alias named `myalias` that executes the command `ls -la`.

### Delete an existing custom zsh alias

To delete an existing custom zsh alias, use the `amd` subcommand followed by the name of the alias:

```
amd myalias
```

This will delete the `myalias` alias if it exists.

### List all custom zsh aliases

To list all custom zsh aliases defined in your `.zshrc` file, use the `am --list` subcommand:

```
am --list
```

Example output:

```
Custom aliases found in /Users/YOUR_USER/.zshrc:
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"
```
