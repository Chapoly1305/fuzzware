# Fuzzware development environment setup
export FUZZWARE=/workspaces/fuzzware
export WORKON_HOME=/home/vscode/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3

# Source virtualenvwrapper
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
elif [ -f ~/.local/bin/virtualenvwrapper.sh ]; then
    source ~/.local/bin/virtualenvwrapper.sh
fi

# Auto-activate fuzzware virtualenv if it exists
if [ -d "$WORKON_HOME/fuzzware" ]; then
    workon fuzzware 2>/dev/null || true
fi

# Helpful aliases
alias fw='cd /workspaces/fuzzware'
alias fwemu='cd /workspaces/fuzzware/emulator'
alias fwpipe='cd /workspaces/fuzzware/pipeline'
alias fwmodel='cd /workspaces/fuzzware/modeling'

# Function to switch to modeling virtualenv
fuzzware-modeling() {
    workon fuzzware-modeling
}

# Function to switch back to main fuzzware virtualenv
fuzzware-main() {
    workon fuzzware
}
