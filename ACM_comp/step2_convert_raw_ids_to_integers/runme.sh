(psql -f convert_raw_to_id.sql acm 2>&1) > /dev/null
(psql -f map_big_data_test.sql acm 2>&1) > /dev/null