# Cassandra Column Encryption Demo

This repository contains a Python script and helper shell scripts demonstrating the usage of the AES256 column encryption feature in the Cassandra Python driver.

## Overview

The Cassandra Column Encryption Demo showcases how to leverage AES256 column encryption in the Cassandra Python driver. The demo script connects to a Cassandra database, encrypts specific column data, and guides the user through basic read and write operations.

## Prerequisites

To run the demo, ensure that the following prerequisites are met:

- Python 3.6 or newer installed on your machine.
- Access to an Astra database or a local Cassandra cluster.
- A Unix-like environment (e.g., Linux, macOS, WSL) for running the shell scripts.

## File Descriptions

The repository includes the following files:

- `demo.py`: This Python script establishes a connection to the Cassandra database, performs column encryption, and facilitates the demo by executing basic read and write operations.

- `cqlsh.sh`: A shell script that launches a CQLSH (Cassandra Query Language Shell) instance, allowing users to view the encrypted database rows.

- `setup.sh`: A shell script that downloads cqlsh, ensures the appropriate Cassandra driver package is installed, and guides users through the setup process by prompting for necessary variables.

## How to run the demo

To get started with the demo, follow these steps:


1. Obtain a secure connect bundle`secure-connect-<DB Name>.zip` and a Token Configuration file `GeneratedToken.csv` for the desired database to use for the demonstration

2. Create a keyspace in the target database if one doesn't already exist

3. Create a directory to house the demo files, and cd into the directory

   ```shell
   mkdir demos
   cd demos
   ```

4. Place your `secure-connect-<DB Name>.zip` and `GeneratedToken.csv` files into this directory

5. Clone this repository to your local machine using the following command:

   ```shell
   git clone https://github.com/rogerb-ds/CLE-Demo.git
   ```
The resulting hierarchy should be as follows

    demos
    ├── CLE-Demo
    │   ├── LICENSE
    │   ├── README.md
    │   ├── cqlsh.sh
    │   ├── demo.py
    │   ├── requirements.txt
    │   └── setup.sh
     ├── GeneratedToken.csv
    └── secure-connect-bundle.zip

6. Navigate to the cloned repository directory:

   ```shell
   cd CLE-Demo
   ```

7. Run the `setup.sh` script to download cqlsh, install the required Cassandra driver package, and configure necessary variables for the demo.

   ```shell
   sh ./setup.sh
   ```

8. Follow the prompts in the setup script to enter the desired keyspace, table, SCB file location, and configuration file location.

9. Once the setup is complete, you will want to have two different shell windows open so that you can show the contents of the database in one window and modify the contents in another.

10. In the window that will display the database, you can run the `cqlsh.sh` script, which launches a CQLSH instance:

   ```shell
   sh ./cqlsh.sh
   ```


11. In the second window, you can execute the demo script with the `--setup` flag by running the following command.

   ```shell
   python demo.py --setup
   ```
12. It will return the necessary CQL to set up the database for the demo. Copy and paste the CQL into the CQLSH window. It will also include a select that will return 0 results (since this is a new database)

13. Run the demo script again, but without the `--setup` flag and insert some rows.

   ```shell
   python demo.py
   ```

14. Continue running the demo script to insert as many rows as you like. As you insert rows, can you can re-run the select statement from the `python demo.py --setup` output to demonstrate how the rows being added are encrypted in the database, but the python program (using the driver) is able to decrypt and display the encrypted values.
   ```shell
   python demo.py
   ```

## Conclusion

The Cassandra Column Encryption Demo provides a practical example of leveraging AES256 column encryption in the Cassandra Python driver. By running the demo and exploring the provided scripts, you can gain a better understanding of how to secure sensitive column data in your Cassandra applications.

