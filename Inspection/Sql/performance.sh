#!/bin/bash

. config.sh

# Mysql required with query logging
# sudo apt-get install percona-toolkit
mysqldumpslow -t 10 /var/log/mysql/mysql-slow.log > ${INSPECTION_PATH}/Sql/slow_queries.log
mysqldumpslow -t 10 -s l /var/log/mysql/mysql-slow.log > ${INSPECTION_PATH}/Sql/locked_queries.log
pt-query-digest /var/log/mysql/mysql-slow.log > ${INSPECTION_PATH}/Sql/query_details.log