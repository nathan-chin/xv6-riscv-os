#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  // Sleep requires 2 arguments (first is "sleep")
  if (argc <= 1) {
    printf("sleep: must pass in number of ticks to pause\n");
    exit(1);
  }

  // atoi returns 0 if a number string isn't passed in
  int ticks = atoi(argv[1]);

  // Use sleep system call
  sleep(ticks);

  exit(0);
     
}
