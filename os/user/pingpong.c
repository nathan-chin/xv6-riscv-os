#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int p[2]; // Pipe fd: read from 0, write to 1 
  char b[1]; // Byte for sending/receiving between processes

  pipe(p);
  if (fork() == 0) { // Child process
    read(p[0], b, 1);
    printf("%d: received p%cng\n", getpid(), *b);
    write(p[1], "o", 1);
  } else { // Parent process
    write(p[1] , "i", 1);
    wait(0); // Let child execute first
    read(p[0], b, 1);
    printf("%d: received p%cng\n", getpid(), *b);
  }

  // Close pipe so it doesn't hang
  close(p[0]);
  close(p[1]);

  exit(0);   
}
