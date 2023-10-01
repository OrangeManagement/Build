#!/bin/bash

. "${BUILD_PATH}/config.sh"

# Mysql required with query logging
# sudo apt-get install percona-toolkit
mysqldumpslow -t 10 /var/log/mysql/mysql-slow.log > ${OUTPUT_PATH}/slow_queries.log
mysqldumpslow -t 10 -s l /var/log/mysql/mysql-slow.log > ${OUTPUT_PATH}/locked_queries.log
pt-query-digest /var/log/mysql/mysql-slow.log > ${OUTPUT_PATH}/query_details.log