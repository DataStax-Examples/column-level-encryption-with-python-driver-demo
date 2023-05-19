import os
import sys
import csv
from cassandra.policies import ColDesc, AES256ColumnEncryptionPolicy, AES256_KEY_SIZE_BYTES, AES256_BLOCK_SIZE_BYTES
from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider


# Setting up configuration constants
keyspace = 'my_ks'
table = 'my_table'
config_file = "../GeneratedToken.csv"

# store the key somewhere, make sure to read it in when you want to read back this data
# KEY = os.urandom(AES256_KEY_SIZE_BYTES)
KEY = b'\xdb\x8b\xd0$I \x8c\x15\x99\x9c\xe9\xdf\x050O\xa6Fo\x7f_\xe7\x06\x84\xda\x9d\xe4\xdf/\x97\x99\xbd\x18'
CLOUD_CONFIG = {
    'secure_connect_bundle': '../secure-connect-playlist.zip'
}


# store the IV somewhere, make sure to read it in when you want to read back this data
#iv = os.urandom(AES256_BLOCK_SIZE_BYTES)
iv = b'\x83\x97\x97\\V\x0c\x1eQe\xb4\xe5k\x87Z\x14\xe6'


# function to load the GeneratedToken.csv file into a python dictionary


def load_token_file(config_file):
    with open(config_file, 'r') as f:
        reader = csv.DictReader(f)
        row = next(reader)

        # Stripping BOM and double quotes
        clean_row = {key.lstrip('\ufeff').strip('"'): value for key, value in row.items()}

        client_id = clean_row["Client Id"]
        client_secret = clean_row["Client Secret"]
        role = clean_row["Role"]
        token = clean_row["Token"]

        return client_id, client_secret, role, token



# Function to display the CQL to set up for this demo
def setup():
    print(
        f"DROP TABLE IF EXISTS {keyspace}.{table}; CREATE TABLE IF NOT EXISTS {keyspace}.{table} (clear text PRIMARY KEY, crypt blob );")
    print(f"select * from {keyspace}.{table};")

# Function to create and setup Cassandra connection session


def create_session(client_id, client_secret):
    # Create encryption policy object and describe column for encryption
    cl_policy = AES256ColumnEncryptionPolicy(iv=iv)
    col_desc = ColDesc(keyspace, table, 'crypt')
    cql_type = "ascii"
    # Add column to the policy for encryption
    cl_policy.add_column(col_desc, KEY, cql_type)

    # Connect to the cluster with encryption policy and other configurations
    AUTH_PROVIDER = PlainTextAuthProvider(
        client_id,
        client_secret
    )
    cluster = Cluster(column_encryption_policy=cl_policy,
                      cloud=CLOUD_CONFIG, auth_provider=AUTH_PROVIDER)
    return cluster.connect()

# Function to insert data into the table


def insert_data(session, clear, crypt):
    # Prepare the CQL statement
    prepared = session.prepare(
        f"insert into {keyspace}.{table} (clear, crypt) values (?, ?)")
    try:
        # Execute the CQL statement
        session.execute(prepared, (clear, crypt))
        print("Data committed\n")
    except Exception as e:
        print(f"Error: {e}")

# Function to read and print data from the table


def read_data(session):
    print("Reading data back")
    # Execute the SELECT CQL statement
    rows = session.execute(f"SELECT * FROM {keyspace}.{table}")
    #rows = session.execute("SELECT * FROM example.roger_cle_table where clear = 'baz'")
    # Print each row of data
    for row in rows:
        print("clear:", row.clear, "crypt:", row.crypt)
    print("\n")

# Main function to drive the program


def main():

    # check if the --setup argument was given
    if '--setup' in sys.argv:
        setup()
        return

    # Load config file
    client_id, client_secret, role, token = load_token_file(config_file)

    # Create session
    session = create_session(client_id, client_secret)

    # Get user input for clear and crypt values
    clear = input("Enter clear value: ")
    crypt = input("Enter crypt value: ")

    # Insert data and read data
    insert_data(session, clear, crypt)
    read_data(session)


# Python idiom to check if the script is being run as the main module
if __name__ == "__main__":
    main()
