create table small_click_matrix as 
select 
       userid_id
       ,sku_id
       ,count(*) 
from small_data_train_ids 
group by userid_id, sku_id;

create table small_query_matrix as 
select 
       query_id
       ,sku_id
       ,count(*) 
from small_data_train_ids 
group by query_id, sku_id;

COPY small_query_matrix TO '/mnt/small_query_matrix' WITH CSV;
COPY small_click_matrix TO '/mnt/small_click_matrix' WITH CSV;