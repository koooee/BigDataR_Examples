#!/bin/bash
# Scrub and load data into postgres

# remove the escape character as not to confuse postgres
echo -n "Scrubbing Data..."
sed -i 's/\\//g' user_queries;
echo "Done."

# generate sql to load data
cat <<EOF > temp.sql
-- drop table user_queries;
-- drop table user_clicks;
create table user_queries (
       quser varchar(100)
       ,qstring varchar(2000)
       ,qtime timestamp without time zone
);

create table user_clicks (
       cuser varchar(100)
       ,csku bigint
       ,ctime timestamp without time zone
       ,csku_category varchar(20)
);

COPY user_queries (quser, qstring, qtime)
FROM 'user_queries'
WITH DELIMITER E'\xfe';

COPY user_clicks (cuser, csku, ctime, csku_category)
FROM 'user_page_views'
WITH DELIMITER E'\x2c';
EOF

psql -c 'CREATE DATABASE acm' test;

# install MADlib
echo -n "Installing MADlib..."
(/usr/local/madlib/bin/madpack -p postgres -c play/play@localhost/acm install 2>&1) > /dev/null
echo "Done."

#verify the install
echo -n "Verifying the MADlib install..."
(/usr/local/madlib/bin/madpack -p postgres -c play/play@localhost/acm install-check 2>&1) > /dev/null
if [ $? -eq 1 ]; then
    echo "There was an error installing MADlib to your database schema"
    echo "Please try to re-install and if the error persists send an email to:"
    echo "info@bigdatarlinux.com"
    exit 1;
fi
echo "Success!"

# create the tables and load the data
psql -f temp.sql acm;