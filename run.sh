#!/usr/bin/env sh

export DATA_DIR=./data/test-run/1

export JAVA='../clean-GCPredictor-OpenJDK8/sources/openjdk8/build/linux-x86_64-normal-server-release/images/j2sdk-image/bin/java'

run_build() {
    mvn clean package
}

run_exp() {
    mkdir -p $DATA_DIR
    export LD_LIBRARY_PATH="/home/rayandrew/Downloads/elephantTracks-2.0-beta-3/install/:$LD_LIBRARY_PATH"
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
      -cp ./target/micro-benchmark-1.0-SNAPSHOT.jar:/home/rayandrew/Downloads/elephantTracks-2.0-beta-3/asm-3.1.jar:/home/rayandrew/Downloads/elephantTracks-2.0-beta-3/install \
      -agentlib:ElephantTracks \
      ucare.microbenchmark.App "$@"
}

run_exp_noheap() {
    mkdir -p $DATA_DIR
    java \
      -Xloggc:$DATA_DIR/gc.log \
      -XX:+PrintGCDetails \
      -XX:+PrintGCApplicationStoppedTime \
      -XX:+PrintGCApplicationConcurrentTime \
      -XX:+PrintGCDateStamps \
      -XX:+UseParallelGC \
      -XX:+UseParallelOldGC \
      -XX:+ParallelGCVerbose \
      -XX:+PrintParallelOldGCPhaseTimes \
      -XX:+TraceParallelOldGCTasks \
      -Xmx10M \
      -cp ./target/micro-benchmark-1.0-SNAPSHOT.jar \
      ucare.microbenchmark.App "$@"
}

run_exp_mod_noheap() {
    mkdir -p $DATA_DIR
    ${JAVA} \
      -Xloggc:$DATA_DIR/gc.log \
      -Xlogucare:$DATA_DIR/ucare.log \
      -XX:+PrintGCDetails \
      -XX:+ParallelGCVerbose \
      -XX:+PrintGCApplicationStoppedTime \
      -XX:+PrintGCApplicationConcurrentTime \
      -XX:+PrintGCDateStamps \
      -XX:+UseParallelGC \
      -XX:+UseParallelOldGC \
      -XX:StringTableSize=120026 \
      -Xmx10M \
      -cp ./target/micro-benchmark-1.0-SNAPSHOT.jar \
      ucare.microbenchmark.App "$@"

      # -XX:+ParallelGCVerbose \
      # -XX:+PrintParallelOldGCPhaseTimes \
      # -XX:+TraceParallelOldGCTasks \
}

run_exp_mod_new() {
    mkdir -p $DATA_DIR
    heap_size=$1
    # echo $heap_size $@
    ${JAVA} \
      -Xloggc:$DATA_DIR/gc.log \
      -Xlogucare:$DATA_DIR/ucare.log \
      -XX:+PrintGCDetails \
      -XX:+ParallelGCVerbose \
      -XX:+PrintGCApplicationStoppedTime \
      -XX:+PrintGCApplicationConcurrentTime \
      -XX:+PrintGCDateStamps \
      -XX:+UseParallelGC \
      -XX:+UseParallelOldGC \
      -Xmx"${heap_size}"M \
      -cp ./target/micro-benchmark-1.0-SNAPSHOT.jar \
      ucare.microbenchmark.App "$@"

      # -XX:+ParallelGCVerbose \
      # -XX:+PrintParallelOldGCPhaseTimes \
      # -XX:+TraceParallelOldGCTasks \
}

run_exp_modified() {
    mkdir -p $DATA_DIR
    ${JAVA} \
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
      ucare.microbenchmark.App "$@"
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
      ucare.microbenchmark.App "$@"
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
      ucare.microbenchmark.App "$@"
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
  command=$1
  shift;
  run_${command} "$@"
fi
