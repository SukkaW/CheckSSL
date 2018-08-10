mkdir ./tmp -p

curl https://${1} -k -v -s -o /dev/null 2> ./tmp/ca.info

cat ./tmp/ca.info | grep 'start date: ' > ./tmp/${1}.info
cat ./tmp/ca.info | grep 'expire date: ' >> ./tmp/${1}.info
cat ./tmp/ca.info | grep 'issuer: ' >> ./tmp/${1}.info
cat ./tmp/ca.info | grep 'SSL certificate verify' >> ./tmp/${1}.info
cat ./tmp/ca.info | grep 'subject: ' >> ./tmp/${1}.info

sed -i 's|\* \t start date: ||g' ./tmp/${1}.info
sed -i 's|\* \t expire date: ||g' ./tmp/${1}.info
sed -i 's|\* \t issuer: ||g' ./tmp/${1}.info
sed -i 's|\* \t SSL certificate verify ||g' ./tmp/${1}.info
sed -i 's|\* \t subject: ||g' ./tmp/${1}.info

start=$(sed -n '1p' ./tmp/${1}.info)
expire=$(sed -n '2p' ./tmp/${1}.info)
issuer=$(sed -n '3p' ./tmp/${1}.info)
status=$(sed -n '4p' ./tmp/${1}.info)
subject=$(sed -n '5p' ./tmp/${1}.info)

rm -f ./tmp/ca.info
rm -f ./tmp/${1}.info

DATE="$(echo $(date '+%Y-%m-%d %H:%M:%S'))"

nowstamp="$(date -d "$DATE" +%s)"
expirestamp="$(date -d "$expire" +%s)"
expireday=`expr $[expirestamp-nowstamp] / 86400`

echo '{' > tmp/${1}.json
echo '"domain": "'${1}'",' >> ./tmp/${1}.json
echo '"subject": "'$subject'",' >> ./tmp/${1}.json
echo '"start": "'$start'",' >> ./tmp/${1}.json
echo '"expire": "'$expire'",' >> ./tmp/${1}.json
echo '"issuer": "'$issuer'",' >> ./tmp/${1}.json

if [ $expirestamp \< $nowstamp ]; then
    echo '"status": "Expired",' >> ./tmp/${1}.json
    echo '"statuscolor": "error",' >> ./tmp/${1}.json
elif [ $expireday \< 10 ]; then
    echo '"status": "Soon Expired",' >> ./tmp/${1}.json
    echo '"statuscolor": "warning",' >> ./tmp/${1}.json
elif [ $status = "ok." ]; then
    echo '"status": "Valid",' >> ./tmp/${1}.json
    echo '"statuscolor": "success",' >> ./tmp/${1}.json
else
    echo '"status": "Invalid",' >> ./tmp/${1}.json
    echo '"statuscolor": "error",' >> ./tmp/${1}.json
fi

echo '"check": "'$DATE'",' >> ./tmp/${1}.json
echo '"remain": "'$expireday'"' >> ./tmp/${1}.json
echo '},' >> ./tmp/${1}.json
