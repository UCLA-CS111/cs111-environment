CS 111 Environment
==================
This repository contains the code for a Docker-based environment for completing CS 111 assignments.

Usage
-----
First, clone this repository and `cd` into it.

To build the Docker environment: `docker build -t samkumar/cs111-environment .`

To start the Docker environment: `docker compose up -d`

To access the Docker environment: `ssh -p 11122 cs111-student@localhost`

To stop the Docker environment: `docker compose down`

File Storage
------------
The home directory for `cs111-student` is stored outside of the Docker container in the directory `.cs111-student-home`.

Credit
------
This is heavily based on the UC Berkeley CS 162 workspace (https://github.com/Berkeley-CS162/cs162-workspace).
