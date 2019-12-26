#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int p[2]; // Pipe fd: read from 0, write to 1 
  uint32 i; // Loop counter for generating numbers
  uint32 r[1]; // Buffer for reading

  pipe(p);
  if (fork() == 0) { // Child process to write to pipeline
    for (i = 2; i <= 35; i++) {
      write(p[1], &i, sizeof i);
    }
    close(p[0]);
    close(p[1]);
    exit(0); // Terminate process
  } else {
    wait(0); // Finish adding numbers first
    
    // Set STDIN to pipe and close it off
    close(0);
    dup(p[0]);
    close(p[0]);
    close(p[1]);

    int p2[2];
    uint32 r2[1]; // Second buffer for reading

    while (read(0, r, sizeof *r) > 0) {
      printf("prime %d\n", *r);
      pipe(p2);
      if (fork() == 0) { // Right neighbor after applying filter to left
        // Replace STDOUT with pipe for writing
        close(1);
        dup(p2[1]);
        close(p2[0]);
        close(p2[1]);
       
        // Write to pipe all filtered numbers
        while (1) { 
          if (read(0, r2, sizeof *r2) <= 0) break; 
          if (*r2 % *r > 0) {
            write(1, r2, sizeof *r2);
          }
        }
      } else {
        wait(0);
        // Close off pipe input after creating right neighbor
        close(0);
        dup(p2[0]);
        close(p2[0]);
        close(p2[1]);
      }
    }
  }
  exit(0);
}
