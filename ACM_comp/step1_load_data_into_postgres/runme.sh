# run postgres service in the background keeping a log in .pgsql.log
((postgres -D /mnt/data 2>&1) > .pgsql.log) &
