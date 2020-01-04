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
#define DONE 7

void
exec2pipe(int *p, char **args, int type, int n)
{
  int fd;
  char buf[80];
  //printf("Executing with type %d\n", type);

  // Execute with arguments
  if (type == REDIR_O) { // Output redirection
    //printf("OUTPUT");
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
    memset(buf, '\0', sizeof buf);
    fd = open(args[--n], O_RDONLY); // Read file so each exec uses a line
    args[n] = '\0'; // Don't include the file name in exec
    pipe(p);
    if (fork() == 0) {
      close(0);
      dup(fd); // Read input from file and not STDIN
      close(1);
      dup(p[1]); // Write output to pipe
      close(p[0]); // No reading from pipe yet
      close(p[1]);
      exec(args[0], args);
      /*
      gets(buf, sizeof buf);
      buf[strlen(buf)-1] = '\0';
      while (buf[0] != '\0') {
        if (fork() == 0) {
          close(1);
          dup(p[1]); // Write to pipe on exec instead of STDOUT
          int k = 0;
          int prev = START;
          // Create array of string args
          while (buf[k++] != 0) {
            if (buf[k-1] == ' ') {
              if (prev == SPACE || prev == NEWLINE) continue;
              prev = SPACE;
              buf[k-1] = '\0';
            } else if (buf[k-1] == '\n') {
              if (prev == SPACE || prev == NEWLINE) continue;
              prev = NEWLINE;
            } else {
              if (prev == CHAR) continue;
              args[n++] = &buf[k-1];
              prev = CHAR;
            }
          }
          exec(args[0], args);
        } else {
          wait(0);
          // Close pipes so no leaking
          close(p[0]);
          //close(p[1]);
          buf[0] = '\0';
          gets(buf, sizeof buf);
          if (strlen(buf) <= 0) break;
          buf[strlen(buf)-1] = '\0';
        }
      }
      exit(0);
      */
    } else {
      wait(0);
      // Close pipes so no leaking
      //close(p[0]);
      close(p[1]);
      close(fd); // Close opened file
    }
  } else { // Pipe
    //printf("Piping hot\n");
    int p2[2];
    //pipe(p);
    pipe(p2);
    if (fork() == 0) {
      close(0);
      dup(p[0]);
      //printf("%d %d | %d %d", p[0], p[1], p2[0], p2[1]);
      close(p[0]); // Close read end so no leaking
      close(1);
      dup(p2[1]); // Write to pipe instead of STDOUT
      close(p[1]);
      close(p2[0]);
      close(p2[1]);
      exec(args[0], args);
    } else {
      wait(0);
      char bug[80];
      //close(p[1]);
      pipe(p);
      if (fork() == 0) {
        close(0);
        dup(p2[0]);
        close(1);
        dup(p[1]);
        close(p[0]);
        close(p[1]);
        close(p2[0]);
        close(p2[1]);
        gets(bug, sizeof bug);
        printf("%s\n", bug);
        exit(0);
      } else {
        wait(0);
        close(p[1]);
        close(p2[0]);
        close(p2[1]);
      }
      //close(p2[1]);
      /*
      memset(buf, '\0', sizeof buf);
      if (fork() == 0) {
        close(0);
        dup(p2[0]); // Read from pipe
        //close(1);
        //dup(p[0]);
        close(p[0]);
        close(p[1]);
        close(p2[0]);
        close(p2[1]);
        gets(buf, sizeof buf);
        if (strlen(buf) <= 0) exit(0); // Exit on no pipe read
        buf[strlen(buf)-1] = '\0';
        while (strlen(buf) > 0) {
          printf("|%s|\n", buf);
          buf[0] = '\0';
          gets(buf, sizeof buf);
          if (strlen(buf) <= 0) break;
          buf[strlen(buf)-1] = '\0';
        }
        exit(0);
      } else {
        wait(0);
        //close(p[0]);
        //close(p[1]);
        //close(p2[1]);
      }*/
      //printf("done exec\n");
    }
  }
}

int
main(void)
{
  char buf[80]; // Hold line of input chars
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
    int flag = START;
    int outInPipe = 0;
    int p[2];
    char execBuf[80];

    //int p[2]; // Hold pipe fds

    // Create array of string arguments
    while (buf[i] != 0) {
      switch (buf[i]) {
        case ' ':
          if (prev == SPACE || prev == NEWLINE) break;
          //printf("SPACE");
          prev = SPACE;
          buf[i] = '\0';
          if (flag == REDIR_O) {
            flag = DONE;
            //printf("OUT\n");
            i++;
            while (buf[i] == ' ' || buf[i] == '\n') i++;
            line[n++] = &buf[i];
            while (buf[i] != 0 && buf[i] != ' ' && buf[i] != '\n') i++;
            buf[i] = '\0';
            prev = SPACE;
            fd = open(line[n-1], O_CREATE|O_WRONLY);
            line[--n] = '\0'; // Don't include the file name in exec
            //memset(p, '\0', sizeof p);
            //printf("Exec with %d args\n", n);
            if (outInPipe == 0) { // Write to file from exec
              exec2pipe(p, line, REDIR_O, n);
            }
            //printf("%d %d\n", p[0], p[1]);
            memset(execBuf, '\0', sizeof execBuf);
            if (fork() == 0) {
              close(0);
              dup(p[0]); // Read from pipe
              close(1);
              dup(fd); // Output to file
              close(p[0]);
              close(p[1]);
              gets(execBuf, sizeof execBuf);
              if (strlen(execBuf) <= 0) exit(0); // Exit on no pipe read
              execBuf[strlen(execBuf)-1] = '\0';
              while (strlen(execBuf) > 0) {
                printf("%s\n", execBuf);
                execBuf[0] = '\0';
                gets(execBuf, sizeof execBuf);
                if (strlen(execBuf) <= 0) break;
                execBuf[strlen(execBuf)-1] = '\0';
              }
              exit(0);
            } else {
              wait(0);
              outInPipe = 0;
              close(fd);
              close(p[0]);
              //close(p[1]);
            }
          } else if (flag == REDIR_I) {
            flag = DONE;
            //printf("IN\n");
            i++;
            while (buf[i] == ' ' || buf[i] == '\n') i++;
            line[n++] = &buf[i];
            while (buf[i] != 0 && buf[i] != ' ' && buf[i] != '\n') i++;
            buf[i] = '\0';
            prev = SPACE;
            memset(p, '\0', sizeof p);
            exec2pipe(p, line, REDIR_I, n);
            outInPipe = 1;
          } else if (flag == PIPE) {
            //printf("outInPipe: %d\n", outInPipe);
            //printf("PIPE OUT\n");
            char *tempNext;
            i++;
            while (buf[i] == ' ' || buf[i] == '\n') i++;
            line[n++] = &buf[i];
            tempNext = &buf[i];
            while (buf[i] != 0 && buf[i] != ' ' && buf[i] != '\n') i++;
            buf[i] = '\0';
            prev = SPACE;
            line[--n] = '\0'; // Don't include the file name in exec
            if (outInPipe == 0) {
              exec2pipe(p, line, REDIR_O, n);
              outInPipe = 1;
            }
            i = 0;
            memset(line, 0, sizeof line);
            line[i++] = tempNext;
          }
          break;
        case '\n':
          if (prev == SPACE || prev == NEWLINE) break;
          prev = NEWLINE;
          break;
        case '|':
          prev = PIPE;
          flag = PIPE;
          break;
        case '<':
          prev = REDIR_I;
          flag = REDIR_I;
          break;
        case '>':
          prev = REDIR_O;
          flag = REDIR_O;
          break;
        default:
          //printf("CHAR");
          if (prev == CHAR) break;
          line[n++] = &buf[i];
          prev = CHAR;
        }
        i++;
      }

    if (prev = CHAR && flag == START) {
      if (fork() == 0) {
        exec(line[0], line);
      } else {
        wait(0);
      }
    } else if (outInPipe == 1) {
      //printf("IN PIPE AT END\n");
      if (flag == PIPE) {
        //int h = 0;
        //while (line[h]) {
        //  printf("end args: %s\n", line[h++]);
        //}
        exec2pipe(p, line, PIPE, n);
      }
      memset(execBuf, '\0', sizeof execBuf);
      if (fork() == 0) {
        close(0);
        dup(p[0]); // Read from pipe
        close(p[0]);
        close(p[1]);
        gets(execBuf, sizeof execBuf);
        //printf("execBuf %s", execBuf);
        if (strlen(execBuf) <= 0) exit(0); // Exit on no pipe read
        execBuf[strlen(execBuf)-1] = '\0';
        while (strlen(execBuf) > 0) {
          printf("%s\n", execBuf);
          execBuf[0] = '\0';
          gets(execBuf, sizeof execBuf);
          if (strlen(execBuf) <= 0) break;
          execBuf[strlen(execBuf)-1] = '\0';
        }
        exit(0);
      } else {
        wait(0);
        close(p[0]);
        //close(p[1]);
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

