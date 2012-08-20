# run postgres service in the background keeping a log in .pgsql.log
((postgres -D /mnt/data 2>&1) > ~/.pgsql.log) &
if [ $? -eq 0 ]; then echo "Yeah! postgres is running!"; else echo ":-( postgres failed to start. email nick@bigdatarlinux.com"; fi
