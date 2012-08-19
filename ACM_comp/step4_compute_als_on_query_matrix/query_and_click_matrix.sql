create table click_matrix as 
select 
       userid_id
       ,sku_id
       ,count(*) 
from small_data_train_ids 
group by userid_id, sku_id;

create table query_matrix as 
select 
       query_id
       ,sku_id
       ,count(*) 
from small_data_train_ids 
group by query_id, sku_id;