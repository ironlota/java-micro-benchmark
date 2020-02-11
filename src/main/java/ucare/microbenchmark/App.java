package ucare.microbenchmark;

import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime;

public class App {
  private static final App instance = new App();
  private static final int NUMBER_OF_THREADS = 1;
  private static final int NUMBER_OF_OBJECTS_EACH_TIME = 1;

  private static void createManyShortLivedObjects() {
    for (int i = 0; i < NUMBER_OF_THREADS; i++) {
      Thread thread = new Thread(
              () -> {
                while (true) {
                  for (int j = 0; j < NUMBER_OF_OBJECTS_EACH_TIME; j++) {

                   byte shortlived[] = new byte[1000000];
                    // int shortlived2[] = new int[100000];
                    // Double shortLivedDouble = new Double(1.0d);
                  }
                  // try {
                  //   Thread.sleep(100);
                  // } catch (Exception e) {

                  // }
                }
              });
      
      DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");  
   LocalDateTime now = LocalDateTime.now();
   
   System.out.println("Starting thread @ " + now.toString());
      thread.start();
    }
  }

  public static void main(String[] args) {
    System.out.println("Hello world!");

    createManyShortLivedObjects();

    try {
      int sec = 0;
      while (sec < 30) {
        System.out.println("Has been running for " + (sec + 1) + " seconds");
        Thread.sleep(1000);
        sec++;
      }
    } catch (Exception e) {
      System.exit(-1);
    }

    System.exit(0);
    
    // try {
    //   while (true) {
    //     int[][] arr = new int[10000000][];
    //     for (int i = 0; i < 5; i++) arr[i] = new int[10000000];
    //     // int[] arr = new int[1000000];
    //     // int[] arr2 = new int[1000000];
    //     Thread.sleep(1500);
    //     // System.gc();
    //   }
    // } catch (Exception e) {

    // }
  }
}
