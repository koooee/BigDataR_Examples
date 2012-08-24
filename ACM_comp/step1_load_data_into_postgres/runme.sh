# run postgres service in the background keeping a log in .pgsql.log
((postgres -D /mnt/data 2>&1) > ~/.pgsql.log) &
if [ $? -eq 0 ]; then echo "Yeah! postgres is running!"; else echo ":-( postgres failed to start. email nick@bigdatarlinux.com"; fi

sleep 10;  # If I don't do this sometimes it breaks

# install MADlib
echo -n "Installing MADlib..."
(/usr/local/madlib/bin/madpack -p postgres -c play/play@localhost/acm install 2>&1) > /dev/null
echo "Done."

#verify the install
echo -n "Verifying the MADlib install..."
(/usr/local/madlib/bin/madpack -p postgres -c play/play@localhost/acm install-check 2>&1) > /dev/null
if [ $? -eq 1 ]; then
    echo "There was an error installing MADlib to your database schema"
    echo "Please try to re-install and if the error persists send an email to:"
    echo "nick@bigdatarlinux.com"
    exit 1;
fi
echo "Success!"
