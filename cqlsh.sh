#!/bin/sh

# Set your CSV file path
csv_file="../GeneratedToken.csv"

# Set your path to the SCB
scb_file="../secure-connect-playlist.zip"

# Error if we don't file csv file
if [ ! -f $csv_file ]; then
    echo "CSV file not found. Please set the path to the Token Details CSV file in the script."
    exit 1
fi

# Error if we don't fine the scb_file
if [ ! -f $scb_file ]; then
    echo "SCB file not found. Please set the path to the SCB file in the script."
    exit 1
fi

scb_fullpath=$(realpath $scb_file)

# Read the CSV file
csv_content=$(tail -n +2 $csv_file | head -n 1)


# Parse the CSV content
client_id=$(echo $csv_content | awk -F ',' '{print $1}' | tr -d '"')
client_secret=$(echo $csv_content | awk -F ',' '{print $2}' | tr -d '"')
role=$(echo $csv_content | awk -F ',' '{print $3}' | tr -d '"')
token=$(echo $csv_content | awk -F ',' '{print $4}' | tr -d '"')

# Launch cqlsh and connect to Astra
cd cqlsh-astra
./bin/cqlsh -u $client_id -p $client_secret -b $scb_fullpath
