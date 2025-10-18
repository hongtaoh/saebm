#!/bin/bash
set -e  # Exit immediately on error

echo "run_mlhc.sh started at $(date)"
echo "Running in directory: $(pwd)"
echo "Running with arguments: $@"

# cp /staging/hhao9/data.tar.gz .

# Prevent user-level site packages from interfering
export PYTHONNOUSERSITE=1

# ==============================================================================
# 📂 Prepare directories
# ==============================================================================
mkdir -p logs
chmod 755 logs
echo "Created logs directory at $(pwd)/logs"

for dir in debm debm_gmm ucl_gmm ucl_kde conjugate_priors hard_kmeans mle em kde; do
    mkdir -p "algo_results/$dir"
done

# ==============================================================================
# 🐍 Conda Env Extraction
# ==============================================================================
ENV_TARBALL="/staging/hhao9/env.tar.gz"
ENV_DIR=".conda_env"
PYTHON_EXEC=""

rm -rf "$ENV_DIR"

if [[ -f "$ENV_TARBALL" ]]; then
    echo "Extracting environment from $ENV_TARBALL..."
    mkdir -p "$ENV_DIR"
    tar -xzf "$ENV_TARBALL" -C "$ENV_DIR"
    PYTHON_EXEC="$ENV_DIR/bin/python"
    echo "Using extracted environment at $PYTHON_EXEC"
else
    echo "❌ $ENV_TARBALL not found — aborting"
    exit 1
fi


# ==============================================================================
# 🧪 Final sanity check
# ==============================================================================
echo "=== ENVIRONMENT VALIDATION ==="
echo "Python path: $PYTHON_EXEC"
echo "Python version: $($PYTHON_EXEC --version)"

if ! "$PYTHON_EXEC" -c "from kde_ebm import mixture_model; from pySuStaIn.MixtureSustain import MixtureSustain; import pysubebm;" &>/dev/null; then
    echo "❌ Final environment validation failed — aborting"
    exit 1
fi

# ==============================================================================
# 📦 Extract data
# ==============================================================================
DATA_TARBALL="/staging/hhao9/mlhc_data.tar.gz"

if [[ -f "$DATA_TARBALL" ]]; then
    echo "📦 Extracting $DATA_TARBALL..."
    tar -xzf "$DATA_TARBALL"
    # If extraction creates "mlhc_data", rename to "data"
    if [[ -d "mlhc_data" ]]; then
        rm -rf data   # remove old data folder if it exists
        mv mlhc_data data
        echo "Renamed mlhc_data -> data"
    fi
else
    echo "❌ $DATA_TARBALL not found — aborting"
    exit 1
fi

# ==============================================================================
# ▶️ Run Python Script
# ==============================================================================
echo "=== STARTING MAIN SCRIPT ==="
"$PYTHON_EXEC" ./run_mlhc.py "$@"

echo "✅ Script completed at $(date)"
