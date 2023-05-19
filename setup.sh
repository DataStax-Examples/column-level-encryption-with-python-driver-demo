#!/bin/sh

# if cqlsh-astra.tar.gz or cqlsh-astra exists delete them 
if [ -f cqlsh-astra.tar.gz ]; then
    rm cqlsh-astra.tar.gz
fi

if [ -d cqlsh-astra ]; then
    rm -rf cqlsh-astra
fi

# Get new cqlsh-astra.tar.gz and extract it
wget https://downloads.datastax.com/enterprise/cqlsh-astra.tar.gz
tar -zxvf cqlsh-astra.tar.gz
rm cqlsh-astra.tar.gz
