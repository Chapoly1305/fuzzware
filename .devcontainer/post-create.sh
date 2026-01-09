#!/bin/bash
set -e

echo "==> Setting up Fuzzware development environment..."

cd /workspaces/fuzzware

# Initialize submodules if needed
if [ ! -f emulator/setup.sh ] || [ ! -f pipeline/setup.sh ]; then
    echo "==> Updating submodules..."
    ./update.sh
fi

# Set up virtualenvwrapper
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=/home/vscode/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh 2>/dev/null || source $(which virtualenvwrapper.sh) 2>/dev/null || {
    pip3 install --user virtualenvwrapper
    source ~/.local/bin/virtualenvwrapper.sh
}

# Create main fuzzware virtualenv if it doesn't exist
if [ ! -d "$WORKON_HOME/fuzzware" ]; then
    echo "==> Creating fuzzware virtualenv..."
    mkvirtualenv -p /usr/bin/python3 fuzzware
fi

# Create modeling virtualenv if it doesn't exist
if [ ! -d "$WORKON_HOME/fuzzware-modeling" ]; then
    echo "==> Creating fuzzware-modeling virtualenv..."
    mkvirtualenv -p /usr/bin/python3 fuzzware-modeling
fi

# Install modeling requirements
echo "==> Installing modeling requirements..."
source $WORKON_HOME/fuzzware-modeling/bin/activate
pip install -r modeling/requirements.txt
pip install -e modeling/
deactivate

# Install emulator and pipeline
echo "==> Installing emulator and pipeline requirements..."
source $WORKON_HOME/fuzzware/bin/activate
pip install -r emulator/requirements.txt
pip install -r pipeline/requirements.txt

# Build AFL if not already built
if [ ! -f emulator/afl/afl-fuzz ] && [ ! -f emulator/AFLplusplus/afl-fuzz ]; then
    echo "==> Building AFL..."
    cd emulator
    ./get_afl.sh
    if [ -d afl ]; then
        UNICORN_QEMU_FLAGS="--python=/usr/bin/python3" make -C afl clean all || true
    fi
    if [ -d AFLplusplus ]; then
        make -C AFLplusplus clean all || true
    fi
    cd ..
fi

# Build unicorn if not already built
if [ ! -f emulator/unicorn/fuzzware-unicorn/build/libunicorn.so ]; then
    echo "==> Building Unicorn..."
    cd emulator/unicorn
    ./build_unicorn.sh
    cd ../..
fi

# Build harness
echo "==> Building harness..."
make -C emulator/harness/fuzzware_harness/native clean all || true

# Install emulator and pipeline in editable mode
echo "==> Installing emulator and pipeline..."
pip install -e emulator/harness
pip install -e pipeline/

deactivate

echo "==> Setup complete!"
echo ""
echo "To activate the fuzzware environment, run:"
echo "  source ~/.virtualenvs/fuzzware/bin/activate"
echo ""
echo "Or use virtualenvwrapper:"
echo "  source /usr/local/bin/virtualenvwrapper.sh"
echo "  workon fuzzware"
