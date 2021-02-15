chmod +x ./runcheck.sh

mkdir ./tmp/api -p

for i in $@
do
    ./runcheck.sh ${i}
done

echo 'var data = [' > ./tmp/api/ct.js

for i in $@
do
    cat ./tmp/${i}.json >> ./tmp/api/ct.js
done

sed -i '$d' ./tmp/api/ct.js

echo '}' >> ./tmp/api/ct.js
echo ']' >> ./tmp/api/ct.js

sed -i ':label;N;s/\n/ /;b label' ./tmp/api/ct.js

sed -i "s|\" \"||g" ./tmp/api/ct.js
sed -i "s|\"\: \"|\"\:\"|g" ./tmp/api/ct.js
sed -i "s|\"\, \"|\"\,\"|g" ./tmp/api/ct.js
sed -i "s|\" }, { \"|\"},{\"|g" ./tmp/api/ct.js

mkdir ./output -p
cp -rf ./tmp/api/ct.js ./output/ct.js

rm -rf ./tmp
