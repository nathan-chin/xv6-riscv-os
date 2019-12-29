#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/param.h"

char*
fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return name, ended with a null character
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), '\0', DIRSIZ-strlen(p));
  return buf;
}

void
find(char *path, char *search)
{
  int fd; // Fd of path passed in
  struct stat st; // Details about path

  // Path must be a directory
  if((fd = open(path, 0)) < 0){
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  // Path must have stats
  if(fstat(fd, &st) < 0){
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  close(fd);
}

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

  // Copy over current argv to newArgs
  while (argv[n+1]) {
    // Allocate space for string arg
    argsPtr[n] = (char *)malloc(sizeof(char) * (MAXSTR)); 
    strcpy(argsPtr[n], argv[n+1]);
    n++;
  }

  // Read all chars from STDIN into c
  while (read(0, c, 1) > 0) {
    if (*c == '\n') { // End of line, add new arg then exec
      if (fork() == 0) { // Child process execs
        // Add new arg to array of strings
        *bufPtr = '\0';
        argsPtr[n] = (char *)malloc(sizeof(char) * (MAXSTR)); 
        strcpy(argsPtr[n], buf);
        n++;
  
        printf("Starting\n");
        int i = 0;
        while (argsPtr[i]) {
          printf("argsPtr: %s\n", argsPtr[i]);
          i++;
        }
        printf("Done\n");

        // Exec with new arguments
        printf("Starting exec\n");
        if (exec(argv[1], argsPtr) < 0) {
          printf("%s: exec failed in xargs\n", argv[1]);
        }
      } else {
        wait(0); // Wait for child exec to finish
        // Release all malloc'ed memory
        while (--n > 0) {
          free(argsPtr[n]);
        }
        // n should be 1 again to not write over the command
        n = 1;
        memset(buf, '\0', sizeof buf);
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
  free(argsPtr[0]); // Finally free 0 before exiting
  exit(0);
}
