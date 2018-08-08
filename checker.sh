chmod +x runcheck.sh

for i in $@
do
    ./runcheck.sh $i
done


mkdir tmp/api -p

echo '[' > tmp/api/ct.json

echo ',' >> tmp/api/ct.json

echo ']' >> tmp/api/ct.json