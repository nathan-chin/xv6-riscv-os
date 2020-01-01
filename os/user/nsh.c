#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"
#include "kernel/param.h"

// Constants for input classification
#define START 0
#define CHAR 1
#define SPACE 2
#define NEWLINE 3
#define PIPE 4
#define REDIR_I 5
#define REDIR_O 6

int
main(void)
{
  static char buf[80]; // Hold line of input chars
  char *line[MAXARG]; // Hold array of arg strings

  int prev; // Hold identification of previous read char
  int i; // Keep track of position in buf
  int n; // Keep track of number of words made
  int fd; // File redirection fd

  while (1) {
    prev = START;
    i = 0;
    n = 0;
    memset(buf, '\0', sizeof buf);
    memset(line, '\0', sizeof line);
    printf("@ ");
    gets(buf, sizeof buf); // Read in the input line into buf
    buf[strlen(buf) - 1] = '\0'; // Remove the newline character at the end

    //int p[2]; // Hold pipe fds

    // Create array of string arguments
    int file = 0; // Holds index of file name. + if output, - if input
    while (buf[i] != 0) {
      switch (buf[i]) {
        case ' ':
          if (prev == SPACE || prev == NEWLINE) break;
          prev = SPACE;
          buf[i] = '\0';
          break;
        case '\n':
          if (prev == SPACE || prev == NEWLINE) break;
          prev = NEWLINE;
          break;
        case '|':
          prev = PIPE;
          break;
        case '<':
          prev = REDIR_I;
          file = n;
          break;
        case '>':
          prev = REDIR_O;
          file = n;
          break;
        default:
          if (prev == CHAR) break;
          line[n++] = &buf[i];
          prev = CHAR;
      }
      i++;
    }

    // Execute with arguments
    if (fork() == 0) {
      if (file > 0) { // Output redirection
        fd = open(line[file], O_CREATE|O_WRONLY);
        if (fork() == 0) {
          close(1);
          dup(fd);
          for(; file < n; file++) {
            line[file] = '\0';
          }
          exec(line[0], line);
        } else {
          wait(0);
          close(fd); // Close file
        }
      } else if (file < 0) { // Input redirection
        
      } else { // No redirection
        exec(line[0], line);
      }
    } else {
      wait(0);
    }
  }
  exit(0);
}

