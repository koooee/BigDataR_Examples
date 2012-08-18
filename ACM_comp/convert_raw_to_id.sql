-- convert columns to a id mapping
create table big_data_train_userid_mapping as select distinct userid from big_data_train;
create table big_data_train_sku_mapping as select distinct sku from big_data_train;
create table big_data_train_category_mapping as select distinct category from big_data_train;
create table big_data_train_query_mapping as select distinct query from big_data_train;
alter table big_data_train_category_mapping add category_id serial;
alter table big_data_train_query_mapping add query_id serial;
alter table big_data_train_sku_mapping add sku_id serial;
alter table big_data_train_userid_mapping add userid_id serial;

-- join back to main table so we can get the pretty ids
create table big_data_train_ids as select
	bdt.userid
	,userid_id
	,bdt.sku
	,sku_id
	,bdt.category
	,category_id
	,bdt.query
	,query_id
	,click_time
	,query_time
-- a note on alias convention: first letter then any letter after an underscore
-- example: big_data_train -> b*_d*_t -> bdt

from big_data_train bdt
     ,big_data_train_userid_mapping bdtum
     ,big_data_train_sku_mapping bdtsm
     ,big_data_train_category_mapping bdtcm
     ,big_data_train_query_mapping bdtqm
where
	bdt.userid = bdtum.userid
	and bdt.sku = bdtsm.sku
	and bdt.category = bdtcm.category
	and bdt.query = bdtqm.query;