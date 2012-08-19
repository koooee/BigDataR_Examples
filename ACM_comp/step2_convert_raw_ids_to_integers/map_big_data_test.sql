create table big_data_test_query as 
select distinct query from big_data_test;


create table big_data_test_query_mapping as 
select 
  a.query
  ,b.query_id 
from big_data_test_query a 
left join big_data_train_query_mapping b 
on a.query=b.query;

create table big_data_test_file as
select
  a.query
  ,b.query_id
  ,a.category
from big_data_test a
join big_data_test_query_mapping b
on a.query=b.query;

COPY big_data_test_file TO '/mnt/big_data_test_file' WITH CSV;