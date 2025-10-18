# # Remove old tarball (clean start)
rm -rf /staging/hhao/env.tar.gz  # Remove old tarball (clean start)

pip install --upgrade --no-cache-dir pysaebm 

# Verify installation
python -c "from kde_ebm import mixture_model; import kde_ebm, pyebm, pysaebm, scipy, yaml; import scipy._lib; print('✅ Dependencies OK')" 

# # Package the environment
conda-pack -n jobs --output env.tar.gz 

mv /home/hhao9/mlhc_sub/env.tar.gz /staging/hhao9/env.tar.gz