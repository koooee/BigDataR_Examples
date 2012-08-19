create table best_five as 
select
  sku
  ,count(*)
from big_data_train
group by sku
order by count(*) desc
limit 5;

COPY best_five to '/mnt/best_five' WITH CSV;