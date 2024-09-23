#!/bin/zsh
set -e

# Check for Conda
if ! command -v conda &> /dev/null; then
    echo "Conda is not installed or not in PATH. Please install Conda and try again."
    exit 1
fi

# Activate conda environment
conda activate xtts-f

# Install packages from requirements.txt using conda
if conda install --file requirements.txt -y; then
    echo "All packages from requirements.txt installed successfully with conda."
else
    echo "Some packages from requirements.txt might not be available via conda."
    echo "Attempting to install remaining packages with pip..."
    pip install -r requirements.txt
fi

# Install PyTorch with CUDA support using conda
if conda install pytorch==2.1.1 torchaudio==2.1.1 cuda=11.8 -c pytorch -c nvidia -c conda-forge -y; then
    echo "PyTorch installed successfully with conda."
else
    echo "Failed to install PyTorch with conda. Attempting with pip..."
    pip install torch==2.1.1+cu118 torchaudio==2.1.1+cu118 --index-url https://download.pytorch.org/whl/cu118
fi

# Run the Python script
python xtts_demo.py