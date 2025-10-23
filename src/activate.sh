# printf 'hello from jobu\n\r'

# Print colorful JOBU logo
echo ""
echo -e "\033[38;5;196m     ██╗ \033[38;5;208m ██████╗ \033[38;5;220m██████╗\033[38;5;46m██╗   ██╗\033[0m"
echo -e "\033[38;5;196m     ██║\033[38;5;208m██╔═══██╗\033[38;5;220m██╔══██╗\033[38;5;46m██║   ██║\033[0m"
echo -e "\033[38;5;196m     ██║\033[38;5;208m██║   ██║\033[38;5;220m██████╔╝\033[38;5;46m██║   ██║\033[0m"
echo -e "\033[38;5;196m██   ██║\033[38;5;208m██║   ██║\033[38;5;220m██╔══██╗\033[38;5;46m██║   ██║\033[0m"
echo -e "\033[38;5;196m╚█████╔╝\033[38;5;208m╚██████╔╝\033[38;5;220m██████╔╝\033[38;5;46m╚██████╔╝\033[0m"
echo -e "\033[38;5;196m ╚════╝ \033[38;5;208m ╚═════╝ \033[38;5;220m╚═════╝ \033[38;5;46m ╚═════╝ \033[0m"
echo -e "\033[38;5;129m            ~ A big hook into bash ~\033[0m"
echo ""

# bind '"q": "z\C-J"'
# bind '"z": "exit"'

bind 'set enable-bracketed-paste off'

PS1="MYPROMPT> "

jobu_start_of_prompt() {
    # Run get-command directly in current shell, not in subshell
    local temp_output=$(mktemp)
    # Execute directly in current shell and redirect stderr to temp file
    # ensure PS1 is exported so the jobu binary inherits it
    export PS1
    $JOBU_EXEC_PATH get-command 2> "$temp_output"
    # Read the output from temp file (stderr output)
    local output
    output=$(cat "$temp_output")
    rm -f "$temp_output"

    JOBU_COMMAND=$(printf "%s" "$output" | rg -o 'COMMAND: (.*)' -r '$1')

    # Trim leading/trailing whitespace
    JOBU_COMMAND="${JOBU_COMMAND#"${JOBU_COMMAND%%[![:space:]]*}"}"
    JOBU_COMMAND="${JOBU_COMMAND%"${JOBU_COMMAND##*[![:space:]]}"}"

    # If the command is empty or only whitespace, return early
    if [[ -z "$JOBU_COMMAND" ]]; then
        return
    fi

    printf "\n"

    bind -x '"a": jobu_end_of_prompt'
    bind '"\e[0n": "a\C-J"'
    printf "\033[5n"
}
PS0="\033[?1049l"


PROMPT_COMMAND='jobu_start_of_prompt'

jobu_end_of_prompt() {
    READLINE_LINE=${JOBU_COMMAND};
    READLINE_POINT=${#READLINE_LINE};
    printf "\033[?1049h"
}
