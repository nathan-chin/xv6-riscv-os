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

void
exec2pipe(int *p, char **args, int type, int n)
{
  int fd;

  // Execute with arguments
  if (type == REDIR_O) { // Output redirection
    printf("OUTPUT");
    pipe(p);
    if (fork() == 0) {
      close(1);
      dup(p[1]); // Write to pipe on exec instead of STDOUT
      close(p[0]);
      close(p[1]);
      //for(; file < n; file++) {
      //  line[file] = '\0';
      //}
      exec(args[0], args);
    } else {
      wait(0);
      // Close write end of the pipe so no leaking, keep read end open
      close(p[1]);
    }
  } else if (type == REDIR_I) { // Input redirection
    printf("INPUT");
    char buf2[80]; // Hold line of input chars
    memset(buf2, '\0', sizeof buf2);
    fd = open(args[n], O_RDONLY); // Read file so each exec uses a line
    pipe(p);
    if (fork() == 0) {
      close(0);
      dup(fd); // Read input from file and not STDIN
      close(p[0]); // No reading from pipe yet
      gets(buf2, sizeof buf2);
      buf2[strlen(buf2)-1] = '\0';
      while (buf2[0] != '\0') {
        if (fork() == 0) {
          close(1);
          dup(p[1]); // Write to pipe on exec instead of STDOUT
          int k = 0;
          int prev = START;
          // Create array of string args
          while (buf2[k++] != 0) {
            if (buf2[k-1] == ' ') {
              if (prev == SPACE || prev == NEWLINE) continue;
              prev = SPACE;
              buf2[k-1] = '\0';
            } else if (buf2[k-1] == '\n') {
              if (prev == SPACE || prev == NEWLINE) continue;
              prev = NEWLINE;
            } else {
              if (prev == CHAR) continue;
              args[n++] = &buf2[k-1];
              prev = CHAR;
            }
          }
          exec(args[0], args);
        } else {
          wait(0);
          // Close pipes so no leaking
          close(p[0]);
          close(p[1]);
          buf2[0] = '\0';
          gets(buf2, sizeof buf2);
          if (strlen(buf2) <= 0) break;
          buf2[strlen(buf2)-1] = '\0';
        }
      }
    } else {
      wait(0);
      // Close pipes so no leaking
      close(p[0]);
      close(p[1]);
      close(fd); // Close opened file
    }
  } else { // No redirection
    printf("REDIR");
    pipe(p);
    if (fork() == 0) {
      close(p[0]); // Close read end so no leaking
      close(1);
      dup(p[1]); // Write to pipe instead of STDOUT
      exec(args[0], args);
    } else {
      wait(0);
      printf("Done execing\n");
      // Close write end of pipe so no leaking
      close(p[1]);
    }
  }
}

int
main(void)
{
  static char buf[80]; // Hold line of input chars
  char *line[MAXARG]; // Hold array of arg strings

  int prev; // Hold identification of previous read char
  int i; // Keep track of position in buf
  int n; // Keep track of number of words made
  int fd; // File redirection fd
  //int file[2]; // Holds index of file name. + if output, - if input
  int file;
  //int nFile; // Keep track of number of file

  while (1) {
    prev = START;
    i = 0;
    n = 0;
    file = 0;
    memset(buf, '\0', sizeof buf);
    memset(line, '\0', sizeof line);
    //memset(file, 0, sizeof file);
    printf("@ ");
    gets(buf, sizeof buf); // Read in the input line into buf
    if (buf[0] == '\0') break;
    buf[strlen(buf) - 1] = '\0'; // Remove the newline character at the end
    int special = 0;

    //int p[2]; // Hold pipe fds

    // Create array of string arguments
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
          special = 1;
          break;
        case '<':
          prev = REDIR_I;
          special = 1;
          file = -n;
          // Need to read in input file name before exec2pipe
          break;
        case '>':
          prev = REDIR_O;
          special = 1;
          file = n;
          int p[2];
          memset(p, '\0', sizeof p);
          printf("%d %d\n", p[0], p[1]);
          printf("Exec with %d args\n", n);
          exec2pipe(p, line, REDIR_O, n);
          printf("%d %d\n", p[0], p[1]);
          char buf3[80];
          memset(buf3, '\0', sizeof buf3);
          if (fork() == 0) {
            close(0);
            dup(p[0]);
            close(p[0]);
            close(p[1]);
            printf("First read...\n");
            gets(buf3, sizeof buf3);
            buf3[strlen(buf3)-1] = '\0';
            while (strlen(buf3) > 0) {
              printf("pipe read: %s\n", buf3);
              buf3[0] = '\0';
              gets(buf3, sizeof buf3);
              if (strlen(buf3) <= 0) break;
              buf3[strlen(buf3)-1] = '\0';
            }
            exit(0);
          } else {
            wait(0);
            close(p[0]);
            close(p[1]);
            printf("Done with pipe2exec\n");
          }
          break;
        default:
          printf("Char here\n");
          if (prev == CHAR) break;
          line[n++] = &buf[i];
          prev = CHAR;
      }
      i++;
    }

    if (prev <= NEWLINE && special == 0) {
      if (fork() == 0) {
        exec(line[0], line);
      } else {
        wait(0);
      }
    }

    /*
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
        file = -file; // Original args less than file
        char buf2[80]; // Hold line of input chars
        memset(buf2, '\0', sizeof buf2);
        fd = open(line[file], O_RDONLY);
        if (fork() == 0) {
          close(0);
          dup(fd);
          gets(buf2, sizeof buf2);
          buf2[strlen(buf2)-1] = '\0';
          while (buf2[0] != '\0') {
            if (fork() == 0) {
              int k = 0;
              int prev = START;
              // Create array of string args
              while (buf2[k++] != 0) {
                if (buf2[k-1] == ' ') {
                  if (prev == SPACE || prev == NEWLINE) continue;
                  prev = SPACE;
                  buf2[k-1] = '\0';
                } else if (buf2[k-1] == '\n') {
                  if (prev == SPACE || prev == NEWLINE) continue;
                  prev = NEWLINE;
                } else {
                  if (prev == CHAR) continue;
                  line[file++] = &buf2[k-1];
                  prev = CHAR;
                }
              }
              exec(line[0], line);
            } else {
              wait(0);
              buf2[0] = '\0';
              gets(buf2, sizeof buf2);
              if (strlen(buf2) <= 0) break;
              buf2[strlen(buf2)-1] = '\0';
            }
          }
          dup(0);
        } else {
          wait(0);
          close(fd);
        }
      } else { // No redirection
        exec(line[0], line);
      }
    } else {
      wait(0);
    }
    */
  }
  exit(0);
}

