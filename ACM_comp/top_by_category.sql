-- Get the top 5 products for each category

drop table if exists category_counts;
create table category_counts as
select
  category
  ,sku
  ,count(*)
from small_data_train a
group by
  category
  ,sku
order by count(*);

drop table if exists top_5_skus_by_category;
create table top_5_skus_by_category as 
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