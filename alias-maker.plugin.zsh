# Define the plugin name and version
alias_maker_version="1.0.0"
alias_maker_name="alias-maker"

# Check if Oh My Zsh is installed
if [ -z "$ZSH" ]; then
    echo "Error: Oh My Zsh is not installed on your system. Please install it before using the $alias_maker_name plugin."
    echo "You can download Oh My Zsh from https://ohmyz.sh"
    return 1
fi

# Check if .zshrc file exists
if [ ! -f "$HOME/.zshrc" ]; then
    echo "Creating .zshrc file..."
    touch "$HOME/.zshrc"
fi

# Define the main function for the alias_maker plugin
function am() {
    # Parse the subcommand and its arguments
    local subcommand=$1

    case $subcommand in
    -h | --help)
        show_help
        return 0
        ;;
    create_alias)
        amc "$2"
        ;;
    delete_alias)
        amd "$2"
        ;;
    -l | --list)
        list_aliases
        ;;
    *)
        echo "Error: Invalid subcommand '$subcommand'. Use 'am -h' for help." >&2
        return 1
        ;;
    esac
}

# Define a function to create a new zsh alias
# Function create_alias
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
    echo "alias $alias_name=\"$alias_command\"" >>~/.zshrc
    source ~/.zshrc

    # Output the success message
    echo "Alias created:"
    echo "Command: \`$alias_name\` will execute the following: \`$alias_command\`"
}

# Delete an existing zsh alias
# Args:
# $1: Alias name
function amd() {
    local alias_name=$1

    # Check if the alias exists
    if ! alias | grep -q "$alias_name="; then
        echo "Alias '$alias_name' does not exist."
        return 1
    fi

    # Delete the alias from .zshrc
    sed -i.bak "/alias $alias_name=/d" ~/.zshrc
    # Remove backup file
    rm ~/.zshrc.bak
    # Unset the alias
    unalias $alias_name
    echo "Alias '$alias_name' has been deleted."
}

# Define a function to list all custom zsh aliases
function list_aliases() {
    # Read the contents of the .zshrc file
    local rc_file="$HOME/.zshrc"
    local file_contents="$(cat $rc_file)"

    # Search for lines starting with the "alias" keyword
    local aliases="$(echo "$file_contents" | grep "^alias ")"

    # Output the aliases found in a list-like format
    if [[ -n $aliases ]]; then
        echo "🔧 Custom aliases found in $HOME/.zshrc:"
        echo ""
        # Loop through each alias and print its name and command
        grep -oE "^alias [a-zA-Z0-9_-]+=.+$" "$HOME/.zshrc" | sed -E 's/^alias ([a-zA-Z0-9_-]+)=(.+)$/  - \1 → \2/' | sed 's/"//g' | awk '{print "  " $0}'

        echo ""
    else
        echo "No custom aliases found in $rc_file"
    fi
}

function show_help() {
    echo "Usage: am [subcommand]"
    echo "Subcommands:"
    echo "  amc <alias_name> <alias_command>: Create a new custom zsh alias"
    echo "  amd <alias_name>: Delete an existing custom zsh alias"
    echo "  -h, --help: Show this help message"
    echo "  -l, --list: List all custom zsh aliases defined in your .zshrc file"
}
