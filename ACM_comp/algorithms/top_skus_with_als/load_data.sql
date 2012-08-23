drop table if exists small_data_train;
drop table if exists small_data_test;
drop table if exists big_data_train;
drop table if exists big_data_test;

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
       ,category varchar(20)
       ,query varchar(2000)
       ,click_time timestamp without time zone
       ,query_time timestamp without time zone
);

COPY small_data_train (userid, sku, category, query, click_time, query_time)
FROM '/mnt/small_data/train_small.csv'
WITH CSV;

COPY small_data_test (userid, category, query, click_time, query_time)
FROM '/mnt/small_data/test_small.csv'
WITH CSV;

COPY big_data_train (userid, sku, category, query, click_time, query_time)
FROM '/mnt/big_data/train_big.csv'
WITH CSV;

COPY big_data_test (userid, category, query, click_time, query_time)
FROM '/mnt/big_data/test_big.csv'
WITH CSV;