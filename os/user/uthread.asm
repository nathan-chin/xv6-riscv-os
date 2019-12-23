
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct thread *current_thread;
extern void thread_switch(uint64, uint64);
              
void 
thread_init(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	cc278793          	addi	a5,a5,-830 # cc8 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	caf73523          	sd	a5,-854(a4) # cb8 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	caf72823          	sw	a5,-848(a4) # 2cc8 <__global_pointer$+0x182f>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	addi	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:
{
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  26:	00001897          	auipc	a7,0x1
  2a:	c928b883          	ld	a7,-878(a7) # cb8 <current_thread>
  2e:	6789                	lui	a5,0x2
  30:	0791                	addi	a5,a5,4
  32:	97c6                	add	a5,a5,a7
  34:	4711                	li	a4,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  36:	00009517          	auipc	a0,0x9
  3a:	ca250513          	addi	a0,a0,-862 # 8cd8 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  3e:	6609                	lui	a2,0x2
  40:	4589                	li	a1,2
      next_thread = t;
      break;
    }
    t = t + 1;
  42:	00460813          	addi	a6,a2,4 # 2004 <__global_pointer$+0xb6b>
  46:	a809                	j	58 <thread_schedule+0x32>
    if(t->state == RUNNABLE) {
  48:	00c786b3          	add	a3,a5,a2
  4c:	4294                	lw	a3,0(a3)
  4e:	02b68d63          	beq	a3,a1,88 <thread_schedule+0x62>
    t = t + 1;
  52:	97c2                	add	a5,a5,a6
  for(int i = 0; i < MAX_THREAD; i++){
  54:	377d                	addiw	a4,a4,-1
  56:	cb01                	beqz	a4,66 <thread_schedule+0x40>
    if(t >= all_thread + MAX_THREAD)
  58:	fea7e8e3          	bltu	a5,a0,48 <thread_schedule+0x22>
      t = all_thread;
  5c:	00001797          	auipc	a5,0x1
  60:	c6c78793          	addi	a5,a5,-916 # cc8 <all_thread>
  64:	b7d5                	j	48 <thread_schedule+0x22>
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  6e:	00001517          	auipc	a0,0x1
  72:	b1250513          	addi	a0,a0,-1262 # b80 <malloc+0xe4>
  76:	00001097          	auipc	ra,0x1
  7a:	968080e7          	jalr	-1688(ra) # 9de <printf>
    exit(-1);
  7e:	557d                	li	a0,-1
  80:	00000097          	auipc	ra,0x0
  84:	5de080e7          	jalr	1502(ra) # 65e <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  88:	00f88b63          	beq	a7,a5,9e <thread_schedule+0x78>
    next_thread->state = RUNNING;
  8c:	6709                	lui	a4,0x2
  8e:	973e                	add	a4,a4,a5
  90:	4685                	li	a3,1
  92:	c314                	sw	a3,0(a4)
    t = current_thread;
    current_thread = next_thread;
  94:	00001717          	auipc	a4,0x1
  98:	c2f73223          	sd	a5,-988(a4) # cb8 <current_thread>
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
  } else
    next_thread = 0;
}
  9c:	8082                	ret
  9e:	8082                	ret

00000000000000a0 <thread_create>:

void 
thread_create(void (*func)())
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	addi	s0,sp,16
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  a6:	00001797          	auipc	a5,0x1
  aa:	c2278793          	addi	a5,a5,-990 # cc8 <all_thread>
    if (t->state == FREE) break;
  ae:	6689                	lui	a3,0x2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  b0:	00468593          	addi	a1,a3,4 # 2004 <__global_pointer$+0xb6b>
  b4:	00009617          	auipc	a2,0x9
  b8:	c2460613          	addi	a2,a2,-988 # 8cd8 <base>
    if (t->state == FREE) break;
  bc:	00d78733          	add	a4,a5,a3
  c0:	4318                	lw	a4,0(a4)
  c2:	c701                	beqz	a4,ca <thread_create+0x2a>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c4:	97ae                	add	a5,a5,a1
  c6:	fec79be3          	bne	a5,a2,bc <thread_create+0x1c>
  }
  t->state = RUNNABLE;
  ca:	6709                	lui	a4,0x2
  cc:	97ba                	add	a5,a5,a4
  ce:	4709                	li	a4,2
  d0:	c398                	sw	a4,0(a5)
  // YOUR CODE HERE
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <thread_yield>:

void 
thread_yield(void)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
  e0:	00001797          	auipc	a5,0x1
  e4:	bd87b783          	ld	a5,-1064(a5) # cb8 <current_thread>
  e8:	6709                	lui	a4,0x2
  ea:	97ba                	add	a5,a5,a4
  ec:	4709                	li	a4,2
  ee:	c398                	sw	a4,0(a5)
  thread_schedule();
  f0:	00000097          	auipc	ra,0x0
  f4:	f36080e7          	jalr	-202(ra) # 26 <thread_schedule>
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 100:	7179                	addi	sp,sp,-48
 102:	f406                	sd	ra,40(sp)
 104:	f022                	sd	s0,32(sp)
 106:	ec26                	sd	s1,24(sp)
 108:	e84a                	sd	s2,16(sp)
 10a:	e44e                	sd	s3,8(sp)
 10c:	e052                	sd	s4,0(sp)
 10e:	1800                	addi	s0,sp,48
  int i;
  printf("thread_a started\n");
 110:	00001517          	auipc	a0,0x1
 114:	a9850513          	addi	a0,a0,-1384 # ba8 <malloc+0x10c>
 118:	00001097          	auipc	ra,0x1
 11c:	8c6080e7          	jalr	-1850(ra) # 9de <printf>
  a_started = 1;
 120:	4785                	li	a5,1
 122:	00001717          	auipc	a4,0x1
 126:	b8f72923          	sw	a5,-1134(a4) # cb4 <a_started>
  while(b_started == 0 || c_started == 0)
 12a:	00001497          	auipc	s1,0x1
 12e:	b8648493          	addi	s1,s1,-1146 # cb0 <b_started>
 132:	00001917          	auipc	s2,0x1
 136:	b7a90913          	addi	s2,s2,-1158 # cac <c_started>
 13a:	a029                	j	144 <thread_a+0x44>
    thread_yield();
 13c:	00000097          	auipc	ra,0x0
 140:	f9c080e7          	jalr	-100(ra) # d8 <thread_yield>
  while(b_started == 0 || c_started == 0)
 144:	409c                	lw	a5,0(s1)
 146:	2781                	sext.w	a5,a5
 148:	dbf5                	beqz	a5,13c <thread_a+0x3c>
 14a:	00092783          	lw	a5,0(s2)
 14e:	2781                	sext.w	a5,a5
 150:	d7f5                	beqz	a5,13c <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 152:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 154:	00001a17          	auipc	s4,0x1
 158:	a6ca0a13          	addi	s4,s4,-1428 # bc0 <malloc+0x124>
    a_n += 1;
 15c:	00001917          	auipc	s2,0x1
 160:	b4c90913          	addi	s2,s2,-1204 # ca8 <a_n>
  for (i = 0; i < 100; i++) {
 164:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 168:	85a6                	mv	a1,s1
 16a:	8552                	mv	a0,s4
 16c:	00001097          	auipc	ra,0x1
 170:	872080e7          	jalr	-1934(ra) # 9de <printf>
    a_n += 1;
 174:	00092783          	lw	a5,0(s2)
 178:	2785                	addiw	a5,a5,1
 17a:	00f92023          	sw	a5,0(s2)
    thread_yield();
 17e:	00000097          	auipc	ra,0x0
 182:	f5a080e7          	jalr	-166(ra) # d8 <thread_yield>
  for (i = 0; i < 100; i++) {
 186:	2485                	addiw	s1,s1,1
 188:	ff3490e3          	bne	s1,s3,168 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 18c:	00001597          	auipc	a1,0x1
 190:	b1c5a583          	lw	a1,-1252(a1) # ca8 <a_n>
 194:	00001517          	auipc	a0,0x1
 198:	a3c50513          	addi	a0,a0,-1476 # bd0 <malloc+0x134>
 19c:	00001097          	auipc	ra,0x1
 1a0:	842080e7          	jalr	-1982(ra) # 9de <printf>

  current_thread->state = FREE;
 1a4:	00001797          	auipc	a5,0x1
 1a8:	b147b783          	ld	a5,-1260(a5) # cb8 <current_thread>
 1ac:	6709                	lui	a4,0x2
 1ae:	97ba                	add	a5,a5,a4
 1b0:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1b4:	00000097          	auipc	ra,0x0
 1b8:	e72080e7          	jalr	-398(ra) # 26 <thread_schedule>
}
 1bc:	70a2                	ld	ra,40(sp)
 1be:	7402                	ld	s0,32(sp)
 1c0:	64e2                	ld	s1,24(sp)
 1c2:	6942                	ld	s2,16(sp)
 1c4:	69a2                	ld	s3,8(sp)
 1c6:	6a02                	ld	s4,0(sp)
 1c8:	6145                	addi	sp,sp,48
 1ca:	8082                	ret

00000000000001cc <thread_b>:

void 
thread_b(void)
{
 1cc:	7179                	addi	sp,sp,-48
 1ce:	f406                	sd	ra,40(sp)
 1d0:	f022                	sd	s0,32(sp)
 1d2:	ec26                	sd	s1,24(sp)
 1d4:	e84a                	sd	s2,16(sp)
 1d6:	e44e                	sd	s3,8(sp)
 1d8:	e052                	sd	s4,0(sp)
 1da:	1800                	addi	s0,sp,48
  int i;
  printf("thread_b started\n");
 1dc:	00001517          	auipc	a0,0x1
 1e0:	a1450513          	addi	a0,a0,-1516 # bf0 <malloc+0x154>
 1e4:	00000097          	auipc	ra,0x0
 1e8:	7fa080e7          	jalr	2042(ra) # 9de <printf>
  b_started = 1;
 1ec:	4785                	li	a5,1
 1ee:	00001717          	auipc	a4,0x1
 1f2:	acf72123          	sw	a5,-1342(a4) # cb0 <b_started>
  while(a_started == 0 || c_started == 0)
 1f6:	00001497          	auipc	s1,0x1
 1fa:	abe48493          	addi	s1,s1,-1346 # cb4 <a_started>
 1fe:	00001917          	auipc	s2,0x1
 202:	aae90913          	addi	s2,s2,-1362 # cac <c_started>
 206:	a029                	j	210 <thread_b+0x44>
    thread_yield();
 208:	00000097          	auipc	ra,0x0
 20c:	ed0080e7          	jalr	-304(ra) # d8 <thread_yield>
  while(a_started == 0 || c_started == 0)
 210:	409c                	lw	a5,0(s1)
 212:	2781                	sext.w	a5,a5
 214:	dbf5                	beqz	a5,208 <thread_b+0x3c>
 216:	00092783          	lw	a5,0(s2)
 21a:	2781                	sext.w	a5,a5
 21c:	d7f5                	beqz	a5,208 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 21e:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 220:	00001a17          	auipc	s4,0x1
 224:	9e8a0a13          	addi	s4,s4,-1560 # c08 <malloc+0x16c>
    b_n += 1;
 228:	00001917          	auipc	s2,0x1
 22c:	a7c90913          	addi	s2,s2,-1412 # ca4 <b_n>
  for (i = 0; i < 100; i++) {
 230:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 234:	85a6                	mv	a1,s1
 236:	8552                	mv	a0,s4
 238:	00000097          	auipc	ra,0x0
 23c:	7a6080e7          	jalr	1958(ra) # 9de <printf>
    b_n += 1;
 240:	00092783          	lw	a5,0(s2)
 244:	2785                	addiw	a5,a5,1
 246:	00f92023          	sw	a5,0(s2)
    thread_yield();
 24a:	00000097          	auipc	ra,0x0
 24e:	e8e080e7          	jalr	-370(ra) # d8 <thread_yield>
  for (i = 0; i < 100; i++) {
 252:	2485                	addiw	s1,s1,1
 254:	ff3490e3          	bne	s1,s3,234 <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 258:	00001597          	auipc	a1,0x1
 25c:	a4c5a583          	lw	a1,-1460(a1) # ca4 <b_n>
 260:	00001517          	auipc	a0,0x1
 264:	9b850513          	addi	a0,a0,-1608 # c18 <malloc+0x17c>
 268:	00000097          	auipc	ra,0x0
 26c:	776080e7          	jalr	1910(ra) # 9de <printf>

  current_thread->state = FREE;
 270:	00001797          	auipc	a5,0x1
 274:	a487b783          	ld	a5,-1464(a5) # cb8 <current_thread>
 278:	6709                	lui	a4,0x2
 27a:	97ba                	add	a5,a5,a4
 27c:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 280:	00000097          	auipc	ra,0x0
 284:	da6080e7          	jalr	-602(ra) # 26 <thread_schedule>
}
 288:	70a2                	ld	ra,40(sp)
 28a:	7402                	ld	s0,32(sp)
 28c:	64e2                	ld	s1,24(sp)
 28e:	6942                	ld	s2,16(sp)
 290:	69a2                	ld	s3,8(sp)
 292:	6a02                	ld	s4,0(sp)
 294:	6145                	addi	sp,sp,48
 296:	8082                	ret

0000000000000298 <thread_c>:

void 
thread_c(void)
{
 298:	7179                	addi	sp,sp,-48
 29a:	f406                	sd	ra,40(sp)
 29c:	f022                	sd	s0,32(sp)
 29e:	ec26                	sd	s1,24(sp)
 2a0:	e84a                	sd	s2,16(sp)
 2a2:	e44e                	sd	s3,8(sp)
 2a4:	e052                	sd	s4,0(sp)
 2a6:	1800                	addi	s0,sp,48
  int i;
  printf("thread_c started\n");
 2a8:	00001517          	auipc	a0,0x1
 2ac:	99050513          	addi	a0,a0,-1648 # c38 <malloc+0x19c>
 2b0:	00000097          	auipc	ra,0x0
 2b4:	72e080e7          	jalr	1838(ra) # 9de <printf>
  c_started = 1;
 2b8:	4785                	li	a5,1
 2ba:	00001717          	auipc	a4,0x1
 2be:	9ef72923          	sw	a5,-1550(a4) # cac <c_started>
  while(a_started == 0 || b_started == 0)
 2c2:	00001497          	auipc	s1,0x1
 2c6:	9f248493          	addi	s1,s1,-1550 # cb4 <a_started>
 2ca:	00001917          	auipc	s2,0x1
 2ce:	9e690913          	addi	s2,s2,-1562 # cb0 <b_started>
 2d2:	a029                	j	2dc <thread_c+0x44>
    thread_yield();
 2d4:	00000097          	auipc	ra,0x0
 2d8:	e04080e7          	jalr	-508(ra) # d8 <thread_yield>
  while(a_started == 0 || b_started == 0)
 2dc:	409c                	lw	a5,0(s1)
 2de:	2781                	sext.w	a5,a5
 2e0:	dbf5                	beqz	a5,2d4 <thread_c+0x3c>
 2e2:	00092783          	lw	a5,0(s2)
 2e6:	2781                	sext.w	a5,a5
 2e8:	d7f5                	beqz	a5,2d4 <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 2ea:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 2ec:	00001a17          	auipc	s4,0x1
 2f0:	964a0a13          	addi	s4,s4,-1692 # c50 <malloc+0x1b4>
    c_n += 1;
 2f4:	00001917          	auipc	s2,0x1
 2f8:	9ac90913          	addi	s2,s2,-1620 # ca0 <c_n>
  for (i = 0; i < 100; i++) {
 2fc:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 300:	85a6                	mv	a1,s1
 302:	8552                	mv	a0,s4
 304:	00000097          	auipc	ra,0x0
 308:	6da080e7          	jalr	1754(ra) # 9de <printf>
    c_n += 1;
 30c:	00092783          	lw	a5,0(s2)
 310:	2785                	addiw	a5,a5,1
 312:	00f92023          	sw	a5,0(s2)
    thread_yield();
 316:	00000097          	auipc	ra,0x0
 31a:	dc2080e7          	jalr	-574(ra) # d8 <thread_yield>
  for (i = 0; i < 100; i++) {
 31e:	2485                	addiw	s1,s1,1
 320:	ff3490e3          	bne	s1,s3,300 <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 324:	00001597          	auipc	a1,0x1
 328:	97c5a583          	lw	a1,-1668(a1) # ca0 <c_n>
 32c:	00001517          	auipc	a0,0x1
 330:	93450513          	addi	a0,a0,-1740 # c60 <malloc+0x1c4>
 334:	00000097          	auipc	ra,0x0
 338:	6aa080e7          	jalr	1706(ra) # 9de <printf>

  current_thread->state = FREE;
 33c:	00001797          	auipc	a5,0x1
 340:	97c7b783          	ld	a5,-1668(a5) # cb8 <current_thread>
 344:	6709                	lui	a4,0x2
 346:	97ba                	add	a5,a5,a4
 348:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 34c:	00000097          	auipc	ra,0x0
 350:	cda080e7          	jalr	-806(ra) # 26 <thread_schedule>
}
 354:	70a2                	ld	ra,40(sp)
 356:	7402                	ld	s0,32(sp)
 358:	64e2                	ld	s1,24(sp)
 35a:	6942                	ld	s2,16(sp)
 35c:	69a2                	ld	s3,8(sp)
 35e:	6a02                	ld	s4,0(sp)
 360:	6145                	addi	sp,sp,48
 362:	8082                	ret

0000000000000364 <main>:

int 
main(int argc, char *argv[]) 
{
 364:	1141                	addi	sp,sp,-16
 366:	e406                	sd	ra,8(sp)
 368:	e022                	sd	s0,0(sp)
 36a:	0800                	addi	s0,sp,16
  a_started = b_started = c_started = 0;
 36c:	00001797          	auipc	a5,0x1
 370:	9407a023          	sw	zero,-1728(a5) # cac <c_started>
 374:	00001797          	auipc	a5,0x1
 378:	9207ae23          	sw	zero,-1732(a5) # cb0 <b_started>
 37c:	00001797          	auipc	a5,0x1
 380:	9207ac23          	sw	zero,-1736(a5) # cb4 <a_started>
  a_n = b_n = c_n = 0;
 384:	00001797          	auipc	a5,0x1
 388:	9007ae23          	sw	zero,-1764(a5) # ca0 <c_n>
 38c:	00001797          	auipc	a5,0x1
 390:	9007ac23          	sw	zero,-1768(a5) # ca4 <b_n>
 394:	00001797          	auipc	a5,0x1
 398:	9007aa23          	sw	zero,-1772(a5) # ca8 <a_n>
  thread_init();
 39c:	00000097          	auipc	ra,0x0
 3a0:	c64080e7          	jalr	-924(ra) # 0 <thread_init>
  thread_create(thread_a);
 3a4:	00000517          	auipc	a0,0x0
 3a8:	d5c50513          	addi	a0,a0,-676 # 100 <thread_a>
 3ac:	00000097          	auipc	ra,0x0
 3b0:	cf4080e7          	jalr	-780(ra) # a0 <thread_create>
  thread_create(thread_b);
 3b4:	00000517          	auipc	a0,0x0
 3b8:	e1850513          	addi	a0,a0,-488 # 1cc <thread_b>
 3bc:	00000097          	auipc	ra,0x0
 3c0:	ce4080e7          	jalr	-796(ra) # a0 <thread_create>
  thread_create(thread_c);
 3c4:	00000517          	auipc	a0,0x0
 3c8:	ed450513          	addi	a0,a0,-300 # 298 <thread_c>
 3cc:	00000097          	auipc	ra,0x0
 3d0:	cd4080e7          	jalr	-812(ra) # a0 <thread_create>
  thread_schedule();
 3d4:	00000097          	auipc	ra,0x0
 3d8:	c52080e7          	jalr	-942(ra) # 26 <thread_schedule>
  exit(0);
 3dc:	4501                	li	a0,0
 3de:	00000097          	auipc	ra,0x0
 3e2:	280080e7          	jalr	640(ra) # 65e <exit>

00000000000003e6 <thread_switch>:
 3e6:	8082                	ret

00000000000003e8 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 3e8:	1141                	addi	sp,sp,-16
 3ea:	e422                	sd	s0,8(sp)
 3ec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3ee:	87aa                	mv	a5,a0
 3f0:	0585                	addi	a1,a1,1
 3f2:	0785                	addi	a5,a5,1
 3f4:	fff5c703          	lbu	a4,-1(a1)
 3f8:	fee78fa3          	sb	a4,-1(a5)
 3fc:	fb75                	bnez	a4,3f0 <strcpy+0x8>
    ;
  return os;
}
 3fe:	6422                	ld	s0,8(sp)
 400:	0141                	addi	sp,sp,16
 402:	8082                	ret

0000000000000404 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 404:	1141                	addi	sp,sp,-16
 406:	e422                	sd	s0,8(sp)
 408:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 40a:	00054783          	lbu	a5,0(a0)
 40e:	cb91                	beqz	a5,422 <strcmp+0x1e>
 410:	0005c703          	lbu	a4,0(a1)
 414:	00f71763          	bne	a4,a5,422 <strcmp+0x1e>
    p++, q++;
 418:	0505                	addi	a0,a0,1
 41a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 41c:	00054783          	lbu	a5,0(a0)
 420:	fbe5                	bnez	a5,410 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 422:	0005c503          	lbu	a0,0(a1)
}
 426:	40a7853b          	subw	a0,a5,a0
 42a:	6422                	ld	s0,8(sp)
 42c:	0141                	addi	sp,sp,16
 42e:	8082                	ret

0000000000000430 <strlen>:

uint
strlen(const char *s)
{
 430:	1141                	addi	sp,sp,-16
 432:	e422                	sd	s0,8(sp)
 434:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 436:	00054783          	lbu	a5,0(a0)
 43a:	cf91                	beqz	a5,456 <strlen+0x26>
 43c:	0505                	addi	a0,a0,1
 43e:	87aa                	mv	a5,a0
 440:	4685                	li	a3,1
 442:	9e89                	subw	a3,a3,a0
 444:	00f6853b          	addw	a0,a3,a5
 448:	0785                	addi	a5,a5,1
 44a:	fff7c703          	lbu	a4,-1(a5)
 44e:	fb7d                	bnez	a4,444 <strlen+0x14>
    ;
  return n;
}
 450:	6422                	ld	s0,8(sp)
 452:	0141                	addi	sp,sp,16
 454:	8082                	ret
  for(n = 0; s[n]; n++)
 456:	4501                	li	a0,0
 458:	bfe5                	j	450 <strlen+0x20>

000000000000045a <memset>:

void*
memset(void *dst, int c, uint n)
{
 45a:	1141                	addi	sp,sp,-16
 45c:	e422                	sd	s0,8(sp)
 45e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 460:	ce09                	beqz	a2,47a <memset+0x20>
 462:	87aa                	mv	a5,a0
 464:	fff6071b          	addiw	a4,a2,-1
 468:	1702                	slli	a4,a4,0x20
 46a:	9301                	srli	a4,a4,0x20
 46c:	0705                	addi	a4,a4,1
 46e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 470:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 474:	0785                	addi	a5,a5,1
 476:	fee79de3          	bne	a5,a4,470 <memset+0x16>
  }
  return dst;
}
 47a:	6422                	ld	s0,8(sp)
 47c:	0141                	addi	sp,sp,16
 47e:	8082                	ret

0000000000000480 <strchr>:

char*
strchr(const char *s, char c)
{
 480:	1141                	addi	sp,sp,-16
 482:	e422                	sd	s0,8(sp)
 484:	0800                	addi	s0,sp,16
  for(; *s; s++)
 486:	00054783          	lbu	a5,0(a0)
 48a:	cb99                	beqz	a5,4a0 <strchr+0x20>
    if(*s == c)
 48c:	00f58763          	beq	a1,a5,49a <strchr+0x1a>
  for(; *s; s++)
 490:	0505                	addi	a0,a0,1
 492:	00054783          	lbu	a5,0(a0)
 496:	fbfd                	bnez	a5,48c <strchr+0xc>
      return (char*)s;
  return 0;
 498:	4501                	li	a0,0
}
 49a:	6422                	ld	s0,8(sp)
 49c:	0141                	addi	sp,sp,16
 49e:	8082                	ret
  return 0;
 4a0:	4501                	li	a0,0
 4a2:	bfe5                	j	49a <strchr+0x1a>

00000000000004a4 <gets>:

char*
gets(char *buf, int max)
{
 4a4:	711d                	addi	sp,sp,-96
 4a6:	ec86                	sd	ra,88(sp)
 4a8:	e8a2                	sd	s0,80(sp)
 4aa:	e4a6                	sd	s1,72(sp)
 4ac:	e0ca                	sd	s2,64(sp)
 4ae:	fc4e                	sd	s3,56(sp)
 4b0:	f852                	sd	s4,48(sp)
 4b2:	f456                	sd	s5,40(sp)
 4b4:	f05a                	sd	s6,32(sp)
 4b6:	ec5e                	sd	s7,24(sp)
 4b8:	1080                	addi	s0,sp,96
 4ba:	8baa                	mv	s7,a0
 4bc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4be:	892a                	mv	s2,a0
 4c0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4c2:	4aa9                	li	s5,10
 4c4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4c6:	89a6                	mv	s3,s1
 4c8:	2485                	addiw	s1,s1,1
 4ca:	0344d863          	bge	s1,s4,4fa <gets+0x56>
    cc = read(0, &c, 1);
 4ce:	4605                	li	a2,1
 4d0:	faf40593          	addi	a1,s0,-81
 4d4:	4501                	li	a0,0
 4d6:	00000097          	auipc	ra,0x0
 4da:	1a0080e7          	jalr	416(ra) # 676 <read>
    if(cc < 1)
 4de:	00a05e63          	blez	a0,4fa <gets+0x56>
    buf[i++] = c;
 4e2:	faf44783          	lbu	a5,-81(s0)
 4e6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4ea:	01578763          	beq	a5,s5,4f8 <gets+0x54>
 4ee:	0905                	addi	s2,s2,1
 4f0:	fd679be3          	bne	a5,s6,4c6 <gets+0x22>
  for(i=0; i+1 < max; ){
 4f4:	89a6                	mv	s3,s1
 4f6:	a011                	j	4fa <gets+0x56>
 4f8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4fa:	99de                	add	s3,s3,s7
 4fc:	00098023          	sb	zero,0(s3)
  return buf;
}
 500:	855e                	mv	a0,s7
 502:	60e6                	ld	ra,88(sp)
 504:	6446                	ld	s0,80(sp)
 506:	64a6                	ld	s1,72(sp)
 508:	6906                	ld	s2,64(sp)
 50a:	79e2                	ld	s3,56(sp)
 50c:	7a42                	ld	s4,48(sp)
 50e:	7aa2                	ld	s5,40(sp)
 510:	7b02                	ld	s6,32(sp)
 512:	6be2                	ld	s7,24(sp)
 514:	6125                	addi	sp,sp,96
 516:	8082                	ret

0000000000000518 <stat>:

int
stat(const char *n, struct stat *st)
{
 518:	1101                	addi	sp,sp,-32
 51a:	ec06                	sd	ra,24(sp)
 51c:	e822                	sd	s0,16(sp)
 51e:	e426                	sd	s1,8(sp)
 520:	e04a                	sd	s2,0(sp)
 522:	1000                	addi	s0,sp,32
 524:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 526:	4581                	li	a1,0
 528:	00000097          	auipc	ra,0x0
 52c:	176080e7          	jalr	374(ra) # 69e <open>
  if(fd < 0)
 530:	02054563          	bltz	a0,55a <stat+0x42>
 534:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 536:	85ca                	mv	a1,s2
 538:	00000097          	auipc	ra,0x0
 53c:	17e080e7          	jalr	382(ra) # 6b6 <fstat>
 540:	892a                	mv	s2,a0
  close(fd);
 542:	8526                	mv	a0,s1
 544:	00000097          	auipc	ra,0x0
 548:	142080e7          	jalr	322(ra) # 686 <close>
  return r;
}
 54c:	854a                	mv	a0,s2
 54e:	60e2                	ld	ra,24(sp)
 550:	6442                	ld	s0,16(sp)
 552:	64a2                	ld	s1,8(sp)
 554:	6902                	ld	s2,0(sp)
 556:	6105                	addi	sp,sp,32
 558:	8082                	ret
    return -1;
 55a:	597d                	li	s2,-1
 55c:	bfc5                	j	54c <stat+0x34>

000000000000055e <atoi>:

int
atoi(const char *s)
{
 55e:	1141                	addi	sp,sp,-16
 560:	e422                	sd	s0,8(sp)
 562:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 564:	00054603          	lbu	a2,0(a0)
 568:	fd06079b          	addiw	a5,a2,-48
 56c:	0ff7f793          	andi	a5,a5,255
 570:	4725                	li	a4,9
 572:	02f76963          	bltu	a4,a5,5a4 <atoi+0x46>
 576:	86aa                	mv	a3,a0
  n = 0;
 578:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 57a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 57c:	0685                	addi	a3,a3,1
 57e:	0025179b          	slliw	a5,a0,0x2
 582:	9fa9                	addw	a5,a5,a0
 584:	0017979b          	slliw	a5,a5,0x1
 588:	9fb1                	addw	a5,a5,a2
 58a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 58e:	0006c603          	lbu	a2,0(a3)
 592:	fd06071b          	addiw	a4,a2,-48
 596:	0ff77713          	andi	a4,a4,255
 59a:	fee5f1e3          	bgeu	a1,a4,57c <atoi+0x1e>
  return n;
}
 59e:	6422                	ld	s0,8(sp)
 5a0:	0141                	addi	sp,sp,16
 5a2:	8082                	ret
  n = 0;
 5a4:	4501                	li	a0,0
 5a6:	bfe5                	j	59e <atoi+0x40>

00000000000005a8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5a8:	1141                	addi	sp,sp,-16
 5aa:	e422                	sd	s0,8(sp)
 5ac:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 5ae:	02b57663          	bgeu	a0,a1,5da <memmove+0x32>
    while(n-- > 0)
 5b2:	02c05163          	blez	a2,5d4 <memmove+0x2c>
 5b6:	fff6079b          	addiw	a5,a2,-1
 5ba:	1782                	slli	a5,a5,0x20
 5bc:	9381                	srli	a5,a5,0x20
 5be:	0785                	addi	a5,a5,1
 5c0:	97aa                	add	a5,a5,a0
  dst = vdst;
 5c2:	872a                	mv	a4,a0
      *dst++ = *src++;
 5c4:	0585                	addi	a1,a1,1
 5c6:	0705                	addi	a4,a4,1
 5c8:	fff5c683          	lbu	a3,-1(a1)
 5cc:	fed70fa3          	sb	a3,-1(a4) # 1fff <__global_pointer$+0xb66>
    while(n-- > 0)
 5d0:	fee79ae3          	bne	a5,a4,5c4 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5d4:	6422                	ld	s0,8(sp)
 5d6:	0141                	addi	sp,sp,16
 5d8:	8082                	ret
    dst += n;
 5da:	00c50733          	add	a4,a0,a2
    src += n;
 5de:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5e0:	fec05ae3          	blez	a2,5d4 <memmove+0x2c>
 5e4:	fff6079b          	addiw	a5,a2,-1
 5e8:	1782                	slli	a5,a5,0x20
 5ea:	9381                	srli	a5,a5,0x20
 5ec:	fff7c793          	not	a5,a5
 5f0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5f2:	15fd                	addi	a1,a1,-1
 5f4:	177d                	addi	a4,a4,-1
 5f6:	0005c683          	lbu	a3,0(a1)
 5fa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5fe:	fee79ae3          	bne	a5,a4,5f2 <memmove+0x4a>
 602:	bfc9                	j	5d4 <memmove+0x2c>

0000000000000604 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 604:	1141                	addi	sp,sp,-16
 606:	e422                	sd	s0,8(sp)
 608:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 60a:	ca05                	beqz	a2,63a <memcmp+0x36>
 60c:	fff6069b          	addiw	a3,a2,-1
 610:	1682                	slli	a3,a3,0x20
 612:	9281                	srli	a3,a3,0x20
 614:	0685                	addi	a3,a3,1
 616:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 618:	00054783          	lbu	a5,0(a0)
 61c:	0005c703          	lbu	a4,0(a1)
 620:	00e79863          	bne	a5,a4,630 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 624:	0505                	addi	a0,a0,1
    p2++;
 626:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 628:	fed518e3          	bne	a0,a3,618 <memcmp+0x14>
  }
  return 0;
 62c:	4501                	li	a0,0
 62e:	a019                	j	634 <memcmp+0x30>
      return *p1 - *p2;
 630:	40e7853b          	subw	a0,a5,a4
}
 634:	6422                	ld	s0,8(sp)
 636:	0141                	addi	sp,sp,16
 638:	8082                	ret
  return 0;
 63a:	4501                	li	a0,0
 63c:	bfe5                	j	634 <memcmp+0x30>

000000000000063e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 63e:	1141                	addi	sp,sp,-16
 640:	e406                	sd	ra,8(sp)
 642:	e022                	sd	s0,0(sp)
 644:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 646:	00000097          	auipc	ra,0x0
 64a:	f62080e7          	jalr	-158(ra) # 5a8 <memmove>
}
 64e:	60a2                	ld	ra,8(sp)
 650:	6402                	ld	s0,0(sp)
 652:	0141                	addi	sp,sp,16
 654:	8082                	ret

0000000000000656 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 656:	4885                	li	a7,1
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <exit>:
.global exit
exit:
 li a7, SYS_exit
 65e:	4889                	li	a7,2
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <wait>:
.global wait
wait:
 li a7, SYS_wait
 666:	488d                	li	a7,3
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 66e:	4891                	li	a7,4
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <read>:
.global read
read:
 li a7, SYS_read
 676:	4895                	li	a7,5
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <write>:
.global write
write:
 li a7, SYS_write
 67e:	48c1                	li	a7,16
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <close>:
.global close
close:
 li a7, SYS_close
 686:	48d5                	li	a7,21
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <kill>:
.global kill
kill:
 li a7, SYS_kill
 68e:	4899                	li	a7,6
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <exec>:
.global exec
exec:
 li a7, SYS_exec
 696:	489d                	li	a7,7
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <open>:
.global open
open:
 li a7, SYS_open
 69e:	48bd                	li	a7,15
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6a6:	48c5                	li	a7,17
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6ae:	48c9                	li	a7,18
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6b6:	48a1                	li	a7,8
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <link>:
.global link
link:
 li a7, SYS_link
 6be:	48cd                	li	a7,19
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6c6:	48d1                	li	a7,20
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6ce:	48a5                	li	a7,9
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6d6:	48a9                	li	a7,10
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6de:	48ad                	li	a7,11
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6e6:	48b1                	li	a7,12
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6ee:	48b5                	li	a7,13
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6f6:	48b9                	li	a7,14
 ecall
 6f8:	00000073          	ecall
 ret
 6fc:	8082                	ret

00000000000006fe <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 6fe:	48d9                	li	a7,22
 ecall
 700:	00000073          	ecall
 ret
 704:	8082                	ret

0000000000000706 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 706:	1101                	addi	sp,sp,-32
 708:	ec06                	sd	ra,24(sp)
 70a:	e822                	sd	s0,16(sp)
 70c:	1000                	addi	s0,sp,32
 70e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 712:	4605                	li	a2,1
 714:	fef40593          	addi	a1,s0,-17
 718:	00000097          	auipc	ra,0x0
 71c:	f66080e7          	jalr	-154(ra) # 67e <write>
}
 720:	60e2                	ld	ra,24(sp)
 722:	6442                	ld	s0,16(sp)
 724:	6105                	addi	sp,sp,32
 726:	8082                	ret

0000000000000728 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 728:	7139                	addi	sp,sp,-64
 72a:	fc06                	sd	ra,56(sp)
 72c:	f822                	sd	s0,48(sp)
 72e:	f426                	sd	s1,40(sp)
 730:	f04a                	sd	s2,32(sp)
 732:	ec4e                	sd	s3,24(sp)
 734:	0080                	addi	s0,sp,64
 736:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 738:	c299                	beqz	a3,73e <printint+0x16>
 73a:	0805c863          	bltz	a1,7ca <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 73e:	2581                	sext.w	a1,a1
  neg = 0;
 740:	4881                	li	a7,0
 742:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 746:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 748:	2601                	sext.w	a2,a2
 74a:	00000517          	auipc	a0,0x0
 74e:	53e50513          	addi	a0,a0,1342 # c88 <digits>
 752:	883a                	mv	a6,a4
 754:	2705                	addiw	a4,a4,1
 756:	02c5f7bb          	remuw	a5,a1,a2
 75a:	1782                	slli	a5,a5,0x20
 75c:	9381                	srli	a5,a5,0x20
 75e:	97aa                	add	a5,a5,a0
 760:	0007c783          	lbu	a5,0(a5)
 764:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 768:	0005879b          	sext.w	a5,a1
 76c:	02c5d5bb          	divuw	a1,a1,a2
 770:	0685                	addi	a3,a3,1
 772:	fec7f0e3          	bgeu	a5,a2,752 <printint+0x2a>
  if(neg)
 776:	00088b63          	beqz	a7,78c <printint+0x64>
    buf[i++] = '-';
 77a:	fd040793          	addi	a5,s0,-48
 77e:	973e                	add	a4,a4,a5
 780:	02d00793          	li	a5,45
 784:	fef70823          	sb	a5,-16(a4)
 788:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 78c:	02e05863          	blez	a4,7bc <printint+0x94>
 790:	fc040793          	addi	a5,s0,-64
 794:	00e78933          	add	s2,a5,a4
 798:	fff78993          	addi	s3,a5,-1
 79c:	99ba                	add	s3,s3,a4
 79e:	377d                	addiw	a4,a4,-1
 7a0:	1702                	slli	a4,a4,0x20
 7a2:	9301                	srli	a4,a4,0x20
 7a4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7a8:	fff94583          	lbu	a1,-1(s2)
 7ac:	8526                	mv	a0,s1
 7ae:	00000097          	auipc	ra,0x0
 7b2:	f58080e7          	jalr	-168(ra) # 706 <putc>
  while(--i >= 0)
 7b6:	197d                	addi	s2,s2,-1
 7b8:	ff3918e3          	bne	s2,s3,7a8 <printint+0x80>
}
 7bc:	70e2                	ld	ra,56(sp)
 7be:	7442                	ld	s0,48(sp)
 7c0:	74a2                	ld	s1,40(sp)
 7c2:	7902                	ld	s2,32(sp)
 7c4:	69e2                	ld	s3,24(sp)
 7c6:	6121                	addi	sp,sp,64
 7c8:	8082                	ret
    x = -xx;
 7ca:	40b005bb          	negw	a1,a1
    neg = 1;
 7ce:	4885                	li	a7,1
    x = -xx;
 7d0:	bf8d                	j	742 <printint+0x1a>

00000000000007d2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7d2:	7119                	addi	sp,sp,-128
 7d4:	fc86                	sd	ra,120(sp)
 7d6:	f8a2                	sd	s0,112(sp)
 7d8:	f4a6                	sd	s1,104(sp)
 7da:	f0ca                	sd	s2,96(sp)
 7dc:	ecce                	sd	s3,88(sp)
 7de:	e8d2                	sd	s4,80(sp)
 7e0:	e4d6                	sd	s5,72(sp)
 7e2:	e0da                	sd	s6,64(sp)
 7e4:	fc5e                	sd	s7,56(sp)
 7e6:	f862                	sd	s8,48(sp)
 7e8:	f466                	sd	s9,40(sp)
 7ea:	f06a                	sd	s10,32(sp)
 7ec:	ec6e                	sd	s11,24(sp)
 7ee:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7f0:	0005c903          	lbu	s2,0(a1)
 7f4:	18090f63          	beqz	s2,992 <vprintf+0x1c0>
 7f8:	8aaa                	mv	s5,a0
 7fa:	8b32                	mv	s6,a2
 7fc:	00158493          	addi	s1,a1,1
  state = 0;
 800:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 802:	02500a13          	li	s4,37
      if(c == 'd'){
 806:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 80a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 80e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 812:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 816:	00000b97          	auipc	s7,0x0
 81a:	472b8b93          	addi	s7,s7,1138 # c88 <digits>
 81e:	a839                	j	83c <vprintf+0x6a>
        putc(fd, c);
 820:	85ca                	mv	a1,s2
 822:	8556                	mv	a0,s5
 824:	00000097          	auipc	ra,0x0
 828:	ee2080e7          	jalr	-286(ra) # 706 <putc>
 82c:	a019                	j	832 <vprintf+0x60>
    } else if(state == '%'){
 82e:	01498f63          	beq	s3,s4,84c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 832:	0485                	addi	s1,s1,1
 834:	fff4c903          	lbu	s2,-1(s1)
 838:	14090d63          	beqz	s2,992 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 83c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 840:	fe0997e3          	bnez	s3,82e <vprintf+0x5c>
      if(c == '%'){
 844:	fd479ee3          	bne	a5,s4,820 <vprintf+0x4e>
        state = '%';
 848:	89be                	mv	s3,a5
 84a:	b7e5                	j	832 <vprintf+0x60>
      if(c == 'd'){
 84c:	05878063          	beq	a5,s8,88c <vprintf+0xba>
      } else if(c == 'l') {
 850:	05978c63          	beq	a5,s9,8a8 <vprintf+0xd6>
      } else if(c == 'x') {
 854:	07a78863          	beq	a5,s10,8c4 <vprintf+0xf2>
      } else if(c == 'p') {
 858:	09b78463          	beq	a5,s11,8e0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 85c:	07300713          	li	a4,115
 860:	0ce78663          	beq	a5,a4,92c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 864:	06300713          	li	a4,99
 868:	0ee78e63          	beq	a5,a4,964 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 86c:	11478863          	beq	a5,s4,97c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 870:	85d2                	mv	a1,s4
 872:	8556                	mv	a0,s5
 874:	00000097          	auipc	ra,0x0
 878:	e92080e7          	jalr	-366(ra) # 706 <putc>
        putc(fd, c);
 87c:	85ca                	mv	a1,s2
 87e:	8556                	mv	a0,s5
 880:	00000097          	auipc	ra,0x0
 884:	e86080e7          	jalr	-378(ra) # 706 <putc>
      }
      state = 0;
 888:	4981                	li	s3,0
 88a:	b765                	j	832 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 88c:	008b0913          	addi	s2,s6,8
 890:	4685                	li	a3,1
 892:	4629                	li	a2,10
 894:	000b2583          	lw	a1,0(s6)
 898:	8556                	mv	a0,s5
 89a:	00000097          	auipc	ra,0x0
 89e:	e8e080e7          	jalr	-370(ra) # 728 <printint>
 8a2:	8b4a                	mv	s6,s2
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	b771                	j	832 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8a8:	008b0913          	addi	s2,s6,8
 8ac:	4681                	li	a3,0
 8ae:	4629                	li	a2,10
 8b0:	000b2583          	lw	a1,0(s6)
 8b4:	8556                	mv	a0,s5
 8b6:	00000097          	auipc	ra,0x0
 8ba:	e72080e7          	jalr	-398(ra) # 728 <printint>
 8be:	8b4a                	mv	s6,s2
      state = 0;
 8c0:	4981                	li	s3,0
 8c2:	bf85                	j	832 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 8c4:	008b0913          	addi	s2,s6,8
 8c8:	4681                	li	a3,0
 8ca:	4641                	li	a2,16
 8cc:	000b2583          	lw	a1,0(s6)
 8d0:	8556                	mv	a0,s5
 8d2:	00000097          	auipc	ra,0x0
 8d6:	e56080e7          	jalr	-426(ra) # 728 <printint>
 8da:	8b4a                	mv	s6,s2
      state = 0;
 8dc:	4981                	li	s3,0
 8de:	bf91                	j	832 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8e0:	008b0793          	addi	a5,s6,8
 8e4:	f8f43423          	sd	a5,-120(s0)
 8e8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8ec:	03000593          	li	a1,48
 8f0:	8556                	mv	a0,s5
 8f2:	00000097          	auipc	ra,0x0
 8f6:	e14080e7          	jalr	-492(ra) # 706 <putc>
  putc(fd, 'x');
 8fa:	85ea                	mv	a1,s10
 8fc:	8556                	mv	a0,s5
 8fe:	00000097          	auipc	ra,0x0
 902:	e08080e7          	jalr	-504(ra) # 706 <putc>
 906:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 908:	03c9d793          	srli	a5,s3,0x3c
 90c:	97de                	add	a5,a5,s7
 90e:	0007c583          	lbu	a1,0(a5)
 912:	8556                	mv	a0,s5
 914:	00000097          	auipc	ra,0x0
 918:	df2080e7          	jalr	-526(ra) # 706 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 91c:	0992                	slli	s3,s3,0x4
 91e:	397d                	addiw	s2,s2,-1
 920:	fe0914e3          	bnez	s2,908 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 924:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 928:	4981                	li	s3,0
 92a:	b721                	j	832 <vprintf+0x60>
        s = va_arg(ap, char*);
 92c:	008b0993          	addi	s3,s6,8
 930:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 934:	02090163          	beqz	s2,956 <vprintf+0x184>
        while(*s != 0){
 938:	00094583          	lbu	a1,0(s2)
 93c:	c9a1                	beqz	a1,98c <vprintf+0x1ba>
          putc(fd, *s);
 93e:	8556                	mv	a0,s5
 940:	00000097          	auipc	ra,0x0
 944:	dc6080e7          	jalr	-570(ra) # 706 <putc>
          s++;
 948:	0905                	addi	s2,s2,1
        while(*s != 0){
 94a:	00094583          	lbu	a1,0(s2)
 94e:	f9e5                	bnez	a1,93e <vprintf+0x16c>
        s = va_arg(ap, char*);
 950:	8b4e                	mv	s6,s3
      state = 0;
 952:	4981                	li	s3,0
 954:	bdf9                	j	832 <vprintf+0x60>
          s = "(null)";
 956:	00000917          	auipc	s2,0x0
 95a:	32a90913          	addi	s2,s2,810 # c80 <malloc+0x1e4>
        while(*s != 0){
 95e:	02800593          	li	a1,40
 962:	bff1                	j	93e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 964:	008b0913          	addi	s2,s6,8
 968:	000b4583          	lbu	a1,0(s6)
 96c:	8556                	mv	a0,s5
 96e:	00000097          	auipc	ra,0x0
 972:	d98080e7          	jalr	-616(ra) # 706 <putc>
 976:	8b4a                	mv	s6,s2
      state = 0;
 978:	4981                	li	s3,0
 97a:	bd65                	j	832 <vprintf+0x60>
        putc(fd, c);
 97c:	85d2                	mv	a1,s4
 97e:	8556                	mv	a0,s5
 980:	00000097          	auipc	ra,0x0
 984:	d86080e7          	jalr	-634(ra) # 706 <putc>
      state = 0;
 988:	4981                	li	s3,0
 98a:	b565                	j	832 <vprintf+0x60>
        s = va_arg(ap, char*);
 98c:	8b4e                	mv	s6,s3
      state = 0;
 98e:	4981                	li	s3,0
 990:	b54d                	j	832 <vprintf+0x60>
    }
  }
}
 992:	70e6                	ld	ra,120(sp)
 994:	7446                	ld	s0,112(sp)
 996:	74a6                	ld	s1,104(sp)
 998:	7906                	ld	s2,96(sp)
 99a:	69e6                	ld	s3,88(sp)
 99c:	6a46                	ld	s4,80(sp)
 99e:	6aa6                	ld	s5,72(sp)
 9a0:	6b06                	ld	s6,64(sp)
 9a2:	7be2                	ld	s7,56(sp)
 9a4:	7c42                	ld	s8,48(sp)
 9a6:	7ca2                	ld	s9,40(sp)
 9a8:	7d02                	ld	s10,32(sp)
 9aa:	6de2                	ld	s11,24(sp)
 9ac:	6109                	addi	sp,sp,128
 9ae:	8082                	ret

00000000000009b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9b0:	715d                	addi	sp,sp,-80
 9b2:	ec06                	sd	ra,24(sp)
 9b4:	e822                	sd	s0,16(sp)
 9b6:	1000                	addi	s0,sp,32
 9b8:	e010                	sd	a2,0(s0)
 9ba:	e414                	sd	a3,8(s0)
 9bc:	e818                	sd	a4,16(s0)
 9be:	ec1c                	sd	a5,24(s0)
 9c0:	03043023          	sd	a6,32(s0)
 9c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9cc:	8622                	mv	a2,s0
 9ce:	00000097          	auipc	ra,0x0
 9d2:	e04080e7          	jalr	-508(ra) # 7d2 <vprintf>
}
 9d6:	60e2                	ld	ra,24(sp)
 9d8:	6442                	ld	s0,16(sp)
 9da:	6161                	addi	sp,sp,80
 9dc:	8082                	ret

00000000000009de <printf>:

void
printf(const char *fmt, ...)
{
 9de:	711d                	addi	sp,sp,-96
 9e0:	ec06                	sd	ra,24(sp)
 9e2:	e822                	sd	s0,16(sp)
 9e4:	1000                	addi	s0,sp,32
 9e6:	e40c                	sd	a1,8(s0)
 9e8:	e810                	sd	a2,16(s0)
 9ea:	ec14                	sd	a3,24(s0)
 9ec:	f018                	sd	a4,32(s0)
 9ee:	f41c                	sd	a5,40(s0)
 9f0:	03043823          	sd	a6,48(s0)
 9f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9f8:	00840613          	addi	a2,s0,8
 9fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a00:	85aa                	mv	a1,a0
 a02:	4505                	li	a0,1
 a04:	00000097          	auipc	ra,0x0
 a08:	dce080e7          	jalr	-562(ra) # 7d2 <vprintf>
}
 a0c:	60e2                	ld	ra,24(sp)
 a0e:	6442                	ld	s0,16(sp)
 a10:	6125                	addi	sp,sp,96
 a12:	8082                	ret

0000000000000a14 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a14:	1141                	addi	sp,sp,-16
 a16:	e422                	sd	s0,8(sp)
 a18:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a1a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a1e:	00000797          	auipc	a5,0x0
 a22:	2a27b783          	ld	a5,674(a5) # cc0 <freep>
 a26:	a805                	j	a56 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a28:	4618                	lw	a4,8(a2)
 a2a:	9db9                	addw	a1,a1,a4
 a2c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a30:	6398                	ld	a4,0(a5)
 a32:	6318                	ld	a4,0(a4)
 a34:	fee53823          	sd	a4,-16(a0)
 a38:	a091                	j	a7c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a3a:	ff852703          	lw	a4,-8(a0)
 a3e:	9e39                	addw	a2,a2,a4
 a40:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 a42:	ff053703          	ld	a4,-16(a0)
 a46:	e398                	sd	a4,0(a5)
 a48:	a099                	j	a8e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a4a:	6398                	ld	a4,0(a5)
 a4c:	00e7e463          	bltu	a5,a4,a54 <free+0x40>
 a50:	00e6ea63          	bltu	a3,a4,a64 <free+0x50>
{
 a54:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a56:	fed7fae3          	bgeu	a5,a3,a4a <free+0x36>
 a5a:	6398                	ld	a4,0(a5)
 a5c:	00e6e463          	bltu	a3,a4,a64 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a60:	fee7eae3          	bltu	a5,a4,a54 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a64:	ff852583          	lw	a1,-8(a0)
 a68:	6390                	ld	a2,0(a5)
 a6a:	02059713          	slli	a4,a1,0x20
 a6e:	9301                	srli	a4,a4,0x20
 a70:	0712                	slli	a4,a4,0x4
 a72:	9736                	add	a4,a4,a3
 a74:	fae60ae3          	beq	a2,a4,a28 <free+0x14>
    bp->s.ptr = p->s.ptr;
 a78:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a7c:	4790                	lw	a2,8(a5)
 a7e:	02061713          	slli	a4,a2,0x20
 a82:	9301                	srli	a4,a4,0x20
 a84:	0712                	slli	a4,a4,0x4
 a86:	973e                	add	a4,a4,a5
 a88:	fae689e3          	beq	a3,a4,a3a <free+0x26>
  } else
    p->s.ptr = bp;
 a8c:	e394                	sd	a3,0(a5)
  freep = p;
 a8e:	00000717          	auipc	a4,0x0
 a92:	22f73923          	sd	a5,562(a4) # cc0 <freep>
}
 a96:	6422                	ld	s0,8(sp)
 a98:	0141                	addi	sp,sp,16
 a9a:	8082                	ret

0000000000000a9c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a9c:	7139                	addi	sp,sp,-64
 a9e:	fc06                	sd	ra,56(sp)
 aa0:	f822                	sd	s0,48(sp)
 aa2:	f426                	sd	s1,40(sp)
 aa4:	f04a                	sd	s2,32(sp)
 aa6:	ec4e                	sd	s3,24(sp)
 aa8:	e852                	sd	s4,16(sp)
 aaa:	e456                	sd	s5,8(sp)
 aac:	e05a                	sd	s6,0(sp)
 aae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ab0:	02051493          	slli	s1,a0,0x20
 ab4:	9081                	srli	s1,s1,0x20
 ab6:	04bd                	addi	s1,s1,15
 ab8:	8091                	srli	s1,s1,0x4
 aba:	0014899b          	addiw	s3,s1,1
 abe:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 ac0:	00000517          	auipc	a0,0x0
 ac4:	20053503          	ld	a0,512(a0) # cc0 <freep>
 ac8:	c515                	beqz	a0,af4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 acc:	4798                	lw	a4,8(a5)
 ace:	02977f63          	bgeu	a4,s1,b0c <malloc+0x70>
 ad2:	8a4e                	mv	s4,s3
 ad4:	0009871b          	sext.w	a4,s3
 ad8:	6685                	lui	a3,0x1
 ada:	00d77363          	bgeu	a4,a3,ae0 <malloc+0x44>
 ade:	6a05                	lui	s4,0x1
 ae0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ae4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ae8:	00000917          	auipc	s2,0x0
 aec:	1d890913          	addi	s2,s2,472 # cc0 <freep>
  if(p == (char*)-1)
 af0:	5afd                	li	s5,-1
 af2:	a88d                	j	b64 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 af4:	00008797          	auipc	a5,0x8
 af8:	1e478793          	addi	a5,a5,484 # 8cd8 <base>
 afc:	00000717          	auipc	a4,0x0
 b00:	1cf73223          	sd	a5,452(a4) # cc0 <freep>
 b04:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b06:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b0a:	b7e1                	j	ad2 <malloc+0x36>
      if(p->s.size == nunits)
 b0c:	02e48b63          	beq	s1,a4,b42 <malloc+0xa6>
        p->s.size -= nunits;
 b10:	4137073b          	subw	a4,a4,s3
 b14:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b16:	1702                	slli	a4,a4,0x20
 b18:	9301                	srli	a4,a4,0x20
 b1a:	0712                	slli	a4,a4,0x4
 b1c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b1e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b22:	00000717          	auipc	a4,0x0
 b26:	18a73f23          	sd	a0,414(a4) # cc0 <freep>
      return (void*)(p + 1);
 b2a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b2e:	70e2                	ld	ra,56(sp)
 b30:	7442                	ld	s0,48(sp)
 b32:	74a2                	ld	s1,40(sp)
 b34:	7902                	ld	s2,32(sp)
 b36:	69e2                	ld	s3,24(sp)
 b38:	6a42                	ld	s4,16(sp)
 b3a:	6aa2                	ld	s5,8(sp)
 b3c:	6b02                	ld	s6,0(sp)
 b3e:	6121                	addi	sp,sp,64
 b40:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b42:	6398                	ld	a4,0(a5)
 b44:	e118                	sd	a4,0(a0)
 b46:	bff1                	j	b22 <malloc+0x86>
  hp->s.size = nu;
 b48:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b4c:	0541                	addi	a0,a0,16
 b4e:	00000097          	auipc	ra,0x0
 b52:	ec6080e7          	jalr	-314(ra) # a14 <free>
  return freep;
 b56:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b5a:	d971                	beqz	a0,b2e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b5c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b5e:	4798                	lw	a4,8(a5)
 b60:	fa9776e3          	bgeu	a4,s1,b0c <malloc+0x70>
    if(p == freep)
 b64:	00093703          	ld	a4,0(s2)
 b68:	853e                	mv	a0,a5
 b6a:	fef719e3          	bne	a4,a5,b5c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b6e:	8552                	mv	a0,s4
 b70:	00000097          	auipc	ra,0x0
 b74:	b76080e7          	jalr	-1162(ra) # 6e6 <sbrk>
  if(p == (char*)-1)
 b78:	fd5518e3          	bne	a0,s5,b48 <malloc+0xac>
        return 0;
 b7c:	4501                	li	a0,0
 b7e:	bf45                	j	b2e <malloc+0x92>
