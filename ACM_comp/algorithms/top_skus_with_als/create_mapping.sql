-- we need to convert raw ids to an internal mapping id so we can build matricies in matrix market format

drop table if exists small_data_userid_mapping;
drop table if exists small_data_sku_mapping;
drop table if exists small_data_category_mapping;
drop table if exists small_data_query_mapping;
drop table if exists big_data_userid_mapping;
drop table if exists big_data_sku_mapping;
drop table if exists big_data_category_mapping;
drop table if exists big_data_query_mapping;


-- Create a mapping table and an index for the small data problem
create table small_data_userid_mapping as select distinct userid from (select userid from small_data_train UNION select userid from small_data_test) a;
create table small_data_sku_mapping as select distinct sku from small_data_train;
create table small_data_category_mapping as select distinct category from (select category from small_data_train UNION select category from small_data_test) a;
create table small_data_query_mapping as select distinct query from (select query from small_data_train UNION select query from small_data_test) a;

alter table small_data_category_mapping add category_id serial;
alter table small_data_query_mapping add query_id serial;
alter table small_data_sku_mapping add sku_id serial;
alter table small_data_userid_mapping add userid_id serial;

-- Create a mapping table and an index for the big data problem
create table big_data_userid_mapping as select distinct userid from (select userid from big_data_train UNION select userid from big_data_test) a;
create table big_data_sku_mapping as select distinct sku from big_data_train;
create table big_data_category_mapping as select distinct category from (select category from big_data_train UNION select category from big_data_test) a;
create table big_data_query_mapping as select distinct query from (select query from big_data_train UNION select query from big_data_test) a;

alter table big_data_category_mapping add category_id serial;
alter table big_data_query_mapping add query_id serial;
alter table big_data_sku_mapping add sku_id serial;
alter table big_data_userid_mapping add userid_id serial;