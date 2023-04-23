# Define the plugin name and version
alias_maker_version="1.0.0"
alias_maker_name="alias-maker"

# Define the main function for the alias_maker plugin
function am() {
    local subcommand=$1

    case $subcommand in
        -h|--help)
            echo "Usage: am [subcommand]"
            echo "Subcommands:"
            echo "  amc <alias_name> <alias_command>: Create a new custom zsh alias"
            echo "  amd <alias_name>: Delete an existing custom zsh alias"
            echo "  -h, --help: Show this help message"
            echo "  -l, --list: List all custom zsh aliases defined in your .zshrc file"
            return 0
            ;;
        create_alias)
            amc "$2"
            ;;
        delete_alias)
            amd "$2"
            ;;
        -l|--list)
            alias_maker_list_aliases
            ;;
        *)
            echo "Error: Invalid subcommand '$subcommand'. Use 'am -h' for help." >&2
            return 1
            ;;
    esac
}

# Define a function to create a new zsh alias
function amc() {
    # Get the name and command for the new alias
    local alias_name=$1
    local alias_command=$2

    # Validate the input to prevent arbitrary command execution
    if [[ $alias_name == *[';\`$']* || $alias_command == *[';\`$']* ]]; then
        echo "Error: Invalid input provided" >&2
        return 1
    fi

    # Create the new alias and save it to the .zshrc file
    echo "alias $alias_name=\"$alias_command\"" >> ~/.zshrc
    source ~/.zshrc

    # Output the success message
    echo "Alias created:"
    echo "Command: \`$alias_name\` will execute the following: \`$alias_command\`"
}

# Define a function to delete an existing zsh alias
function amd() {
  local alias_name=$1
  # Check if the alias exists
  if ! grep -q "alias ${alias_name}=" ~/.zshrc; then
    echo "Alias '${alias_name}' does not exist."
    return 1
  fi
  # Delete the alias from .zshrc
  sed -i.bak "/alias ${alias_name}=/d" ~/.zshrc
  # Remove backup file
  rm ~/.zshrc.bak
  # Unset the alias
  unalias $alias_name
  echo "Alias '${alias_name}' has been deleted."
}

# Define a function to list all custom zsh aliases
function alias_maker_list_aliases() {
    # Read the contents of the .zshrc file
    local rc_file="$HOME/.zshrc"
    local file_contents="$(cat $rc_file)"

    # Search for lines starting with the "alias" keyword
    local aliases="$(echo "$file_contents" | grep "^alias ")"

    # Output the aliases found
    if [[ -n $aliases ]]; then
        echo "Custom aliases found in $rc_file:"
        echo "$aliases"
    else
        echo "No custom aliases found in $rc_file"
    fi
}