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
disk_check() {
  target_dir="${1:-$(pwd)}"
  du -d 1 -c -h "${target_dir}" | sort -h
}
alias logout="gnome-session-quit"
export EDITOR=vim
# Run command N times (default 20)
gimme_20() {
    COUNT=20
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -n)
                shift
                COUNT="$1" 
                shift
                ;;
            *)
                break
                ;;
        esac
    done
    cmd="$@"
    for ii in $(seq 0 $COUNT); do
        echo "Run $ii"
        $cmd
    done
}
export HISTTIMEFORMAT="%F %T: "
