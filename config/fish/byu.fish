fish_add_path "$HOME/apps/bin/"
fish_add_path "$HOME/apps/nvim-linux-x86_64/bin"
fish_add_path "$HOME/apps/bat-v0.26.1-x86_64-unknown-linux-gnu/"
alias scripts "cd /byu/scripts/students/ava"

function awx-merge
    # e.g. awx-merge
    # e.g. awx-merge main
    set branch $(git branch --show-current)
    set -q argv[1]; and set target $argv[1]; or set target "dev"
    git switch $target
    git pull
    git merge $branch
    git push
    git switch $branch
end
