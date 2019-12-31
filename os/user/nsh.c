#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"
#include "kernel/param.h"

int
main(void)
{
  /*
  const int MAXLEN = 80;
  char *line[MAXARG]; // Hold arguments as typed in line
  char **linePtr = line; // Pointer to line buffer
  char c[1]; // Buffer for char read from STDIN
  char buf[MAXLEN]; // Buffer for string args from STDIN
  char *bufPtr = buf; // Pointer to write to buffer
  int n = 0; // Number of args written to buffer
  int spaceBefore = 0; // Flag so that multiple spaces are ignored

  printf("@ ");
  while(read(0, c, sizeof(char)) > 0) {
    if (*c == '\n') {
      if (spaceBefore == 0) {
        *bufPtr = '\0';
        char t[MAXLEN];
        char *q = t;
        strcpy(q, buf);
        //linePtr[n] = (char *)malloc(sizeof(char) * MAXLEN);
        linePtr[n] = q;
        //strcpy(linePtr[n++], buf);
        bufPtr = buf;
      }
      // Exit shell on "exit" command
      if (strcmp(linePtr[0], "exit") == 0) exit(0);

      printf("test %s\n", linePtr[0]);
      if (fork() == 0) {
        if (exec(linePtr[0], line) < 0) {
          printf("%s: exec failed in nsh\n", linePtr[0]);
        }
      } else {
        wait(0);
        n = 0;
      }
      printf("@ ");
    } else if (*c == ' ') {
      if (spaceBefore == 1) continue;
      //printf("Space");
      *bufPtr = '\0';
      char t2[MAXLEN];
      char *q2;
      strcpy(t2, buf);
      *q2 = t2[0];
      //linePtr[n] = (char *)malloc(sizeof(char) * MAXLEN);
      linePtr[n] = q2;
      //strcpy(linePtr[n++], buf);
      bufPtr = buf;
      spaceBefore = 1;
      //printf("line: %s\n", line[n-1]);
    } else if (*c == '|') {

    } else if (*c == '>') {

    } else if (*c == '<') {

    } else {
      spaceBefore = 0;
      *bufPtr = *c;
      bufPtr++;    
    }
  }
  */
  #define START 0
  #define CHAR 1
  #define SPACE 2
  #define NEWLINE 3
  #define PIPE 4
  #define REDIR_I 5
  #define REDIR_O 6

  static char buf[80];
  memset(buf, 0, sizeof buf);
  printf("@ ");
  gets(buf, sizeof buf); // Read in the input line into buf
  buf[strlen(buf) - 1] = '\0'; // Remove the newline character at the end
  //printf("|%s|\n", buf);

  char *line[MAXARG];

  int prev = START;
  int i = 0; // Keep track of position in buf
  int n = 0; // Keep track of number of words made
  //char *word;
  //char *wordPtr = word;
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
        break;
      case '>':
        prev = REDIR_O;
        break;
      default:
        if (prev == CHAR) break;
        line[n++] = &buf[i];
        prev = CHAR;
    }
    i++;
  }
  int g = 0;
  while (line[g]) {
    //printf("test: %s\n", line[g]);
    g++;
  }
  exec(line[0], line);
  exit(0);
}

