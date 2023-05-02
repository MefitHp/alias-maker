# Define the plugin name and version
declare -r alias_maker_version="1.0.0"
declare -r alias_maker_name="alias-maker"

# Check if Oh My Zsh is installed
if [[ -z "$ZSH" ]]; then
    echo "Error: Oh My Zsh is not installed on your system. Please install it before using the $alias_maker_name plugin."
    echo "You can download Oh My Zsh from https://ohmyz.sh"
    return 1
fi

# Check if .zshrc file exists
if [[ ! -f "$HOME/.zshrc" ]]; then
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
    local -r alias_name="$1"
    local -r alias_command="$2"

    # Check if the alias name or command is empty or contains invalid commands
    if [[ $alias_name == *[';\`$']* || $alias_command == *[';\`$']* ]]; then
        echo "Error: Invalid input provided" >&2
        return 1
    fi

    # Check if the alias already exists
    if alias "$alias_name" >/dev/null 2>&1; then
        echo "Error: Alias '$alias_name' already exists." >&2
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
    local -r alias_name=$1

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
    local -a aliases=()
    local rc_file="$HOME/.zshrc"
    # Check if .zshrc file exists
    if [ ! -f "$rc_file" ]; then
        echo "No .zshrc file found." >&2
        return 1
    fi

    # Read the .zshrc file and find all aliases
    while read -r line; do
        if [[ $line == alias* ]]; then
            aliases+=("$line")
        fi
    done <"$rc_file"

    # Check if any aliases were found
    if [ ${#aliases[@]} -gt 0 ]; then
        echo "🔧 Custom aliases found in $HOME/.zshrc:"
        echo ""

        for alias in "${aliases[@]}"; do
            name="${alias%%=*}"
            command="${alias#*=}"
            name="${name#alias }"
            echo "  - $name → ${command//\'/}"
        done
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
