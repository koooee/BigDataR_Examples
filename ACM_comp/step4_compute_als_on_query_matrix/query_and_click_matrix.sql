drop table if exists click_matrix;
create table click_matrix as 
select 
       userid_id
       ,sku_id
       ,count(*) 
from big_data_train_ids 
group by userid_id, sku_id;

drop table if exists query_matrix;
create table query_matrix as 
select 
       query_id
       ,sku_id
       ,count(*) 
from big_data_train_ids 
group by query_id, sku_id;

COPY query_matrix to '/mnt/query_matrix' with csv;