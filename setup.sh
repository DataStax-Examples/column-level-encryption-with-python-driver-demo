#!/bin/sh

# if cqlsh-astra.tar.gz or cqlsh-astra exists delete them
if [ -f cqlsh-astra.tar.gz ]; then
    rm cqlsh-astra.tar.gz
fi

if [ -d cqlsh-astra ]; then
    rm -rf cqlsh-astra
fi

# Get new cqlsh-astra.tar.gz and extract it
#wget https://downloads.datastax.com/enterprise/cqlsh-astra.tar.gz
curl -L0 https://downloads.datastax.com/enterprise/cqlsh-astra.tar.gz --output cqlsh-astra.tar.gz

if [ ! -f cqlsh-astra.tar.gz ]; then
    echo "CQL shell package did not download properly. Program exiting..."
    exit 1
fi

tar -zxvf cqlsh-astra.tar.gz
rm cqlsh-astra.tar.gz

# Detect pip command and check if pip is installed
if command -v pip3 &> /dev/null; then
    pip=pip3
elif command -v pip &> /dev/null; then
    pip=pip
else
    echo "pip is not installed"
    # detect package manager and suggest how to install pip
    if command -v apt-get &> /dev/null; then
        echo "Try running 'sudo apt-get install python3-pip'"
    elif command -v yum &> /dev/null; then
        echo "Try running 'sudo yum install python3-pip'"
    elif command -v brew &> /dev/null; then
        echo "Try running 'brew install python3-pip'"
    fi
    echo "Program exiting..."
    exit 1
fi

$pip install -r requirements.txt || echo 'pip install did not run successfully. Program exiting...'; exit 1

# Get the current keyspace and table from demo.py
current_keyspace=$(awk -F\' '/keyspace =/ {print $2}' demo.py)
current_table=$(awk -F\' '/table =/ {print $2}' demo.py)
current_scb_file=$(awk -F\' '/scb_file =/ {print $2}' demo.py)
current_config_file=$(awk -F\' '/config_file =/ {print $2}' demo.py)

printf "\n\n"
# Prompt the user for keyspace and table variables
echo "Enter keyspace name (current: $current_keyspace, press Enter to keep current)"
echo "keyspace name: \c"
read keyspace

echo "Enter table name (current: $current_table, press Enter to keep current)"
echo "table name: \c"
read table

echo "Enter SCB location (current: $current_scb_file, press Enter to keep current):"
echo "SCB location: \c"
read scb_file
# Check that the scb_file file exists, prompt again if not found
while [ -n "$scb_file" ] && [ ! -f "$scb_file" ]; do
    echo "File $scb_file does not exist"
    echo "Enter SCB location (current: $current_scb_file, press Enter to keep current):"
    echo "SCB location: \c"
    read scb_file
done

echo "Enter config file location (current: $current_config_file, press Enter to keep current)"
echo "Config location: \c"
read config_file
# Check that the config_file file exists, prompt again if not found
while [ -n "$config_file" ] && [ ! -f "$config_file" ]; do
    echo "File $config_file does not exist"
    echo "Enter config file location (current: $current_config_file, press Enter to keep current)"
    echo "Config location: \c"
    read config_file
done


# If the user provided a new keyspace, update it in demo.py
if [ -n "$keyspace" ] && [ "$keyspace" != "$current_keyspace" ]; then
    perl -pi -e "s/keyspace = '$current_keyspace'/keyspace = '$keyspace'/g" demo.py
fi

# If the user provided a new table, update it in demo.py
if [ -n "$table" ] && [ "$table" != "$current_table" ]; then
    perl -pi -e "s/table = '$current_table'/table = '$table'/g" demo.py
fi

# If the user provided a new scb file, update it in demo.py
if [ -n "$scb_file" ] && [ "$scb_file" != "$current_scb_file" ]; then
    perl -pi -e "s|scb_file = '$current_scb_file'|scb_file = '$scb_file'|g" demo.py
fi

# If the user provided a new config file, update it in demo.py
if [ -n "$config_file" ] && [ "$config_file" != "$current_config_file" ]; then
    perl -pi -e "s|config_file = '$current_config_file'|config_file = '$config_file'|g" demo.py
fi
