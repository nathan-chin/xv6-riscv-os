# Chapter 1 - Operating System Interfaces

Operating systems
1. Manage and abstract low-level hardware
2. Shares the hardware among multiple running programs so they "run at the same time"
3. Provide controlled ways for programs to interact so they can share data or work together

Operating systems provide services to user programs through an interface, which trades off between simplicity and availability of features to applications.

xv6 takes the traditional form of a _kernel_ (a special program that provides services to running programs). Each running program, or _process_, has memory containing intructions, data, and a stack. Instructions implement program's computation; data are variables on which computation acts; stack organizes program's procedure calls. When a program needs to invoke a kernel service, it invokes a procedure call in the OS interface called a _system call_. The system call performs the service and returns, alternating between _user space_ and _kernel space_.

The _shell_ is an ordinary program that reads user commands and executes them. It is the primary user interface to traditional Unix-like systems.

## 1.1 Processes and Memory
An xv6 process consists of user-space memory (instr, data, stack) and per-process state private to the kernel. Xv6 can _time-share_ processes, or tranparently switch the available CPUs among the set of processes waiting to execute. CPU registers are saved when processes are not running, and processes are identified by a process identifier called a _pid_.

The `fork` system call creates a new process, called the _child process_, with exactly the same memory contents as the calling process, called the _parent process_. The parent fork returns the child's pid, and the child fork returns 0.

The `exit` system call causes the calling process to stop executing and release resources like memory and open files. It takes an integer status argument, with 0 indicating success and 1 indicating failure.

The `wait` system call returns the pid of an exited child of the current process and copies the exit status of the child to the address passed to wait. This blocks until a child has exited, or skips waiting by passing in a 0.

The `exec` system call replaces the process's memory with a new memory image loaded from a file stored in the file system. The file must have a particular format to specify starting instruction and data and etc. xv6 uses the ELF format. A successful exec should not return to the calling program, and instead execute the loaded files. Two arguments are passed in: the name of the file containing the executable and an array of string arguments.

Xv6 allocates most user-space memory implicitly, or as needed by the call. A process that needs  more memory at run-time, perhaps for malloc, can call `sbrk(n)` to grow its data memory by n bytes. The location of the new memory is returned by the call.

All xv6 processes run as root, so there is no protection from user to user.

## 1.2 I/O and File Descriptors
A _file descriptor_ is a small integer representing a kernel-managed object that a process may read from or write to. A process may obtain one by opening a file, directory, or device, or by creating a pipe or duplicating an existing descriptor.

The xv6 kernel uses the file descriptor as an index into a per-process table, so every process has a private space of file descriptors starting at zero. Conventionally, a process reads from fd 0 (standard input), writes output to fd 1 (standard output), and writes error  messages to fd2 (standard error).

The `read` system call reads bytes from open files named by fds. `read(fd, buf, n)` reads at most n bytes from the file descriptor fd, copies them into buf, and returns the number of bytes read. Each file descriptor that refers to a file has an offset with it - read reads data from the current file offset and advances it as it reads.

The `write` system call writes bytes to open files named by fds. `write(fd, buf, n) writes n bytes from buf to the file descriptor fd and returns the number of bytes written. Writes also use and move the file offsets. Fewer bytes are written only in errors.

The `close` system call releases a file descriptor, making it free for reuse by a future call. A newly allocated fd is always the lowest-numbered unused descriptor in the current process.

The `dup` system call duplicates an existing file desciptor, returning a new one that refers to the same underlying I/O object. Both fds share an offset.

File descriptos are a powerful abstraction to hide details of what they're connected to (a file, device like the console, pipe, etc.)

## 1.3 Pipes
A _pipe_ is a small kernel buffer exposed to processes as a pair of file descriptors, one for reading and one for writing. Writing data to one end of the pipe makes data available for reading from the other end. Pipes provide a way for processes to communicate. Because read blocks until it is impossible for new data to arrive, it is important for the child to close the write end of the pipe.

Pipes have at least four advantages over temporary files.
1. Pipes automatically clean themselves up, while file redirection would have to remove files when done
2. Pipes can pass aribitrarily long streams of data, while file redirection requires enough free space on disk to store all data
3. Pipes allow for parallel execution of pipeline stages, while files require sequential execution
4. In inter-process communication, pipes block execution more efficienty with reads/writes

## 1.4 File System
The xv6 file system provides data files, which are uniterrupted byte arrays, and directories, which contain named references to data files and other directoories. Directories form a tree, starting at a special one called _root_.

The `mkdir` system call creates a new directory.

The `open` system call with the O_CREATE flag creates a new data file.

The `mknod` system call creates a new device file.

The `fstat` system call retrieves information about the object a file descriptor refers to.

A file's name is distinct from the file itself, and the file, or _inode_, can have multiple names, or _links_.

The `link` system call creates another file system name referring to the same inode as an existing file.

Each inode is identified by a unique _inode number_. Inspecting the result of fstat can reveal the same inode number.

The `unlink` system call removes a name from a file system. The file's inode and used disk space are freed when the file's link count is 0 and no fds refer to it.

The `cd` system call must be built into the shell not as a user-level program so that the shell's working directory actually changes.

## 1.5 Real World
The Unix system call interface has been standardized through the Portable Operating System Interface (POSIX) standard, but xv6 is **not** POSIX compliant. It misses some system calls (like `lseek`) and doesn't fully implement some others. The purpose of xv6 is to provide simplicity and clarity while providing a simple UNIX-like system calll interface.

For the most part, modern Unix-derived OS's have not followed the model of exposing devices as special files.
