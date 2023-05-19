# Cassandra Column Encryption Demo

This repository contains a Python script and helper shell scripts demonstrating the usage of the AES256 column encryption feature in the Cassandra Python driver. 

## Getting Started

These instructions will help you to run the scripts on your local machine for development and testing purposes.

### Prerequisites

- Python 3.6 or newer
- An Astra database, with the 
- Unix-like environment (e.g., Linux, MacOS, WSL) for the shell scripts

### File Descriptions

- `demo.py`: This Python script connects to a Cassandra database, encrypts specific column data, and guides the demo while performing basic read/write operations. 

- `cqlsh.sh`: A script to launch a CQLSH instance so that you can show the encrypted database rows

- `setup.sh`: A script to download cqlsh, ensure you have the proper cassandra driver package, and guide you through setting up the necessary variables to get started

### Running the demo

Clone this repo by
