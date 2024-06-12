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
send_key() {
  dest_host="$1"
  if [[ -z $dest_host ]]; then
    echo "Must specify a destination to send SSH key to"
    return 1
  fi
  key_files=($(find ~/.ssh -name "id_*.pub"))
  if [[ ${#key_files[@]} -lt 1 ]]; then
    echo "No key files found in $HOME/.ssh"
    return 1
  fi
  key_name=${key_files[0]}
  if [[ ${#key_files[@]} -gt 1 ]]; then
    echo "Found more than 1 key file in $HOME/.ssh; using $key_name"
  fi
  key=$(cat $key_name)
  ssh $dest_host "echo $key >> ~/.ssh/authorized_keys"
}
pull_and_recommit() {
    # MUST RUN IN PROJECT ROOT DIR
    commit_msg=$(git log -1 --pretty=%B)
    to_commit=($(git diffn HEAD~))
    git reset HEAD~
    git stash
    git pp
    git stash pop
    git add ${to_commit[@]}
    git ci -m "$commit_msg"
}
