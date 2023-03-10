# create this file for computer-specific aliases
[[ -f ~/.this_pc_aliases ]] && source ~/.this_pc_aliases

activenv() {
    name=${1:-.venv}
    env_dirs=($(find . -maxdepth 1 -name "$name" -type d))
    if [[ ${#env_dirs[@]} -lt 1 ]]; then
        echo "No venv found with name ${name}"
        return 1
    fi
    for dir in "${env_dirs[@]}"; do
        source $dir/bin/activate
        [[ $? -eq 0 ]] && return 0
    done
}
alias cdc="cd ~/code"
alias logout="gnome-session-quit"
