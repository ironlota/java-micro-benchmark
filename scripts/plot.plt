if (!exists("plot_title"))  plot_title="Default Plot"
if (!exists("output_file")) output_file="output.eps"
if (!exists("x_range"))     x_range=3
if (!exists("data_file"))   exit
  
set term pos eps color solid font ",27"
set size 2,2
set title plot_title
set key Left
set xlabel "GC Pause (ms)"
set ylabel "CDF"
set output output_file
set key bottom right
set datafile separator ","
set xrange [0:x_range]
set yrange [0:1]
set grid ytics
set grid xtics

plot \
 data_file u 2:1 with lines t field_title dt 1 lw 3 lc rgb "green"