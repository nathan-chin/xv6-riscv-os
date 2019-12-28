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
  /*
  int i;

  if(argc < 2){
    printf("find: requires a file name to search for");
  } else if (argc == 2) { // If no starting-point specified, '.' is assumed
    find(".", argv[1]);
  } else {
    for (i = 2; i < argc; i++) {
      find(argv[1], argv[i]);
    }
  }*/
  /*
  int i = 0;
  while(argv[i]) {
    printf("%s,", argv[i]);
    i++;
  }*/

  char c[1];
  char buf[512]; // Used for storing args in buffer
  char *bufPtr = buf; // Used for writing to buffer
  //char newArgs[argc+1][64];
  char **newArgs = (char **)malloc(sizeof(char *) * (MAXARG));
  char *addArg;
  char *strPtr = *newArgs + 1;
  //int numArgs = argc;

  // Copy over current argv to newArgs
  int i = 1;
  while (argv[i]) {
    addArg = (char *)malloc(sizeof(char) * (strlen(argv[i])+1)); 
    //printf("B|argv:%s, addargs:%s\n", argv[i], addArg);
    strcpy(addArg, argv[i]);
    //printf("A|argv:%s, addargs:%s\n", argv[i], addArg);
    strcpy(strPtr, addArg);
    //printf("strptr:%s\n", strPtr);
    strPtr += strlen(addArg) + 1;
    i++;
  }

  // While STDIN has more characters
  while (read(0, c, 1) > 0) {
    if (*c == '\n') { // End of line, add new arg then exec
      //printf("Newline\n");
      if (fork() == 0) { // Child process execs
        // Add new arg to array of strings
        *bufPtr = '\0';
        argc++;
        addArg = (char *)malloc(sizeof(char) * (strlen(buf)+1)); 
        strcpy(addArg, buf);
        //printf("addnewargs:%s\n", addArg);
        strcpy(strPtr, addArg);
        //printf("strptr:%s\n", strPtr);
        strPtr += strlen(addArg) + 1;

        // Test to see contents of newArgs
        /*
        i = 1;
        strPtr = *newArgs + 1;
        while (i < argc) {
          printf("%s,", strPtr);
          strPtr += strlen(strPtr) + 1;
          i++;
        }
        */

        // Exec with new arguments
        printf("Executing\n");
        exec(argv[1], newArgs);
      } else {
        wait(0);
        // Release all malloc'ed memory
        bufPtr = buf;
      }
    } else if (*c == ' ') { // End of arg
        // Add new arg to array of strings
        //printf("Space\n");
        *bufPtr = '\0';
        argc++;
        addArg = (char *)malloc(sizeof(char) * (strlen(buf)+1)); 
        strcpy(addArg, buf);
        //printf("addnewargs:%s\n", addArg);
        strcpy(strPtr, addArg);
        //printf("strptr:%s\n", strPtr);
        strPtr += strlen(addArg) + 1;
        bufPtr = buf;
    } else { // Read one character
      *bufPtr = *c;
      bufPtr++;
    }
  }
  exit(0);
}
