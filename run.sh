condor_rm hhao9

rm -rf error_logs/*
rm -rf logs/*

# for dir in debm debm_gmm ucl_gmm ucl_kde conjugate_priors hard_kmeans mle em kde; do 
#     find "algo_results/$dir" -mindepth 2 -type f -delete
# done

for dir in conjugate_priors ; do 
    find "algo_results/$dir" -mindepth 2 -type f -delete
done

condor_submit /home/hhao9/mlhc_sub/run_mlhc.sub