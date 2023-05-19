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

pip install -r requirements.txt

# Get the current keyspace and table from demo.py
current_keyspace=$(awk -F\' '/keyspace =/ {print $2}' demo.py)
current_table=$(awk -F\' '/table =/ {print $2}' demo.py)
cunrent_scb_file=$(awk -F\' '/scb_file =/ {print $2}' demo.py)
current_config_file=$(awk -F\' '/config_file =/ {print $2}' demo.py)

# Prompt the user for keyspace and table variables
echo "Enter keyspace name (current: $current_keyspace, press Enter to keep current):"
read keyspace
echo "Enter table name (current: $current_table, press Enter to keep current):"
read table
echo "Enter scb file name (current: $cunrent_scb_file, press Enter to keep current):"
read scb_file
# Check that the scb_file file exists
if [ -n "$scb_file" ] && [ ! -f "$scb_file" ]; then
  echo "File $scb_file does not exist"
  exit 1
fi
echo "Enter config file name (current: $current_config_file, press Enter to keep current):"
read config_file
# Check that the config_file file exists
if [ -n "$config_file" ] && [ ! -f "$config_file" ]; then
  echo "File $config_file does not exist"
  exit 1
fi

# If the user provided a new keyspace, update it in demo.py
if [ -n "$keyspace" ] && [ "$keyspace" != "$current_keyspace" ]; then
  perl -pi -e "s/keyspace = '$current_keyspace'/keyspace = '$keyspace'/g" demo.py
fi

# If the user provided a new table, update it in demo.py
if [ -n "$table" ] && [ "$table" != "$current_table" ]; then
  perl -pi -e "s/table = '$current_table'/table = '$table'/g" demo.py
fi

# If the user provided a new scb file, update it in demo.py
if [ -n "$scb_file" ] && [ "$scb_file" != "$cunrent_scb_file" ]; then
  perl -pi -e "s/scb_file = '$cunrent_scb_file'/scb_file = '$scb_file'/g" demo.py
fi

# If the user provided a new config file, update it in demo.py
if [ -n "$config_file" ] && [ "$config_file" != "$current_config_file" ]; then
  perl -pi -e "s/config_file = '$current_config_file'/config_file = '$config_file'/g" demo.py
fi
