#!/bin/sh
# Adding secret from CLI
echo "mydbpw" | docker secret create psql_password -