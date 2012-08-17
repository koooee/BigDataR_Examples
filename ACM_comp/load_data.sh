#!/bin/bash -e
# This script will load the ACM 2012 Hackathon data into a postgres database on BigDataR Linux
# Install and Verify MADlib for in-database machine learning

#    Copyright (C) 2012 Nick Kolegraff BigDataR Linux
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.



# this is meant to run on a fresh boot of BigDataR
# I'm gun-slingin' here so not doing a ton of error checking

if [ ! `mountpoint -q /mnt` ]; then
    echo "You must mount /mnt to some device"
    echo "Usually a command like: sudo mount /dev/xvdf /mnt"
    exit 1
fi

# don't panic .. this is symlinked to /mnt
pushd ~/work_in_here

# get the data from BigDataR repo (aka Dropbox)
wget -O - https://www.dropbox.com/s/27ijs01u0s99l3m/small_data.tar.gz | tar -x
wget -O - https://www.dropbox.com/s/iv2y12duyvwuiv1/big_data.tar.gz | tar -x
wget -O - https://www.dropbox.com/s/dfuqu00pm0jlay1/small_product_data.xml.gz | tar -x
wget -O - https://www.dropbox.com/s/ovx1n98sid4dw5g/product_data.tar.gz | tar -x

# Scrub and load data into postgres
# remove the escape character as not to confuse postgres loader
echo -n "Scrubbing Data..."
sed -i 's/\\//g' small_data/*.csv big_data/*.csv
echo "Done."

# generate sql to load data
cat <<EOF > temp.sql
-- drop table small_data;
-- drop table big_data;
create table small_data_train (
       userid varchar(100)
       ,sku varchar(50)
       ,category varchar(20)
       ,query varchar(2000)
       ,click_time timestamp without time zone
       ,query_time timestamp without time zone
);

create table small_data_test (
       userid varchar(100)
       ,sku varchar(50)
       ,category varchar(20)
       ,query varchar(2000)
       ,click_time timestamp without time zone
       ,query_time timestamp without time zone
);

create table big_data_train (
       userid varchar(100)
       ,sku varchar(50)
       ,category varchar(20)
       ,query varchar(2000)
       ,click_time timestamp without time zone
       ,query_time timestamp without time zone
);

create table big_data_test (
       userid varchar(100)
       ,sku varchar(50)
       ,category varchar(20)
       ,query varchar(2000)
       ,click_time timestamp without time zone
       ,query_time timestamp without time zone
);

COPY small_data_train (userid, sku, category, click_time, query_time)
FROM 'small_data/train_small.csv'
WITH DELIMITER E'\x2c';

COPY small_data_test (userid, sku, category, click_time, query_time)
FROM 'small_data/test_small.csv'
WITH DELIMITER E'\x2c';

COPY big_data_train (userid, sku, category, click_time, query_time)
FROM 'big_data/train_big.csv'
WITH DELIMITER E'\x2c';

COPY big_data_test (userid, sku, category, click_time, query_time)
FROM 'big_data/test_big.csv'
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
    echo "nick@bigdatarlinux.com"
    exit 1;
fi
echo "Success!"

# now we loads the precious...
psql -f temp.sql acm;