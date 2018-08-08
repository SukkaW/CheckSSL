chmod +x runcheck.sh

for i in $@
do
    ./runcheck.sh ${i}
done


mkdir tmp/api -p

echo '[' > tmp/api/ct.json

for i in $@
do
    cat tmp/${i}.json >> tmp/api/ct.json
done

sed -i '$d' tmp/api/ct.json

echo '}' >> tmp/api/ct.json
echo ']' >> tmp/api/ct.json
sed -i ':label;N;s/\n/ /;b label' tmp/api/ct.json
sed -i "s|\" \"||g" tmp/api/ct.json
sed -i "s|\"\: \"|\"\:\"|g" tmp/api/ct.json
sed -i "s|\"\, \"|\"\,\"|g" tmp/api/ct.json
sed -i "s|\" }, { \"|\"},{\"|g" tmp/api/ct.json

mkdir public/api -p
cp -rf tmp/api/ct.json public/ct.json