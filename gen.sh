rm -rf /staging/hhao9/mlhc_data.tar.gz
rm -rf data data.tar.gz ../data ../data.tar.gz
python3 gen.py
tar -czf data.tar.gz data
mv /home/hhao9/mlhc_sub/data.tar.gz /staging/hhao9/mlhc_data.tar.gz
rm -rf data
ls -lh /staging/hhao9/mlhc_data.tar.gz