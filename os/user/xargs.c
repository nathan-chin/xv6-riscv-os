#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/param.h"

int
main(int argc, char *argv[])
{
  const int MAXSTR = 64; // Max length of a piped input
  char c[1]; // Buffer for reading chars from STDIN
  char buf[512]; // Buffer for storing strings taken from c
  char *bufPtr = buf; // Used for writing to buffer
  char *args[MAXARG]; // Array of new argument strings
  char **argsPtr = args; // Point to array of strings
  int n = 0; // Number of total arguments with new
  int orig = 0; // Number of original args

  // Copy over current argv to newArgs
  while (argv[n+1]) {
    // Allocate space for string arg
    argsPtr[n] = (char *)malloc(sizeof(char) * (MAXSTR)); 
    strcpy(argsPtr[n], argv[n+1]);
    n++;
    orig++;
  }

  // Read all chars from STDIN into c
  while (read(0, c, 1) > 0) {
    if (*c == '\n') { // End of line
      // Add new arg to array of strings
      *bufPtr = '\0';
      argsPtr[n] = (char *)malloc(sizeof(char) * (MAXSTR)); 
      strcpy(argsPtr[n], buf);
      n++;

      if (fork() == 0) { // Child process execs     
        // Exec with new arguments
        if (exec(argv[1], argsPtr) < 0) {
          printf("%s: exec failed in xargs\n", argv[1]);
        }
      } else {
        wait(0); // Wait for child exec to finish

        // Release all malloc'ed memory for commands on this line of exec
        while (--n >= orig) {
          *argsPtr[n] = '\0';
          free(argsPtr[n]);
        }

        // Reset n to not write over the initial args
        n = orig;
        bufPtr = buf; // Reset bufPtr to reuse buffer
      }
    } else if (*c == ' ') { // End of arg
        // Add new arg to array of strings
        *bufPtr = '\0';
        argsPtr[n] = (char *)malloc(sizeof(char) * (MAXSTR)); 
        strcpy(argsPtr[n], buf);
        n++;
        bufPtr = buf; // Reset bufPtr to reuse buffer
    } else { // Read one character
      *bufPtr = *c;
      bufPtr++;
    }
  }
  // Finally free original args before exiting
  while (--orig >= 0) {
    free(argsPtr[orig]);
  }
  exit(0);
}
