#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"
#include "kernel/param.h"

// Constants for input classification
#define START 0
#define CHAR 1
#define SPACE 2
#define NEWLINE 3
#define PIPE 4 // Output stage of pipe
#define PIPE_2 5 // Input stage of pipe
#define REDIR_I 6
#define REDIR_O 7
#define DONE 8

/**
 * Executes code, then writes the output to a pipe for later use
 * Accounts for redirection in output and input, then piping
 * @param *p: an array of at least 2 to hold pipe fds
 * @param **args: an array of string arguments for execution
 * @param type: describes type of execution (redir, pipe)
 * @param n: the number of arguments
 */
void
exec2pipe(int *p, char **args, int type, int n)
{
  // Initialize temp buffer for grabbing from STDIN
  char buf[80];
  memset(buf, '\0', sizeof buf);

  if (type == REDIR_O) { // Output redirection
    pipe(p);
    if (fork() == 0) { // Child executes and outputs to pipe
      // Write to pipe on exec instead of STDOUT
      close(1);
      dup(p[1]);
      // Close pipe ends so no leaks
      close(p[0]);
      close(p[1]);
      exec(args[0], args);
    } else { // Parent will have data to read on pipe
      wait(0);
      // Close write end of the pipe so no leaking, keep read end open bc data
      close(p[1]);
    }
  } else if (type == REDIR_I) { // Input redirection
    int fd = open(args[--n], O_RDONLY); // Read file so each exec uses a line
    args[n] = '\0'; // Don't include the file name in exec
    pipe(p);
    if (fork() == 0) { // Child executes and outputs to pipe
      // Read input from file and not STDIN
      close(0);
      dup(fd);
      // Write output to pipe on exec instead of STDOUT
      close(1);
      dup(p[1]);
      // Close pipe ends so no leaks
      close(p[0]);
      close(p[1]);
      exec(args[0], args);
    } else { // Parent will have data to read on pipe
      wait(0);
      // Close write end of pipe so no leaking, keep read end open bc data
      close(p[1]);
      close(fd); // Close opened file
    }
  } else { // Pipe
    // Open second pipe as a buffer so we can write back to the original pipe
    int p2[2];
    pipe(p2);
    if (fork() == 0) { // Child execs from 1st pipe to exec output to 2ns pipe
      // Read input from 1st pipe and not STDIN
      close(0);
      dup(p[0]);
      // Write output to 2nd pipe and not STDOUT
      close(1);
      dup(p2[1]);
      // Close pipe ends so no leaking
      close(p[0]); 
      close(p[1]);
      close(p2[0]);
      close(p2[1]);
      exec(args[0], args);
    } else { 
      wait(0);
      memset(buf, '\0', sizeof buf); // Reset buf for use again
      // Close previously used pipe ends
      close(p[0]);
      close(p2[1]);
      pipe(p);
      if (fork() == 0) {
        // Read input from 2nd pipe and not STDIN
        close(0);
        dup(p2[0]);
        // Write output to 1st pipe and not STDOUT, so p[0] can be read
        // consistently
        close(1);
        dup(p[1]);
        // Close pipe ends so no leaking
        close(p[0]);
        close(p[1]);
        close(p2[0]);
        close(p2[1]);
        
        // Read each line from 2nd pipe and write to 1st pipe
        gets(buf, sizeof buf);
        if (strlen(buf) <= 0) exit(0); // Exit on no pipe read
        while (strlen(buf) > 0) {
          printf("%s\n", buf);
          buf[0] = '\0';
          gets(buf, sizeof buf);
          if (strlen(buf) <= 0) break;
        }

        exit(0);
      } else {
        wait(0);
        // Close all 2nd pipe ends and write end of 1st pipe so no leaking
        close(p[1]);
        close(p2[0]);
        close(p2[1]);
      }
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
  int fd; // File redirection fd for read/written files
  int flag; // Notifies of special symbols in line parsing
  int outInPipe; // Indicate presence of data in pipe to use as input for exec
  int p[2]; // Holds pipe file descriptors, p[0] consistently kept open for use
  char execBuf[80]; // Second buffer to hold parsed data

  while (1) { // Every loop is a line of STNDIN read in
    // Initialize variables
    prev = START;
    i = 0;
    n = 0;
    flag = START;
    outInPipe = 0;
    memset(buf, '\0', sizeof buf);
    memset(line, '\0', sizeof line);
    memset(p, '\0', sizeof p);
    memset(execBuf, '\0', sizeof execBuf);
    printf("@ "); // Prompt symbol
    gets(buf, sizeof buf); // Read in the input line into buf
    if (buf[0] == '\0') break;
    buf[strlen(buf) - 1] = '\0'; // Remove the newline character at the end

    // Create array of string arguments
    while (buf[i] != 0) {
      switch (buf[i]) {
        case ' ':
          if (prev == SPACE || prev == NEWLINE) break;
          prev = SPACE;
          buf[i] = '\0';
          // After symbols have been flagged, execute into pipe as needed
          if (flag == REDIR_O) {
            flag = DONE; // Reset flag after spotted
            
            // Ignore extra spaces or lines
            i++;
            while (buf[i] == ' ' || buf[i] == '\n') i++;
            line[n++] = &buf[i];
            // Read all of next word found
            while (buf[i] != 0 && buf[i] != ' ' && buf[i] != '\n') i++;
            buf[i] = '\0';
            prev = SPACE;

            fd = open(line[n-1], O_CREATE|O_WRONLY); // Open file for writing
            line[--n] = '\0'; // Don't include the file name in exec
            // Need output should always be in p[0]. Exec2pipe if none in pipe
            if (outInPipe == 0) {
              exec2pipe(p, line, REDIR_O, n);
            }
            memset(execBuf, '\0', sizeof execBuf);
            if (fork() == 0) {
              // Read from pipe instead of STDIN
              close(0);
              dup(p[0]);
              // Write to file instead of STDOUT
              close(1);
              dup(fd);
              // Close pipe ends to prevent leaking
              close(p[0]);
              close(p[1]);

              // Read each line from pipe and write to file
              gets(execBuf, sizeof execBuf);
              if (strlen(execBuf) <= 0) exit(0); // Exit on no pipe read
              while (strlen(execBuf) > 0) {
                printf("%s\n", execBuf);
                execBuf[0] = '\0';
                gets(execBuf, sizeof execBuf);
                if (strlen(execBuf) <= 0) break;
              }
              exit(0);
            } else {
              wait(0);
              // Output in file, no longer in pipe
              outInPipe = 0;
              // Close fds so we don't run out
              close(fd);
              close(p[0]);
              close(p[1]);
            }
          } else if (flag == REDIR_I) {
            flag = DONE; // Reset flag after spotted

            // Ignore extra spaces or lines
            i++;
            while (buf[i] == ' ' || buf[i] == '\n') i++;
            line[n++] = &buf[i];
            // Read all of next word found
            while (buf[i] != 0 && buf[i] != ' ' && buf[i] != '\n') i++;
            buf[i] = '\0';
            prev = SPACE;
            memset(p, '\0', sizeof p);
            // Exec with input from opened file, out to pipe
            exec2pipe(p, line, REDIR_I, n);
            outInPipe = 1;
          } else if (flag == PIPE) {
            char *tempNext; // Point to word after pipe char
            flag = PIPE_2; // Must perform input half of pipe afterwards

            // Ignore extra spaces or lines
            i++;
            while (buf[i] == ' ' || buf[i] == '\n') i++;
            line[n++] = &buf[i];
            tempNext = &buf[i];
            // Read all of next word found
            while (buf[i] != 0 && buf[i] != ' ' && buf[i] != '\n') i++;
            buf[i] = '\0';
            prev = SPACE;
            line[--n] = '\0'; // Don't include the file name in exec
            // Use previous exec data if in pipe, or exec
            if (outInPipe == 0) {
              exec2pipe(p, line, REDIR_O, n);
              outInPipe = 1;
            }
            // Reset input line args
            n = 0;
            memset(line, 0, sizeof line);
            line[n++] = tempNext;
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
          // If output after pipe, need to exec one more time with new cmd
          if (flag == PIPE_2) {
            exec2pipe(p, line, PIPE, n);
          }
          flag = REDIR_O;
          break;
        default:
          if (prev == CHAR) break;
          line[n++] = &buf[i];
          prev = CHAR;
        }
        i++;
      }

    // Handle execution with no special chars
    if (prev == CHAR && flag == START) {
      if (fork() == 0) {
        exec(line[0], line);
      } else {
        wait(0);
      }
    } else if (outInPipe == 1) { // If final output in pipe, out to STDOUT
      // Exec on previous exec output
      if (flag == PIPE_2) {
        exec2pipe(p, line, PIPE, n);
      }
      memset(execBuf, '\0', sizeof execBuf);
      if (fork() == 0) {
        // Read from pipe not from STDIN
        close(0);
        dup(p[0]);
        // Close pipe ends so no leaking
        close(p[0]);
        close(p[1]);

        // Read each line from pipe and write to STDOUT
        gets(execBuf, sizeof execBuf);
        if (strlen(execBuf) <= 0) exit(0); // Exit on no pipe read
        while (strlen(execBuf) > 0) {
          printf("%s\n", execBuf);
          execBuf[0] = '\0';
          gets(execBuf, sizeof execBuf);
          if (strlen(execBuf) <= 0) break;
        }
        exit(0);
      } else {
        wait(0);
        // Close both ends of pipe
        close(p[0]);
        close(p[1]);
      }
    }
  }
  exit(0);
}

