#!/usr/bin/env sh

export DATA_DIR=./data/pscavenge-exp-18

run_build() {
    mvn clean package
}

run_exp() {
    mkdir -p $DATA_DIR
    java \
      -Xloggc:$DATA_DIR/gc.log \
      -XX:+PrintGCDetails \
      -XX:+PrintGCApplicationStoppedTime \
      -XX:+PrintGCApplicationConcurrentTime \
      -XX:+PrintGCDateStamps \
      -XX:+UseParallelGC \
      -XX:+UseParallelOldGC \
      -XX:+PrintHeapAtGC \
      -XX:+PrintHeapAtGCExtended \
      -Xmx10M \
      -cp ./target/micro-benchmark-1.0-SNAPSHOT.jar \
      ucare.microbenchmark.App
}

run_exp_gc() {
    mkdir -p $DATA_DIR
    java \
      -Xloggc:$DATA_DIR/gc.log \
      -XX:+PrintGCDetails \
      -XX:+PrintGCDateStamps \
      -XX:+UseG1GC \
      -Xmx10M \
      -cp ./target/micro-benchmark-1.0-SNAPSHOT.jar \
      ucare.microbenchmark.App
}

run_exp_agent() {
    mkdir -p $DATA_DIR
    export LD_LIBRARY_PATH="/home/rayandrew/Projects/research/gc-predictor/build:${LD_LIBRARY_PATH}"
    java \
      -agentlib:gc-predictor \
      -Xloggc:$DATA_DIR/gc.log \
      -XX:+PrintGCDetails \
      -XX:+PrintGCApplicationStoppedTime \
      -XX:+PrintGCApplicationConcurrentTime \
      -XX:+PrintGCDateStamps \
      -XX:+UseParallelGC \
      -XX:+UseParallelOldGC \
      -Xmx10M \
      -cp ./target/micro-benchmark-1.0-SNAPSHOT.jar \
      ucare.microbenchmark.App
}

run_plot() {
    export RAW_DATA_FILE=$DATA_DIR/gc.log
    export DATA_FILE=$DATA_DIR/result.dat
    export CDF_DATA_FILE=$DATA_DIR/cdf.dat
    export FIELD_TITLE=PScavenge
    export X_RANGE=100
    export OUTPUT_FILE=$DATA_DIR/pscavenge.eps
    # DATA_FILE=./data/pscavenge/cdf.dat FIELD_TITLE=PScavenge x_RANGE=130 OUTPUT_FILE=out.eps ./run.sh plot
    ./scripts/benchmark_parser $RAW_DATA_FILE $DATA_FILE
    ./scripts/cdf $DATA_FILE > $CDF_DATA_FILE
    gnuplot -e "data_file='$CDF_DATA_FILE';field_title='$FIELD_TITLE';plot_title='$PLOT_TITLE';output_file='$OUTPUT_FILE';x_range='$X_RANGE'" ./scripts/plot.plt
}

if [ -z $1 ]
then
  run_help
else
  for command in "$@"
  do
    run_${command}
  done
fi
