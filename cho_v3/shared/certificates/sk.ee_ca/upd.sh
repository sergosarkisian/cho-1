rm _sk_ca_bundle.pem
mkdir -p _tmp && cd _tmp
wget https://github.com/open-eid/certs/archive/master.zip
unzip master.zip && cd certs-master
 echo "Number of certificates merged: `ls -la *.crt|grep crt -c`"
cat *.crt > ../../_sk_ca_bundle.pem
rm -rf ../../_tmp
