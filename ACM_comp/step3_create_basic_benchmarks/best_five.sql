create table small_best_five as 
select
  sku
  ,count(*)
from small_data_train
group by sku
order by count(*) desc
limit 5;

COPY small_best_five to '/mnt/small_best_five' WITH CSV;