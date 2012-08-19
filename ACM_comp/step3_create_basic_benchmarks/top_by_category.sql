-- Get the top 5 products for each category

create table small_category_counts as
select
  category
  ,sku
  ,count(*)
from small_data_train a
group by
  category
  ,sku
order by count(*);

create table small_top_5_skus_by_category as 
select
  a.category
  ,a.sku
from category_counts a 
where a.sku in (
      select b.sku
      from category_counts b
      where a.category=b.category	
      order by b.count desc
      limit 5
);

COPY small_top_5_skus_by_category TO '/mnt/small_top_5_skus_by_category' WITH CSV;