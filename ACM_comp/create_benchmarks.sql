-- Get the top 5 skus for both the big and small data problems
--small data
drop table if exists small_data_best_five;
create table small_data_best_five as 
select
  sku
  ,count(*)
from small_data_train
group by sku
order by count(*) desc
limit 5;

-- big data
drop table if exists big_data_best_five;
create table big_data_best_five as 
select
  sku
  ,count(*)
from big_data_train
group by sku
order by count(*) desc
limit 5;



-- Get the top 5 sku counts in each category for the big and small data problems
-- WARNING -- this takes forever to run on EBS volumes without IOPS

-- small data
drop table if exists small_data_category_counts;
create table small_data_category_counts as
select
  category
  ,sku
  ,count(*)
from small_data_train a
group by
  category
  ,sku
order by count(*);

drop table if exists small_data_top_5_skus_by_category;
create table small_data_top_5_skus_by_category as 
select
  a.category
  ,a.sku
from small_data_category_counts a 
where a.sku in (
      select b.sku
      from category_counts b
      where a.category=b.category	
      order by b.count desc
      limit 5
);

-- big data
drop table if exists big_data_category_counts;
create table big_data_category_counts as
select
  category
  ,sku
  ,count(*)
from big_data_train a
group by
  category
  ,sku
order by count(*);

drop table if exists big_data_top_5_skus_by_category;
create table big_data_top_5_skus_by_category as 
select
  a.category
  ,a.sku
from big_data_category_counts a 
where a.sku in (
      select b.sku
      from category_counts b
      where a.category=b.category	
      order by b.count desc
      limit 5
);

COPY big_data_top_5_skus_by_category TO '/mnt/big_data_top_5_skus_by_category' WITH CSV;
COPY small_data_best_five to '/mnt/small_data_best_five' WITH CSV;
COPY big_data_best_five to '/mnt/big_data_best_five' WITH CSV;
COPY small_data_top_5_skus_by_category TO '/mnt/small_data_top_5_skus_by_category' WITH CSV;