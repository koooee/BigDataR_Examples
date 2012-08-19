create table small_data_test_query as 
select distinct query from small_data_test;


create table small_data_test_query_mapping as 
select 
  a.query
  ,b.query_id 
from small_data_test_query a 
left join small_data_train_query_mapping b 
on a.query=b.query;

create table small_data_test_file as
select
  a.query
  ,b.query_id
  ,a.category
from small_data_test a
join small_data_test_query_mapping b
on a.query=b.query;

COPY small_data_test_file TO '/mnt/small_data_test_file' WITH CSV;