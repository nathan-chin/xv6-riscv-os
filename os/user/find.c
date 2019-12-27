#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

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
searchDir(char *path, char *buf, int fd, struct stat st, char *search)
{ 
  char *p;
  struct dirent de;
  struct stat st2;

  if(strlen(path) + 1 + DIRSIZ + 1 > 512){
    printf("find: path too long\n");
  }
  strcpy(buf, path);
  p = buf+strlen(buf);
  *p++ = '/';

  // Iterate through directory contents
  while(read(fd, &de, sizeof(de)) == sizeof(de)){
    if(de.inum == 0)
      continue;
    memmove(p, de.name, DIRSIZ);
    p[DIRSIZ] = 0;
    if(stat(buf, &st) < 0){
      printf("find: cannot stat %s\n", buf);
      continue;
    }
    // Only look for files - search through DIRs and ignore CONSOLEs
    if (st.type == T_DIR) {
      if (strcmp(fmtname(buf), ".") != 0 && strcmp(fmtname(buf), "..") != 0) {
        // Get new metadata for directory file
        int fd2 = open(buf, 0);
        // Path must have stats
        if(fstat(fd, &st2) < 0){
          fprintf(2, "find: cannot stat %s\n", path);
          close(fd);
          return;
        }
        // Recursive search in found directory
        searchDir(buf, buf, fd2, st2, search);
        close(fd2);
      }
    } else if (st.type == T_FILE) {
      if (strcmp(fmtname(buf), search) == 0) {
        printf("%s\n", buf);
      }
    }
  }
}

void
find(char *path, char *search)
{
  char buf[512];
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

  if (st.type == T_DIR) {
    searchDir(path, buf, fd, st, search);
  }
  close(fd);
}

int
main(int argc, char *argv[])
{
  int i;

  if(argc < 2){
    printf("find: requires a file name to search for");
  } else if (argc == 2) { // If no starting-point specified, '.' is assumed
    find(".", argv[1]);
  } else {
    for (i = 2; i < argc; i++) {
      find(argv[1], argv[i]);
    }
  }
  exit(0);
}
