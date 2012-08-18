echo -n "Counting Rows..."
TOTAL_ROWS=`cat $1 | cut -d, -f1 | sort | uniq | grep -c ^`
echo "$TOTAL_ROWS"

echo -n "Counting Columns..."
TOTAL_COLUMNS=`cat $1 | cut -d, -f2 | sort | uniq | grep -c ^`
echo "$TOTAL_COLUMNS"

echo -n "Counting Non-zeros..."
NON_ZEROS=`grep -c ^ $1`
echo "$NON_ZEROS"

echo -n "Adding Matrix Market Header to File..."
sed "1i\%%MatrixMarket matrix coordinate real general\n%\n%comments\n%\n\t$TOTAL_ROWS\t$TOTAL_COLUMNS\t$NON_ZEROS" $1 > $1.matrix.market
sed -i "s/,/\t/g" $1.matrix.market
echo "Done."