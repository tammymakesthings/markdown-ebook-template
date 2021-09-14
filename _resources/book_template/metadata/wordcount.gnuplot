set title "Word Count Progress - @@TITLE@@"

set datafile separator ','
set xdata time
set timefmt "%Y-%m-%d"
set format x "%Y-%m-%d"

set xlabel "Date"
set ylabel "Word Count"
set yrange [0:75000]
set xtics rotate

set linestyle 101 lw 3 lt rgb "#f62aa0"

plot "wordcount.csv" using 1:2 title "total words" with lines ls 101
