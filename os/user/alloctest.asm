
user/_alloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
#include "kernel/fcntl.h"
#include "kernel/memlayout.h"
#include "user/user.h"

void
test0() {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	0880                	addi	s0,sp,80
  enum { NCHILD = 50, NFD = 10};
  int i, j;
  int fd;

  printf("filetest: start\n");
  12:	00001517          	auipc	a0,0x1
  16:	9de50513          	addi	a0,a0,-1570 # 9f0 <malloc+0xe4>
  1a:	00001097          	auipc	ra,0x1
  1e:	834080e7          	jalr	-1996(ra) # 84e <printf>
  22:	03200493          	li	s1,50
    printf("test setup is wrong\n");
    exit(1);
  }

  for (i = 0; i < NCHILD; i++) {
    int pid = fork();
  26:	00000097          	auipc	ra,0x0
  2a:	4a0080e7          	jalr	1184(ra) # 4c6 <fork>
    if(pid < 0){
  2e:	00054f63          	bltz	a0,4c <test0+0x4c>
      printf("fork failed");
      exit(1);
    }
    if(pid == 0){
  32:	c915                	beqz	a0,66 <test0+0x66>
  for (i = 0; i < NCHILD; i++) {
  34:	34fd                	addiw	s1,s1,-1
  36:	f8e5                	bnez	s1,26 <test0+0x26>
  38:	03200493          	li	s1,50
      sleep(10);
      exit(0);  // no errors; exit with 0.
    }
  }

  int all_ok = 1;
  3c:	4905                	li	s2,1
  for(int i = 0; i < NCHILD; i++){
    int xstatus;
    wait(&xstatus);
    if(xstatus != 0) {
      if(all_ok == 1)
  3e:	4985                	li	s3,1
        printf("filetest: FAILED\n");
  40:	00001a97          	auipc	s5,0x1
  44:	9e0a8a93          	addi	s5,s5,-1568 # a20 <malloc+0x114>
      all_ok = 0;
  48:	4a01                	li	s4,0
  4a:	a0a5                	j	b2 <test0+0xb2>
      printf("fork failed");
  4c:	00001517          	auipc	a0,0x1
  50:	9bc50513          	addi	a0,a0,-1604 # a08 <malloc+0xfc>
  54:	00000097          	auipc	ra,0x0
  58:	7fa080e7          	jalr	2042(ra) # 84e <printf>
      exit(1);
  5c:	4505                	li	a0,1
  5e:	00000097          	auipc	ra,0x0
  62:	470080e7          	jalr	1136(ra) # 4ce <exit>
  66:	44a9                	li	s1,10
        if ((fd = open("README", O_RDONLY)) < 0) {
  68:	00001917          	auipc	s2,0x1
  6c:	9b090913          	addi	s2,s2,-1616 # a18 <malloc+0x10c>
  70:	4581                	li	a1,0
  72:	854a                	mv	a0,s2
  74:	00000097          	auipc	ra,0x0
  78:	49a080e7          	jalr	1178(ra) # 50e <open>
  7c:	00054e63          	bltz	a0,98 <test0+0x98>
      for(j = 0; j < NFD; j++) {
  80:	34fd                	addiw	s1,s1,-1
  82:	f4fd                	bnez	s1,70 <test0+0x70>
      sleep(10);
  84:	4529                	li	a0,10
  86:	00000097          	auipc	ra,0x0
  8a:	4d8080e7          	jalr	1240(ra) # 55e <sleep>
      exit(0);  // no errors; exit with 0.
  8e:	4501                	li	a0,0
  90:	00000097          	auipc	ra,0x0
  94:	43e080e7          	jalr	1086(ra) # 4ce <exit>
          exit(1);
  98:	4505                	li	a0,1
  9a:	00000097          	auipc	ra,0x0
  9e:	434080e7          	jalr	1076(ra) # 4ce <exit>
        printf("filetest: FAILED\n");
  a2:	8556                	mv	a0,s5
  a4:	00000097          	auipc	ra,0x0
  a8:	7aa080e7          	jalr	1962(ra) # 84e <printf>
      all_ok = 0;
  ac:	8952                	mv	s2,s4
  for(int i = 0; i < NCHILD; i++){
  ae:	34fd                	addiw	s1,s1,-1
  b0:	cc89                	beqz	s1,ca <test0+0xca>
    wait(&xstatus);
  b2:	fbc40513          	addi	a0,s0,-68
  b6:	00000097          	auipc	ra,0x0
  ba:	420080e7          	jalr	1056(ra) # 4d6 <wait>
    if(xstatus != 0) {
  be:	fbc42783          	lw	a5,-68(s0)
  c2:	d7f5                	beqz	a5,ae <test0+0xae>
      if(all_ok == 1)
  c4:	ff3915e3          	bne	s2,s3,ae <test0+0xae>
  c8:	bfe9                	j	a2 <test0+0xa2>
    }
  }

  if(all_ok)
  ca:	00091b63          	bnez	s2,e0 <test0+0xe0>
    printf("filetest: OK\n");
}
  ce:	60a6                	ld	ra,72(sp)
  d0:	6406                	ld	s0,64(sp)
  d2:	74e2                	ld	s1,56(sp)
  d4:	7942                	ld	s2,48(sp)
  d6:	79a2                	ld	s3,40(sp)
  d8:	7a02                	ld	s4,32(sp)
  da:	6ae2                	ld	s5,24(sp)
  dc:	6161                	addi	sp,sp,80
  de:	8082                	ret
    printf("filetest: OK\n");
  e0:	00001517          	auipc	a0,0x1
  e4:	95850513          	addi	a0,a0,-1704 # a38 <malloc+0x12c>
  e8:	00000097          	auipc	ra,0x0
  ec:	766080e7          	jalr	1894(ra) # 84e <printf>
}
  f0:	bff9                	j	ce <test0+0xce>

00000000000000f2 <test1>:

// Allocate all free memory and count how it is
void test1()
{
  f2:	7139                	addi	sp,sp,-64
  f4:	fc06                	sd	ra,56(sp)
  f6:	f822                	sd	s0,48(sp)
  f8:	f426                	sd	s1,40(sp)
  fa:	f04a                	sd	s2,32(sp)
  fc:	ec4e                	sd	s3,24(sp)
  fe:	0080                	addi	s0,sp,64
  void *a;
  int tot = 0;
  char buf[1];
  int fds[2];
  
  printf("memtest: start\n");  
 100:	00001517          	auipc	a0,0x1
 104:	94850513          	addi	a0,a0,-1720 # a48 <malloc+0x13c>
 108:	00000097          	auipc	ra,0x0
 10c:	746080e7          	jalr	1862(ra) # 84e <printf>
  if(pipe(fds) != 0){
 110:	fc040513          	addi	a0,s0,-64
 114:	00000097          	auipc	ra,0x0
 118:	3ca080e7          	jalr	970(ra) # 4de <pipe>
 11c:	e525                	bnez	a0,184 <test1+0x92>
 11e:	84aa                	mv	s1,a0
    printf("pipe() failed\n");
    exit(1);
  }
  int pid = fork();
 120:	00000097          	auipc	ra,0x0
 124:	3a6080e7          	jalr	934(ra) # 4c6 <fork>
  if(pid < 0){
 128:	06054b63          	bltz	a0,19e <test1+0xac>
    printf("fork failed");
    exit(1);
  }
  if(pid == 0){
 12c:	e959                	bnez	a0,1c2 <test1+0xd0>
      close(fds[0]);
 12e:	fc042503          	lw	a0,-64(s0)
 132:	00000097          	auipc	ra,0x0
 136:	3c4080e7          	jalr	964(ra) # 4f6 <close>
      while(1) {
        a = sbrk(PGSIZE);
        if (a == (char*)0xffffffffffffffffL)
 13a:	597d                	li	s2,-1
          exit(0);
        *(int *)(a+4) = 1;
 13c:	4485                	li	s1,1
        if (write(fds[1], "x", 1) != 1) {
 13e:	00001997          	auipc	s3,0x1
 142:	92a98993          	addi	s3,s3,-1750 # a68 <malloc+0x15c>
        a = sbrk(PGSIZE);
 146:	6505                	lui	a0,0x1
 148:	00000097          	auipc	ra,0x0
 14c:	40e080e7          	jalr	1038(ra) # 556 <sbrk>
        if (a == (char*)0xffffffffffffffffL)
 150:	07250463          	beq	a0,s2,1b8 <test1+0xc6>
        *(int *)(a+4) = 1;
 154:	c144                	sw	s1,4(a0)
        if (write(fds[1], "x", 1) != 1) {
 156:	8626                	mv	a2,s1
 158:	85ce                	mv	a1,s3
 15a:	fc442503          	lw	a0,-60(s0)
 15e:	00000097          	auipc	ra,0x0
 162:	390080e7          	jalr	912(ra) # 4ee <write>
 166:	fe9500e3          	beq	a0,s1,146 <test1+0x54>
          printf("write failed");
 16a:	00001517          	auipc	a0,0x1
 16e:	90650513          	addi	a0,a0,-1786 # a70 <malloc+0x164>
 172:	00000097          	auipc	ra,0x0
 176:	6dc080e7          	jalr	1756(ra) # 84e <printf>
          exit(1);
 17a:	4505                	li	a0,1
 17c:	00000097          	auipc	ra,0x0
 180:	352080e7          	jalr	850(ra) # 4ce <exit>
    printf("pipe() failed\n");
 184:	00001517          	auipc	a0,0x1
 188:	8d450513          	addi	a0,a0,-1836 # a58 <malloc+0x14c>
 18c:	00000097          	auipc	ra,0x0
 190:	6c2080e7          	jalr	1730(ra) # 84e <printf>
    exit(1);
 194:	4505                	li	a0,1
 196:	00000097          	auipc	ra,0x0
 19a:	338080e7          	jalr	824(ra) # 4ce <exit>
    printf("fork failed");
 19e:	00001517          	auipc	a0,0x1
 1a2:	86a50513          	addi	a0,a0,-1942 # a08 <malloc+0xfc>
 1a6:	00000097          	auipc	ra,0x0
 1aa:	6a8080e7          	jalr	1704(ra) # 84e <printf>
    exit(1);
 1ae:	4505                	li	a0,1
 1b0:	00000097          	auipc	ra,0x0
 1b4:	31e080e7          	jalr	798(ra) # 4ce <exit>
          exit(0);
 1b8:	4501                	li	a0,0
 1ba:	00000097          	auipc	ra,0x0
 1be:	314080e7          	jalr	788(ra) # 4ce <exit>
        }
      }
      exit(0);
  }
  close(fds[1]);
 1c2:	fc442503          	lw	a0,-60(s0)
 1c6:	00000097          	auipc	ra,0x0
 1ca:	330080e7          	jalr	816(ra) # 4f6 <close>
  while(1) {
      if (read(fds[0], buf, 1) != 1) {
 1ce:	4605                	li	a2,1
 1d0:	fc840593          	addi	a1,s0,-56
 1d4:	fc042503          	lw	a0,-64(s0)
 1d8:	00000097          	auipc	ra,0x0
 1dc:	30e080e7          	jalr	782(ra) # 4e6 <read>
 1e0:	4785                	li	a5,1
 1e2:	00f51463          	bne	a0,a5,1ea <test1+0xf8>
        break;
      } else {
        tot += 1;
 1e6:	2485                	addiw	s1,s1,1
      if (read(fds[0], buf, 1) != 1) {
 1e8:	b7dd                	j	1ce <test1+0xdc>
      }
  }
  //int n = (PHYSTOP-KERNBASE)/PGSIZE;
  //printf("allocated %d out of %d pages\n", tot, n);
  if(tot < 31950) {
 1ea:	67a1                	lui	a5,0x8
 1ec:	ccd78793          	addi	a5,a5,-819 # 7ccd <__global_pointer$+0x69d4>
 1f0:	0297ca63          	blt	a5,s1,224 <test1+0x132>
    printf("expected to allocate at least 31950, only got %d\n", tot);
 1f4:	85a6                	mv	a1,s1
 1f6:	00001517          	auipc	a0,0x1
 1fa:	88a50513          	addi	a0,a0,-1910 # a80 <malloc+0x174>
 1fe:	00000097          	auipc	ra,0x0
 202:	650080e7          	jalr	1616(ra) # 84e <printf>
    printf("memtest: FAILED\n");  
 206:	00001517          	auipc	a0,0x1
 20a:	8b250513          	addi	a0,a0,-1870 # ab8 <malloc+0x1ac>
 20e:	00000097          	auipc	ra,0x0
 212:	640080e7          	jalr	1600(ra) # 84e <printf>
  } else {
    printf("memtest: OK\n");  
  }
}
 216:	70e2                	ld	ra,56(sp)
 218:	7442                	ld	s0,48(sp)
 21a:	74a2                	ld	s1,40(sp)
 21c:	7902                	ld	s2,32(sp)
 21e:	69e2                	ld	s3,24(sp)
 220:	6121                	addi	sp,sp,64
 222:	8082                	ret
    printf("memtest: OK\n");  
 224:	00001517          	auipc	a0,0x1
 228:	8ac50513          	addi	a0,a0,-1876 # ad0 <malloc+0x1c4>
 22c:	00000097          	auipc	ra,0x0
 230:	622080e7          	jalr	1570(ra) # 84e <printf>
}
 234:	b7cd                	j	216 <test1+0x124>

0000000000000236 <main>:

int
main(int argc, char *argv[])
{
 236:	1141                	addi	sp,sp,-16
 238:	e406                	sd	ra,8(sp)
 23a:	e022                	sd	s0,0(sp)
 23c:	0800                	addi	s0,sp,16
  test0();
 23e:	00000097          	auipc	ra,0x0
 242:	dc2080e7          	jalr	-574(ra) # 0 <test0>
  test1();
 246:	00000097          	auipc	ra,0x0
 24a:	eac080e7          	jalr	-340(ra) # f2 <test1>
  exit(0);
 24e:	4501                	li	a0,0
 250:	00000097          	auipc	ra,0x0
 254:	27e080e7          	jalr	638(ra) # 4ce <exit>

0000000000000258 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e422                	sd	s0,8(sp)
 25c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 25e:	87aa                	mv	a5,a0
 260:	0585                	addi	a1,a1,1
 262:	0785                	addi	a5,a5,1
 264:	fff5c703          	lbu	a4,-1(a1)
 268:	fee78fa3          	sb	a4,-1(a5)
 26c:	fb75                	bnez	a4,260 <strcpy+0x8>
    ;
  return os;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret

0000000000000274 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 274:	1141                	addi	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 27a:	00054783          	lbu	a5,0(a0)
 27e:	cb91                	beqz	a5,292 <strcmp+0x1e>
 280:	0005c703          	lbu	a4,0(a1)
 284:	00f71763          	bne	a4,a5,292 <strcmp+0x1e>
    p++, q++;
 288:	0505                	addi	a0,a0,1
 28a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 28c:	00054783          	lbu	a5,0(a0)
 290:	fbe5                	bnez	a5,280 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 292:	0005c503          	lbu	a0,0(a1)
}
 296:	40a7853b          	subw	a0,a5,a0
 29a:	6422                	ld	s0,8(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret

00000000000002a0 <strlen>:

uint
strlen(const char *s)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e422                	sd	s0,8(sp)
 2a4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2a6:	00054783          	lbu	a5,0(a0)
 2aa:	cf91                	beqz	a5,2c6 <strlen+0x26>
 2ac:	0505                	addi	a0,a0,1
 2ae:	87aa                	mv	a5,a0
 2b0:	4685                	li	a3,1
 2b2:	9e89                	subw	a3,a3,a0
 2b4:	00f6853b          	addw	a0,a3,a5
 2b8:	0785                	addi	a5,a5,1
 2ba:	fff7c703          	lbu	a4,-1(a5)
 2be:	fb7d                	bnez	a4,2b4 <strlen+0x14>
    ;
  return n;
}
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret
  for(n = 0; s[n]; n++)
 2c6:	4501                	li	a0,0
 2c8:	bfe5                	j	2c0 <strlen+0x20>

00000000000002ca <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e422                	sd	s0,8(sp)
 2ce:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2d0:	ce09                	beqz	a2,2ea <memset+0x20>
 2d2:	87aa                	mv	a5,a0
 2d4:	fff6071b          	addiw	a4,a2,-1
 2d8:	1702                	slli	a4,a4,0x20
 2da:	9301                	srli	a4,a4,0x20
 2dc:	0705                	addi	a4,a4,1
 2de:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2e0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2e4:	0785                	addi	a5,a5,1
 2e6:	fee79de3          	bne	a5,a4,2e0 <memset+0x16>
  }
  return dst;
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret

00000000000002f0 <strchr>:

char*
strchr(const char *s, char c)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2f6:	00054783          	lbu	a5,0(a0)
 2fa:	cb99                	beqz	a5,310 <strchr+0x20>
    if(*s == c)
 2fc:	00f58763          	beq	a1,a5,30a <strchr+0x1a>
  for(; *s; s++)
 300:	0505                	addi	a0,a0,1
 302:	00054783          	lbu	a5,0(a0)
 306:	fbfd                	bnez	a5,2fc <strchr+0xc>
      return (char*)s;
  return 0;
 308:	4501                	li	a0,0
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
  return 0;
 310:	4501                	li	a0,0
 312:	bfe5                	j	30a <strchr+0x1a>

0000000000000314 <gets>:

char*
gets(char *buf, int max)
{
 314:	711d                	addi	sp,sp,-96
 316:	ec86                	sd	ra,88(sp)
 318:	e8a2                	sd	s0,80(sp)
 31a:	e4a6                	sd	s1,72(sp)
 31c:	e0ca                	sd	s2,64(sp)
 31e:	fc4e                	sd	s3,56(sp)
 320:	f852                	sd	s4,48(sp)
 322:	f456                	sd	s5,40(sp)
 324:	f05a                	sd	s6,32(sp)
 326:	ec5e                	sd	s7,24(sp)
 328:	1080                	addi	s0,sp,96
 32a:	8baa                	mv	s7,a0
 32c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32e:	892a                	mv	s2,a0
 330:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 332:	4aa9                	li	s5,10
 334:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 336:	89a6                	mv	s3,s1
 338:	2485                	addiw	s1,s1,1
 33a:	0344d863          	bge	s1,s4,36a <gets+0x56>
    cc = read(0, &c, 1);
 33e:	4605                	li	a2,1
 340:	faf40593          	addi	a1,s0,-81
 344:	4501                	li	a0,0
 346:	00000097          	auipc	ra,0x0
 34a:	1a0080e7          	jalr	416(ra) # 4e6 <read>
    if(cc < 1)
 34e:	00a05e63          	blez	a0,36a <gets+0x56>
    buf[i++] = c;
 352:	faf44783          	lbu	a5,-81(s0)
 356:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 35a:	01578763          	beq	a5,s5,368 <gets+0x54>
 35e:	0905                	addi	s2,s2,1
 360:	fd679be3          	bne	a5,s6,336 <gets+0x22>
  for(i=0; i+1 < max; ){
 364:	89a6                	mv	s3,s1
 366:	a011                	j	36a <gets+0x56>
 368:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 36a:	99de                	add	s3,s3,s7
 36c:	00098023          	sb	zero,0(s3)
  return buf;
}
 370:	855e                	mv	a0,s7
 372:	60e6                	ld	ra,88(sp)
 374:	6446                	ld	s0,80(sp)
 376:	64a6                	ld	s1,72(sp)
 378:	6906                	ld	s2,64(sp)
 37a:	79e2                	ld	s3,56(sp)
 37c:	7a42                	ld	s4,48(sp)
 37e:	7aa2                	ld	s5,40(sp)
 380:	7b02                	ld	s6,32(sp)
 382:	6be2                	ld	s7,24(sp)
 384:	6125                	addi	sp,sp,96
 386:	8082                	ret

0000000000000388 <stat>:

int
stat(const char *n, struct stat *st)
{
 388:	1101                	addi	sp,sp,-32
 38a:	ec06                	sd	ra,24(sp)
 38c:	e822                	sd	s0,16(sp)
 38e:	e426                	sd	s1,8(sp)
 390:	e04a                	sd	s2,0(sp)
 392:	1000                	addi	s0,sp,32
 394:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 396:	4581                	li	a1,0
 398:	00000097          	auipc	ra,0x0
 39c:	176080e7          	jalr	374(ra) # 50e <open>
  if(fd < 0)
 3a0:	02054563          	bltz	a0,3ca <stat+0x42>
 3a4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3a6:	85ca                	mv	a1,s2
 3a8:	00000097          	auipc	ra,0x0
 3ac:	17e080e7          	jalr	382(ra) # 526 <fstat>
 3b0:	892a                	mv	s2,a0
  close(fd);
 3b2:	8526                	mv	a0,s1
 3b4:	00000097          	auipc	ra,0x0
 3b8:	142080e7          	jalr	322(ra) # 4f6 <close>
  return r;
}
 3bc:	854a                	mv	a0,s2
 3be:	60e2                	ld	ra,24(sp)
 3c0:	6442                	ld	s0,16(sp)
 3c2:	64a2                	ld	s1,8(sp)
 3c4:	6902                	ld	s2,0(sp)
 3c6:	6105                	addi	sp,sp,32
 3c8:	8082                	ret
    return -1;
 3ca:	597d                	li	s2,-1
 3cc:	bfc5                	j	3bc <stat+0x34>

00000000000003ce <atoi>:

int
atoi(const char *s)
{
 3ce:	1141                	addi	sp,sp,-16
 3d0:	e422                	sd	s0,8(sp)
 3d2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3d4:	00054603          	lbu	a2,0(a0)
 3d8:	fd06079b          	addiw	a5,a2,-48
 3dc:	0ff7f793          	andi	a5,a5,255
 3e0:	4725                	li	a4,9
 3e2:	02f76963          	bltu	a4,a5,414 <atoi+0x46>
 3e6:	86aa                	mv	a3,a0
  n = 0;
 3e8:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3ea:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3ec:	0685                	addi	a3,a3,1
 3ee:	0025179b          	slliw	a5,a0,0x2
 3f2:	9fa9                	addw	a5,a5,a0
 3f4:	0017979b          	slliw	a5,a5,0x1
 3f8:	9fb1                	addw	a5,a5,a2
 3fa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3fe:	0006c603          	lbu	a2,0(a3)
 402:	fd06071b          	addiw	a4,a2,-48
 406:	0ff77713          	andi	a4,a4,255
 40a:	fee5f1e3          	bgeu	a1,a4,3ec <atoi+0x1e>
  return n;
}
 40e:	6422                	ld	s0,8(sp)
 410:	0141                	addi	sp,sp,16
 412:	8082                	ret
  n = 0;
 414:	4501                	li	a0,0
 416:	bfe5                	j	40e <atoi+0x40>

0000000000000418 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 418:	1141                	addi	sp,sp,-16
 41a:	e422                	sd	s0,8(sp)
 41c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 41e:	02b57663          	bgeu	a0,a1,44a <memmove+0x32>
    while(n-- > 0)
 422:	02c05163          	blez	a2,444 <memmove+0x2c>
 426:	fff6079b          	addiw	a5,a2,-1
 42a:	1782                	slli	a5,a5,0x20
 42c:	9381                	srli	a5,a5,0x20
 42e:	0785                	addi	a5,a5,1
 430:	97aa                	add	a5,a5,a0
  dst = vdst;
 432:	872a                	mv	a4,a0
      *dst++ = *src++;
 434:	0585                	addi	a1,a1,1
 436:	0705                	addi	a4,a4,1
 438:	fff5c683          	lbu	a3,-1(a1)
 43c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 440:	fee79ae3          	bne	a5,a4,434 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 444:	6422                	ld	s0,8(sp)
 446:	0141                	addi	sp,sp,16
 448:	8082                	ret
    dst += n;
 44a:	00c50733          	add	a4,a0,a2
    src += n;
 44e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 450:	fec05ae3          	blez	a2,444 <memmove+0x2c>
 454:	fff6079b          	addiw	a5,a2,-1
 458:	1782                	slli	a5,a5,0x20
 45a:	9381                	srli	a5,a5,0x20
 45c:	fff7c793          	not	a5,a5
 460:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 462:	15fd                	addi	a1,a1,-1
 464:	177d                	addi	a4,a4,-1
 466:	0005c683          	lbu	a3,0(a1)
 46a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 46e:	fee79ae3          	bne	a5,a4,462 <memmove+0x4a>
 472:	bfc9                	j	444 <memmove+0x2c>

0000000000000474 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 474:	1141                	addi	sp,sp,-16
 476:	e422                	sd	s0,8(sp)
 478:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 47a:	ca05                	beqz	a2,4aa <memcmp+0x36>
 47c:	fff6069b          	addiw	a3,a2,-1
 480:	1682                	slli	a3,a3,0x20
 482:	9281                	srli	a3,a3,0x20
 484:	0685                	addi	a3,a3,1
 486:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 488:	00054783          	lbu	a5,0(a0)
 48c:	0005c703          	lbu	a4,0(a1)
 490:	00e79863          	bne	a5,a4,4a0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 494:	0505                	addi	a0,a0,1
    p2++;
 496:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 498:	fed518e3          	bne	a0,a3,488 <memcmp+0x14>
  }
  return 0;
 49c:	4501                	li	a0,0
 49e:	a019                	j	4a4 <memcmp+0x30>
      return *p1 - *p2;
 4a0:	40e7853b          	subw	a0,a5,a4
}
 4a4:	6422                	ld	s0,8(sp)
 4a6:	0141                	addi	sp,sp,16
 4a8:	8082                	ret
  return 0;
 4aa:	4501                	li	a0,0
 4ac:	bfe5                	j	4a4 <memcmp+0x30>

00000000000004ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ae:	1141                	addi	sp,sp,-16
 4b0:	e406                	sd	ra,8(sp)
 4b2:	e022                	sd	s0,0(sp)
 4b4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4b6:	00000097          	auipc	ra,0x0
 4ba:	f62080e7          	jalr	-158(ra) # 418 <memmove>
}
 4be:	60a2                	ld	ra,8(sp)
 4c0:	6402                	ld	s0,0(sp)
 4c2:	0141                	addi	sp,sp,16
 4c4:	8082                	ret

00000000000004c6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4c6:	4885                	li	a7,1
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <exit>:
.global exit
exit:
 li a7, SYS_exit
 4ce:	4889                	li	a7,2
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4d6:	488d                	li	a7,3
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4de:	4891                	li	a7,4
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <read>:
.global read
read:
 li a7, SYS_read
 4e6:	4895                	li	a7,5
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <write>:
.global write
write:
 li a7, SYS_write
 4ee:	48c1                	li	a7,16
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <close>:
.global close
close:
 li a7, SYS_close
 4f6:	48d5                	li	a7,21
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <kill>:
.global kill
kill:
 li a7, SYS_kill
 4fe:	4899                	li	a7,6
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <exec>:
.global exec
exec:
 li a7, SYS_exec
 506:	489d                	li	a7,7
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <open>:
.global open
open:
 li a7, SYS_open
 50e:	48bd                	li	a7,15
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 516:	48c5                	li	a7,17
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 51e:	48c9                	li	a7,18
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 526:	48a1                	li	a7,8
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <link>:
.global link
link:
 li a7, SYS_link
 52e:	48cd                	li	a7,19
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 536:	48d1                	li	a7,20
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 53e:	48a5                	li	a7,9
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <dup>:
.global dup
dup:
 li a7, SYS_dup
 546:	48a9                	li	a7,10
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 54e:	48ad                	li	a7,11
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 556:	48b1                	li	a7,12
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 55e:	48b5                	li	a7,13
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 566:	48b9                	li	a7,14
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 56e:	48d9                	li	a7,22
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 576:	1101                	addi	sp,sp,-32
 578:	ec06                	sd	ra,24(sp)
 57a:	e822                	sd	s0,16(sp)
 57c:	1000                	addi	s0,sp,32
 57e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 582:	4605                	li	a2,1
 584:	fef40593          	addi	a1,s0,-17
 588:	00000097          	auipc	ra,0x0
 58c:	f66080e7          	jalr	-154(ra) # 4ee <write>
}
 590:	60e2                	ld	ra,24(sp)
 592:	6442                	ld	s0,16(sp)
 594:	6105                	addi	sp,sp,32
 596:	8082                	ret

0000000000000598 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 598:	7139                	addi	sp,sp,-64
 59a:	fc06                	sd	ra,56(sp)
 59c:	f822                	sd	s0,48(sp)
 59e:	f426                	sd	s1,40(sp)
 5a0:	f04a                	sd	s2,32(sp)
 5a2:	ec4e                	sd	s3,24(sp)
 5a4:	0080                	addi	s0,sp,64
 5a6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5a8:	c299                	beqz	a3,5ae <printint+0x16>
 5aa:	0805c863          	bltz	a1,63a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5ae:	2581                	sext.w	a1,a1
  neg = 0;
 5b0:	4881                	li	a7,0
 5b2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5b6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5b8:	2601                	sext.w	a2,a2
 5ba:	00000517          	auipc	a0,0x0
 5be:	52e50513          	addi	a0,a0,1326 # ae8 <digits>
 5c2:	883a                	mv	a6,a4
 5c4:	2705                	addiw	a4,a4,1
 5c6:	02c5f7bb          	remuw	a5,a1,a2
 5ca:	1782                	slli	a5,a5,0x20
 5cc:	9381                	srli	a5,a5,0x20
 5ce:	97aa                	add	a5,a5,a0
 5d0:	0007c783          	lbu	a5,0(a5)
 5d4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5d8:	0005879b          	sext.w	a5,a1
 5dc:	02c5d5bb          	divuw	a1,a1,a2
 5e0:	0685                	addi	a3,a3,1
 5e2:	fec7f0e3          	bgeu	a5,a2,5c2 <printint+0x2a>
  if(neg)
 5e6:	00088b63          	beqz	a7,5fc <printint+0x64>
    buf[i++] = '-';
 5ea:	fd040793          	addi	a5,s0,-48
 5ee:	973e                	add	a4,a4,a5
 5f0:	02d00793          	li	a5,45
 5f4:	fef70823          	sb	a5,-16(a4)
 5f8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5fc:	02e05863          	blez	a4,62c <printint+0x94>
 600:	fc040793          	addi	a5,s0,-64
 604:	00e78933          	add	s2,a5,a4
 608:	fff78993          	addi	s3,a5,-1
 60c:	99ba                	add	s3,s3,a4
 60e:	377d                	addiw	a4,a4,-1
 610:	1702                	slli	a4,a4,0x20
 612:	9301                	srli	a4,a4,0x20
 614:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 618:	fff94583          	lbu	a1,-1(s2)
 61c:	8526                	mv	a0,s1
 61e:	00000097          	auipc	ra,0x0
 622:	f58080e7          	jalr	-168(ra) # 576 <putc>
  while(--i >= 0)
 626:	197d                	addi	s2,s2,-1
 628:	ff3918e3          	bne	s2,s3,618 <printint+0x80>
}
 62c:	70e2                	ld	ra,56(sp)
 62e:	7442                	ld	s0,48(sp)
 630:	74a2                	ld	s1,40(sp)
 632:	7902                	ld	s2,32(sp)
 634:	69e2                	ld	s3,24(sp)
 636:	6121                	addi	sp,sp,64
 638:	8082                	ret
    x = -xx;
 63a:	40b005bb          	negw	a1,a1
    neg = 1;
 63e:	4885                	li	a7,1
    x = -xx;
 640:	bf8d                	j	5b2 <printint+0x1a>

0000000000000642 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 642:	7119                	addi	sp,sp,-128
 644:	fc86                	sd	ra,120(sp)
 646:	f8a2                	sd	s0,112(sp)
 648:	f4a6                	sd	s1,104(sp)
 64a:	f0ca                	sd	s2,96(sp)
 64c:	ecce                	sd	s3,88(sp)
 64e:	e8d2                	sd	s4,80(sp)
 650:	e4d6                	sd	s5,72(sp)
 652:	e0da                	sd	s6,64(sp)
 654:	fc5e                	sd	s7,56(sp)
 656:	f862                	sd	s8,48(sp)
 658:	f466                	sd	s9,40(sp)
 65a:	f06a                	sd	s10,32(sp)
 65c:	ec6e                	sd	s11,24(sp)
 65e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 660:	0005c903          	lbu	s2,0(a1)
 664:	18090f63          	beqz	s2,802 <vprintf+0x1c0>
 668:	8aaa                	mv	s5,a0
 66a:	8b32                	mv	s6,a2
 66c:	00158493          	addi	s1,a1,1
  state = 0;
 670:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 672:	02500a13          	li	s4,37
      if(c == 'd'){
 676:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 67a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 67e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 682:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 686:	00000b97          	auipc	s7,0x0
 68a:	462b8b93          	addi	s7,s7,1122 # ae8 <digits>
 68e:	a839                	j	6ac <vprintf+0x6a>
        putc(fd, c);
 690:	85ca                	mv	a1,s2
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	ee2080e7          	jalr	-286(ra) # 576 <putc>
 69c:	a019                	j	6a2 <vprintf+0x60>
    } else if(state == '%'){
 69e:	01498f63          	beq	s3,s4,6bc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6a2:	0485                	addi	s1,s1,1
 6a4:	fff4c903          	lbu	s2,-1(s1)
 6a8:	14090d63          	beqz	s2,802 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6ac:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6b0:	fe0997e3          	bnez	s3,69e <vprintf+0x5c>
      if(c == '%'){
 6b4:	fd479ee3          	bne	a5,s4,690 <vprintf+0x4e>
        state = '%';
 6b8:	89be                	mv	s3,a5
 6ba:	b7e5                	j	6a2 <vprintf+0x60>
      if(c == 'd'){
 6bc:	05878063          	beq	a5,s8,6fc <vprintf+0xba>
      } else if(c == 'l') {
 6c0:	05978c63          	beq	a5,s9,718 <vprintf+0xd6>
      } else if(c == 'x') {
 6c4:	07a78863          	beq	a5,s10,734 <vprintf+0xf2>
      } else if(c == 'p') {
 6c8:	09b78463          	beq	a5,s11,750 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6cc:	07300713          	li	a4,115
 6d0:	0ce78663          	beq	a5,a4,79c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6d4:	06300713          	li	a4,99
 6d8:	0ee78e63          	beq	a5,a4,7d4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6dc:	11478863          	beq	a5,s4,7ec <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6e0:	85d2                	mv	a1,s4
 6e2:	8556                	mv	a0,s5
 6e4:	00000097          	auipc	ra,0x0
 6e8:	e92080e7          	jalr	-366(ra) # 576 <putc>
        putc(fd, c);
 6ec:	85ca                	mv	a1,s2
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	e86080e7          	jalr	-378(ra) # 576 <putc>
      }
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	b765                	j	6a2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6fc:	008b0913          	addi	s2,s6,8
 700:	4685                	li	a3,1
 702:	4629                	li	a2,10
 704:	000b2583          	lw	a1,0(s6)
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	e8e080e7          	jalr	-370(ra) # 598 <printint>
 712:	8b4a                	mv	s6,s2
      state = 0;
 714:	4981                	li	s3,0
 716:	b771                	j	6a2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 718:	008b0913          	addi	s2,s6,8
 71c:	4681                	li	a3,0
 71e:	4629                	li	a2,10
 720:	000b2583          	lw	a1,0(s6)
 724:	8556                	mv	a0,s5
 726:	00000097          	auipc	ra,0x0
 72a:	e72080e7          	jalr	-398(ra) # 598 <printint>
 72e:	8b4a                	mv	s6,s2
      state = 0;
 730:	4981                	li	s3,0
 732:	bf85                	j	6a2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 734:	008b0913          	addi	s2,s6,8
 738:	4681                	li	a3,0
 73a:	4641                	li	a2,16
 73c:	000b2583          	lw	a1,0(s6)
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	e56080e7          	jalr	-426(ra) # 598 <printint>
 74a:	8b4a                	mv	s6,s2
      state = 0;
 74c:	4981                	li	s3,0
 74e:	bf91                	j	6a2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 750:	008b0793          	addi	a5,s6,8
 754:	f8f43423          	sd	a5,-120(s0)
 758:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 75c:	03000593          	li	a1,48
 760:	8556                	mv	a0,s5
 762:	00000097          	auipc	ra,0x0
 766:	e14080e7          	jalr	-492(ra) # 576 <putc>
  putc(fd, 'x');
 76a:	85ea                	mv	a1,s10
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	e08080e7          	jalr	-504(ra) # 576 <putc>
 776:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 778:	03c9d793          	srli	a5,s3,0x3c
 77c:	97de                	add	a5,a5,s7
 77e:	0007c583          	lbu	a1,0(a5)
 782:	8556                	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	df2080e7          	jalr	-526(ra) # 576 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 78c:	0992                	slli	s3,s3,0x4
 78e:	397d                	addiw	s2,s2,-1
 790:	fe0914e3          	bnez	s2,778 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 794:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 798:	4981                	li	s3,0
 79a:	b721                	j	6a2 <vprintf+0x60>
        s = va_arg(ap, char*);
 79c:	008b0993          	addi	s3,s6,8
 7a0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7a4:	02090163          	beqz	s2,7c6 <vprintf+0x184>
        while(*s != 0){
 7a8:	00094583          	lbu	a1,0(s2)
 7ac:	c9a1                	beqz	a1,7fc <vprintf+0x1ba>
          putc(fd, *s);
 7ae:	8556                	mv	a0,s5
 7b0:	00000097          	auipc	ra,0x0
 7b4:	dc6080e7          	jalr	-570(ra) # 576 <putc>
          s++;
 7b8:	0905                	addi	s2,s2,1
        while(*s != 0){
 7ba:	00094583          	lbu	a1,0(s2)
 7be:	f9e5                	bnez	a1,7ae <vprintf+0x16c>
        s = va_arg(ap, char*);
 7c0:	8b4e                	mv	s6,s3
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	bdf9                	j	6a2 <vprintf+0x60>
          s = "(null)";
 7c6:	00000917          	auipc	s2,0x0
 7ca:	31a90913          	addi	s2,s2,794 # ae0 <malloc+0x1d4>
        while(*s != 0){
 7ce:	02800593          	li	a1,40
 7d2:	bff1                	j	7ae <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7d4:	008b0913          	addi	s2,s6,8
 7d8:	000b4583          	lbu	a1,0(s6)
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	d98080e7          	jalr	-616(ra) # 576 <putc>
 7e6:	8b4a                	mv	s6,s2
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	bd65                	j	6a2 <vprintf+0x60>
        putc(fd, c);
 7ec:	85d2                	mv	a1,s4
 7ee:	8556                	mv	a0,s5
 7f0:	00000097          	auipc	ra,0x0
 7f4:	d86080e7          	jalr	-634(ra) # 576 <putc>
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	b565                	j	6a2 <vprintf+0x60>
        s = va_arg(ap, char*);
 7fc:	8b4e                	mv	s6,s3
      state = 0;
 7fe:	4981                	li	s3,0
 800:	b54d                	j	6a2 <vprintf+0x60>
    }
  }
}
 802:	70e6                	ld	ra,120(sp)
 804:	7446                	ld	s0,112(sp)
 806:	74a6                	ld	s1,104(sp)
 808:	7906                	ld	s2,96(sp)
 80a:	69e6                	ld	s3,88(sp)
 80c:	6a46                	ld	s4,80(sp)
 80e:	6aa6                	ld	s5,72(sp)
 810:	6b06                	ld	s6,64(sp)
 812:	7be2                	ld	s7,56(sp)
 814:	7c42                	ld	s8,48(sp)
 816:	7ca2                	ld	s9,40(sp)
 818:	7d02                	ld	s10,32(sp)
 81a:	6de2                	ld	s11,24(sp)
 81c:	6109                	addi	sp,sp,128
 81e:	8082                	ret

0000000000000820 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 820:	715d                	addi	sp,sp,-80
 822:	ec06                	sd	ra,24(sp)
 824:	e822                	sd	s0,16(sp)
 826:	1000                	addi	s0,sp,32
 828:	e010                	sd	a2,0(s0)
 82a:	e414                	sd	a3,8(s0)
 82c:	e818                	sd	a4,16(s0)
 82e:	ec1c                	sd	a5,24(s0)
 830:	03043023          	sd	a6,32(s0)
 834:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 838:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 83c:	8622                	mv	a2,s0
 83e:	00000097          	auipc	ra,0x0
 842:	e04080e7          	jalr	-508(ra) # 642 <vprintf>
}
 846:	60e2                	ld	ra,24(sp)
 848:	6442                	ld	s0,16(sp)
 84a:	6161                	addi	sp,sp,80
 84c:	8082                	ret

000000000000084e <printf>:

void
printf(const char *fmt, ...)
{
 84e:	711d                	addi	sp,sp,-96
 850:	ec06                	sd	ra,24(sp)
 852:	e822                	sd	s0,16(sp)
 854:	1000                	addi	s0,sp,32
 856:	e40c                	sd	a1,8(s0)
 858:	e810                	sd	a2,16(s0)
 85a:	ec14                	sd	a3,24(s0)
 85c:	f018                	sd	a4,32(s0)
 85e:	f41c                	sd	a5,40(s0)
 860:	03043823          	sd	a6,48(s0)
 864:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 868:	00840613          	addi	a2,s0,8
 86c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 870:	85aa                	mv	a1,a0
 872:	4505                	li	a0,1
 874:	00000097          	auipc	ra,0x0
 878:	dce080e7          	jalr	-562(ra) # 642 <vprintf>
}
 87c:	60e2                	ld	ra,24(sp)
 87e:	6442                	ld	s0,16(sp)
 880:	6125                	addi	sp,sp,96
 882:	8082                	ret

0000000000000884 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 884:	1141                	addi	sp,sp,-16
 886:	e422                	sd	s0,8(sp)
 888:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 88a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88e:	00000797          	auipc	a5,0x0
 892:	2727b783          	ld	a5,626(a5) # b00 <freep>
 896:	a805                	j	8c6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 898:	4618                	lw	a4,8(a2)
 89a:	9db9                	addw	a1,a1,a4
 89c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a0:	6398                	ld	a4,0(a5)
 8a2:	6318                	ld	a4,0(a4)
 8a4:	fee53823          	sd	a4,-16(a0)
 8a8:	a091                	j	8ec <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8aa:	ff852703          	lw	a4,-8(a0)
 8ae:	9e39                	addw	a2,a2,a4
 8b0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8b2:	ff053703          	ld	a4,-16(a0)
 8b6:	e398                	sd	a4,0(a5)
 8b8:	a099                	j	8fe <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ba:	6398                	ld	a4,0(a5)
 8bc:	00e7e463          	bltu	a5,a4,8c4 <free+0x40>
 8c0:	00e6ea63          	bltu	a3,a4,8d4 <free+0x50>
{
 8c4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c6:	fed7fae3          	bgeu	a5,a3,8ba <free+0x36>
 8ca:	6398                	ld	a4,0(a5)
 8cc:	00e6e463          	bltu	a3,a4,8d4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d0:	fee7eae3          	bltu	a5,a4,8c4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8d4:	ff852583          	lw	a1,-8(a0)
 8d8:	6390                	ld	a2,0(a5)
 8da:	02059713          	slli	a4,a1,0x20
 8de:	9301                	srli	a4,a4,0x20
 8e0:	0712                	slli	a4,a4,0x4
 8e2:	9736                	add	a4,a4,a3
 8e4:	fae60ae3          	beq	a2,a4,898 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8e8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ec:	4790                	lw	a2,8(a5)
 8ee:	02061713          	slli	a4,a2,0x20
 8f2:	9301                	srli	a4,a4,0x20
 8f4:	0712                	slli	a4,a4,0x4
 8f6:	973e                	add	a4,a4,a5
 8f8:	fae689e3          	beq	a3,a4,8aa <free+0x26>
  } else
    p->s.ptr = bp;
 8fc:	e394                	sd	a3,0(a5)
  freep = p;
 8fe:	00000717          	auipc	a4,0x0
 902:	20f73123          	sd	a5,514(a4) # b00 <freep>
}
 906:	6422                	ld	s0,8(sp)
 908:	0141                	addi	sp,sp,16
 90a:	8082                	ret

000000000000090c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 90c:	7139                	addi	sp,sp,-64
 90e:	fc06                	sd	ra,56(sp)
 910:	f822                	sd	s0,48(sp)
 912:	f426                	sd	s1,40(sp)
 914:	f04a                	sd	s2,32(sp)
 916:	ec4e                	sd	s3,24(sp)
 918:	e852                	sd	s4,16(sp)
 91a:	e456                	sd	s5,8(sp)
 91c:	e05a                	sd	s6,0(sp)
 91e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 920:	02051493          	slli	s1,a0,0x20
 924:	9081                	srli	s1,s1,0x20
 926:	04bd                	addi	s1,s1,15
 928:	8091                	srli	s1,s1,0x4
 92a:	0014899b          	addiw	s3,s1,1
 92e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 930:	00000517          	auipc	a0,0x0
 934:	1d053503          	ld	a0,464(a0) # b00 <freep>
 938:	c515                	beqz	a0,964 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93c:	4798                	lw	a4,8(a5)
 93e:	02977f63          	bgeu	a4,s1,97c <malloc+0x70>
 942:	8a4e                	mv	s4,s3
 944:	0009871b          	sext.w	a4,s3
 948:	6685                	lui	a3,0x1
 94a:	00d77363          	bgeu	a4,a3,950 <malloc+0x44>
 94e:	6a05                	lui	s4,0x1
 950:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 954:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 958:	00000917          	auipc	s2,0x0
 95c:	1a890913          	addi	s2,s2,424 # b00 <freep>
  if(p == (char*)-1)
 960:	5afd                	li	s5,-1
 962:	a88d                	j	9d4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 964:	00000797          	auipc	a5,0x0
 968:	1a478793          	addi	a5,a5,420 # b08 <base>
 96c:	00000717          	auipc	a4,0x0
 970:	18f73a23          	sd	a5,404(a4) # b00 <freep>
 974:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 976:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 97a:	b7e1                	j	942 <malloc+0x36>
      if(p->s.size == nunits)
 97c:	02e48b63          	beq	s1,a4,9b2 <malloc+0xa6>
        p->s.size -= nunits;
 980:	4137073b          	subw	a4,a4,s3
 984:	c798                	sw	a4,8(a5)
        p += p->s.size;
 986:	1702                	slli	a4,a4,0x20
 988:	9301                	srli	a4,a4,0x20
 98a:	0712                	slli	a4,a4,0x4
 98c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 98e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 992:	00000717          	auipc	a4,0x0
 996:	16a73723          	sd	a0,366(a4) # b00 <freep>
      return (void*)(p + 1);
 99a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 99e:	70e2                	ld	ra,56(sp)
 9a0:	7442                	ld	s0,48(sp)
 9a2:	74a2                	ld	s1,40(sp)
 9a4:	7902                	ld	s2,32(sp)
 9a6:	69e2                	ld	s3,24(sp)
 9a8:	6a42                	ld	s4,16(sp)
 9aa:	6aa2                	ld	s5,8(sp)
 9ac:	6b02                	ld	s6,0(sp)
 9ae:	6121                	addi	sp,sp,64
 9b0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9b2:	6398                	ld	a4,0(a5)
 9b4:	e118                	sd	a4,0(a0)
 9b6:	bff1                	j	992 <malloc+0x86>
  hp->s.size = nu;
 9b8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9bc:	0541                	addi	a0,a0,16
 9be:	00000097          	auipc	ra,0x0
 9c2:	ec6080e7          	jalr	-314(ra) # 884 <free>
  return freep;
 9c6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9ca:	d971                	beqz	a0,99e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ce:	4798                	lw	a4,8(a5)
 9d0:	fa9776e3          	bgeu	a4,s1,97c <malloc+0x70>
    if(p == freep)
 9d4:	00093703          	ld	a4,0(s2)
 9d8:	853e                	mv	a0,a5
 9da:	fef719e3          	bne	a4,a5,9cc <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9de:	8552                	mv	a0,s4
 9e0:	00000097          	auipc	ra,0x0
 9e4:	b76080e7          	jalr	-1162(ra) # 556 <sbrk>
  if(p == (char*)-1)
 9e8:	fd5518e3          	bne	a0,s5,9b8 <malloc+0xac>
        return 0;
 9ec:	4501                	li	a0,0
 9ee:	bf45                	j	99e <malloc+0x92>
