package ucare.microbenchmark;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class App {
  private static final App instance = new App();
  // private static final int NUMBER_OF_THREADS = 1;
  // private static final int NUMBER_OF_OBJECTS_EACH_TIME = 1;
  // private static final int DEFAULT_BYTES = 1000000;
  private static final double percentages[] = {0.01, 0.03, 0.05};

  // 1 MB default
  // private static void createManyShortLivedObjects(List<Integer> bytes) {
  //   for (int i = 0; i < NUMBER_OF_THREADS; i++) {
  //     Thread thread =
  //         new Thread(
  //             () -> {
  //               while (true) {
  //                 for (int j = 0; j < NUMBER_OF_OBJECTS_EACH_TIME; j++) {
  //                   for (Integer _bytes : bytes) {
  //                     byte shortlived[] = new byte[_bytes];
  //                   }
  //                   // int shortlived2[] = new int[100000];
  //                   // Double shortLivedDouble = new Double(1.0d);
  //                 }
  //               }
  //             });

  //     DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
  //     LocalDateTime now = LocalDateTime.now();

  //     System.out.println("Starting thread @ " + now.toString());
  //     thread.start();
  //   }
  // }

  private static void createManyShortLivedObjects(
      int heapSizeInMB, int percentageNum, int numThreads) {
    int heapSizeInBytes = heapSizeInMB * 1000000;
    System.out.println(
        "Info numThreads: "
            + numThreads
            + " heapSizeinMb "
            + heapSizeInMB
            + " percentageNum "
            + percentageNum);
    for (int i = 0; i < numThreads; i++) {
      Thread thread =
          new Thread(
              () -> {
                while (true) {
                  byte shortlived1[] = new byte[256];
                  byte shortlived2[] = new byte[1024];
                  byte shortlived3[] = new byte[2048];
                  // for (int j = 0; j < NUMBER_OF_OBJECTS_EACH_TIME; j++) {
                  // for (int k = 0; k < percentageNum; k++) {
                  // System.out.println(
                  // "Allocating " + (int) Math.round(percentages[k] * heapSizeInBytes) + "B");
                  // byte shortlived[] =
                  //     new byte[(int) Math.round(percentages[k] * heapSizeInBytes)];
                  // }
                  // int shortlived2[] = new int[100000];
                  // Double shortLivedDouble = new Double(1.0d);
                }
              });

      DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
      LocalDateTime now = LocalDateTime.now();

      System.out.println("Starting thread-" + i + " @ " + now.toString());
      thread.start();
    }
  }

  public static void main(String[] args) {
    int heapSize = 0;
    int percentageNum = 0;
    int numThreads = 0;

    if (args.length == 3) {
      heapSize = Integer.parseInt(args[0]);
      percentageNum = Integer.parseInt(args[1]);
      numThreads = Integer.parseInt(args[2]);

      if (heapSize <= 10
          || percentageNum <= 0
          || percentageNum > percentages.length
          || numThreads == 0) {
        System.out.println("The args are bad!");
        System.exit(-1);
      }
      // for (int i = 0; i < args.length; i++) {

      // bytes = Integer.parseInt(args[0]);
      // alloc.add(Integer.parseInt(args[i]));
      // }
    } else {
      System.out.println("Need 3 args!");
      System.out.println("program <heapSize> <percentageNum> <numThreads>");
      System.exit(-1);
    }

    System.out.println(
        "Creating JVM with "
            + heapSize
            + " MB, percentageNum "
            + percentageNum
            + " and num of threads "
            + numThreads);
    createManyShortLivedObjects(heapSize, percentageNum, numThreads);

    try {
      int sec = 0;
      while (sec < 120) {
        System.out.println("Has been running for " + (sec + 1) + " seconds");
        Thread.sleep(1000);
        sec++;
      }
    } catch (Exception e) {
      System.exit(-1);
    }

    System.exit(0);
  }
}
