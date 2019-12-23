
user/_testsh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <rand>:

// return a random integer.
// from Wikipedia, linear congruential generator, glibc's constants.
unsigned int
rand()
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
  unsigned int a = 1103515245;
  unsigned int c = 12345;
  unsigned int m = (1 << 31);
  seed = (a * seed + c) % m;
       6:	00002717          	auipc	a4,0x2
       a:	87e70713          	addi	a4,a4,-1922 # 1884 <seed>
       e:	4308                	lw	a0,0(a4)
      10:	41c657b7          	lui	a5,0x41c65
      14:	e6d7879b          	addiw	a5,a5,-403
      18:	02f5053b          	mulw	a0,a0,a5
      1c:	678d                	lui	a5,0x3
      1e:	0397879b          	addiw	a5,a5,57
      22:	9d3d                	addw	a0,a0,a5
      24:	1506                	slli	a0,a0,0x21
      26:	9105                	srli	a0,a0,0x21
      28:	c308                	sw	a0,0(a4)
  return seed;
}
      2a:	6422                	ld	s0,8(sp)
      2c:	0141                	addi	sp,sp,16
      2e:	8082                	ret

0000000000000030 <randstring>:

// generate a random string of the indicated length.
char *
randstring(char *buf, int n)
{
      30:	7139                	addi	sp,sp,-64
      32:	fc06                	sd	ra,56(sp)
      34:	f822                	sd	s0,48(sp)
      36:	f426                	sd	s1,40(sp)
      38:	f04a                	sd	s2,32(sp)
      3a:	ec4e                	sd	s3,24(sp)
      3c:	e852                	sd	s4,16(sp)
      3e:	e456                	sd	s5,8(sp)
      40:	e05a                	sd	s6,0(sp)
      42:	0080                	addi	s0,sp,64
      44:	8a2a                	mv	s4,a0
      46:	89ae                	mv	s3,a1
  for(int i = 0; i < n-1; i++)
      48:	4785                	li	a5,1
      4a:	02b7df63          	bge	a5,a1,88 <randstring+0x58>
      4e:	84aa                	mv	s1,a0
      50:	00150913          	addi	s2,a0,1
      54:	ffe5879b          	addiw	a5,a1,-2
      58:	1782                	slli	a5,a5,0x20
      5a:	9381                	srli	a5,a5,0x20
      5c:	993e                	add	s2,s2,a5
    buf[i] = "abcdefghijklmnopqrstuvwxyz"[rand() % 26];
      5e:	00001b17          	auipc	s6,0x1
      62:	3f2b0b13          	addi	s6,s6,1010 # 1450 <malloc+0xe4>
      66:	4ae9                	li	s5,26
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <rand>
      70:	035577bb          	remuw	a5,a0,s5
      74:	1782                	slli	a5,a5,0x20
      76:	9381                	srli	a5,a5,0x20
      78:	97da                	add	a5,a5,s6
      7a:	0007c783          	lbu	a5,0(a5) # 3000 <__global_pointer$+0xf7f>
      7e:	00f48023          	sb	a5,0(s1)
  for(int i = 0; i < n-1; i++)
      82:	0485                	addi	s1,s1,1
      84:	ff2492e3          	bne	s1,s2,68 <randstring+0x38>
  buf[n-1] = '\0';
      88:	99d2                	add	s3,s3,s4
      8a:	fe098fa3          	sb	zero,-1(s3)
  return buf;
}
      8e:	8552                	mv	a0,s4
      90:	70e2                	ld	ra,56(sp)
      92:	7442                	ld	s0,48(sp)
      94:	74a2                	ld	s1,40(sp)
      96:	7902                	ld	s2,32(sp)
      98:	69e2                	ld	s3,24(sp)
      9a:	6a42                	ld	s4,16(sp)
      9c:	6aa2                	ld	s5,8(sp)
      9e:	6b02                	ld	s6,0(sp)
      a0:	6121                	addi	sp,sp,64
      a2:	8082                	ret

00000000000000a4 <writefile>:

// create a file with the indicated content.
void
writefile(char *name, char *data)
{
      a4:	7179                	addi	sp,sp,-48
      a6:	f406                	sd	ra,40(sp)
      a8:	f022                	sd	s0,32(sp)
      aa:	ec26                	sd	s1,24(sp)
      ac:	e84a                	sd	s2,16(sp)
      ae:	e44e                	sd	s3,8(sp)
      b0:	1800                	addi	s0,sp,48
      b2:	89aa                	mv	s3,a0
      b4:	892e                	mv	s2,a1
  unlink(name); // since no truncation
      b6:	00001097          	auipc	ra,0x1
      ba:	ec8080e7          	jalr	-312(ra) # f7e <unlink>
  int fd = open(name, O_CREATE|O_WRONLY);
      be:	20100593          	li	a1,513
      c2:	854e                	mv	a0,s3
      c4:	00001097          	auipc	ra,0x1
      c8:	eaa080e7          	jalr	-342(ra) # f6e <open>
  if(fd < 0){
      cc:	04054663          	bltz	a0,118 <writefile+0x74>
      d0:	84aa                	mv	s1,a0
    fprintf(2, "testsh: could not write %s\n", name);
    exit(-1);
  }
  if(write(fd, data, strlen(data)) != strlen(data)){
      d2:	854a                	mv	a0,s2
      d4:	00001097          	auipc	ra,0x1
      d8:	c2c080e7          	jalr	-980(ra) # d00 <strlen>
      dc:	0005061b          	sext.w	a2,a0
      e0:	85ca                	mv	a1,s2
      e2:	8526                	mv	a0,s1
      e4:	00001097          	auipc	ra,0x1
      e8:	e6a080e7          	jalr	-406(ra) # f4e <write>
      ec:	89aa                	mv	s3,a0
      ee:	854a                	mv	a0,s2
      f0:	00001097          	auipc	ra,0x1
      f4:	c10080e7          	jalr	-1008(ra) # d00 <strlen>
      f8:	2501                	sext.w	a0,a0
      fa:	2981                	sext.w	s3,s3
      fc:	02a99d63          	bne	s3,a0,136 <writefile+0x92>
    fprintf(2, "testsh: write failed\n");
    exit(-1);
  }
  close(fd);
     100:	8526                	mv	a0,s1
     102:	00001097          	auipc	ra,0x1
     106:	e54080e7          	jalr	-428(ra) # f56 <close>
}
     10a:	70a2                	ld	ra,40(sp)
     10c:	7402                	ld	s0,32(sp)
     10e:	64e2                	ld	s1,24(sp)
     110:	6942                	ld	s2,16(sp)
     112:	69a2                	ld	s3,8(sp)
     114:	6145                	addi	sp,sp,48
     116:	8082                	ret
    fprintf(2, "testsh: could not write %s\n", name);
     118:	864e                	mv	a2,s3
     11a:	00001597          	auipc	a1,0x1
     11e:	35658593          	addi	a1,a1,854 # 1470 <malloc+0x104>
     122:	4509                	li	a0,2
     124:	00001097          	auipc	ra,0x1
     128:	15c080e7          	jalr	348(ra) # 1280 <fprintf>
    exit(-1);
     12c:	557d                	li	a0,-1
     12e:	00001097          	auipc	ra,0x1
     132:	e00080e7          	jalr	-512(ra) # f2e <exit>
    fprintf(2, "testsh: write failed\n");
     136:	00001597          	auipc	a1,0x1
     13a:	35a58593          	addi	a1,a1,858 # 1490 <malloc+0x124>
     13e:	4509                	li	a0,2
     140:	00001097          	auipc	ra,0x1
     144:	140080e7          	jalr	320(ra) # 1280 <fprintf>
    exit(-1);
     148:	557d                	li	a0,-1
     14a:	00001097          	auipc	ra,0x1
     14e:	de4080e7          	jalr	-540(ra) # f2e <exit>

0000000000000152 <readfile>:

// return the content of a file.
void
readfile(char *name, char *data, int max)
{
     152:	7179                	addi	sp,sp,-48
     154:	f406                	sd	ra,40(sp)
     156:	f022                	sd	s0,32(sp)
     158:	ec26                	sd	s1,24(sp)
     15a:	e84a                	sd	s2,16(sp)
     15c:	e44e                	sd	s3,8(sp)
     15e:	e052                	sd	s4,0(sp)
     160:	1800                	addi	s0,sp,48
     162:	8a2a                	mv	s4,a0
     164:	84ae                	mv	s1,a1
     166:	89b2                	mv	s3,a2
  data[0] = '\0';
     168:	00058023          	sb	zero,0(a1)
  int fd = open(name, 0);
     16c:	4581                	li	a1,0
     16e:	00001097          	auipc	ra,0x1
     172:	e00080e7          	jalr	-512(ra) # f6e <open>
  if(fd < 0){
     176:	02054d63          	bltz	a0,1b0 <readfile+0x5e>
     17a:	892a                	mv	s2,a0
    fprintf(2, "testsh: open %s failed\n", name);
    return;
  }
  int n = read(fd, data, max-1);
     17c:	fff9861b          	addiw	a2,s3,-1
     180:	85a6                	mv	a1,s1
     182:	00001097          	auipc	ra,0x1
     186:	dc4080e7          	jalr	-572(ra) # f46 <read>
     18a:	89aa                	mv	s3,a0
  close(fd);
     18c:	854a                	mv	a0,s2
     18e:	00001097          	auipc	ra,0x1
     192:	dc8080e7          	jalr	-568(ra) # f56 <close>
  if(n < 0){
     196:	0209c863          	bltz	s3,1c6 <readfile+0x74>
    fprintf(2, "testsh: read %s failed\n", name);
    return;
  }
  data[n] = '\0';
     19a:	94ce                	add	s1,s1,s3
     19c:	00048023          	sb	zero,0(s1)
}
     1a0:	70a2                	ld	ra,40(sp)
     1a2:	7402                	ld	s0,32(sp)
     1a4:	64e2                	ld	s1,24(sp)
     1a6:	6942                	ld	s2,16(sp)
     1a8:	69a2                	ld	s3,8(sp)
     1aa:	6a02                	ld	s4,0(sp)
     1ac:	6145                	addi	sp,sp,48
     1ae:	8082                	ret
    fprintf(2, "testsh: open %s failed\n", name);
     1b0:	8652                	mv	a2,s4
     1b2:	00001597          	auipc	a1,0x1
     1b6:	2f658593          	addi	a1,a1,758 # 14a8 <malloc+0x13c>
     1ba:	4509                	li	a0,2
     1bc:	00001097          	auipc	ra,0x1
     1c0:	0c4080e7          	jalr	196(ra) # 1280 <fprintf>
    return;
     1c4:	bff1                	j	1a0 <readfile+0x4e>
    fprintf(2, "testsh: read %s failed\n", name);
     1c6:	8652                	mv	a2,s4
     1c8:	00001597          	auipc	a1,0x1
     1cc:	2f858593          	addi	a1,a1,760 # 14c0 <malloc+0x154>
     1d0:	4509                	li	a0,2
     1d2:	00001097          	auipc	ra,0x1
     1d6:	0ae080e7          	jalr	174(ra) # 1280 <fprintf>
    return;
     1da:	b7d9                	j	1a0 <readfile+0x4e>

00000000000001dc <strstr>:

// look for the small string in the big string;
// return the address in the big string, or 0.
char *
strstr(char *big, char *small)
{
     1dc:	1141                	addi	sp,sp,-16
     1de:	e422                	sd	s0,8(sp)
     1e0:	0800                	addi	s0,sp,16
  if(small[0] == '\0')
     1e2:	0005c883          	lbu	a7,0(a1)
     1e6:	02088b63          	beqz	a7,21c <strstr+0x40>
    return big;
  for(int i = 0; big[i]; i++){
     1ea:	00054783          	lbu	a5,0(a0)
     1ee:	eb89                	bnez	a5,200 <strstr+0x24>
    }
    if(small[j] == '\0'){
      return big + i;
    }
  }
  return 0;
     1f0:	4501                	li	a0,0
     1f2:	a02d                	j	21c <strstr+0x40>
    if(small[j] == '\0'){
     1f4:	c785                	beqz	a5,21c <strstr+0x40>
  for(int i = 0; big[i]; i++){
     1f6:	00180513          	addi	a0,a6,1
     1fa:	00184783          	lbu	a5,1(a6)
     1fe:	c395                	beqz	a5,222 <strstr+0x46>
    for(j = 0; small[j]; j++){
     200:	882a                	mv	a6,a0
     202:	00158693          	addi	a3,a1,1
{
     206:	872a                	mv	a4,a0
    for(j = 0; small[j]; j++){
     208:	87c6                	mv	a5,a7
      if(big[i+j] != small[j]){
     20a:	00074603          	lbu	a2,0(a4)
     20e:	fef613e3          	bne	a2,a5,1f4 <strstr+0x18>
    for(j = 0; small[j]; j++){
     212:	0006c783          	lbu	a5,0(a3)
     216:	0705                	addi	a4,a4,1
     218:	0685                	addi	a3,a3,1
     21a:	fbe5                	bnez	a5,20a <strstr+0x2e>
}
     21c:	6422                	ld	s0,8(sp)
     21e:	0141                	addi	sp,sp,16
     220:	8082                	ret
  return 0;
     222:	4501                	li	a0,0
     224:	bfe5                	j	21c <strstr+0x40>

0000000000000226 <one>:
// its input, collect the output, check that the
// output includes the expect argument.
// if tight = 1, don't allow much extraneous output.
int
one(char *cmd, char *expect, int tight)
{
     226:	710d                	addi	sp,sp,-352
     228:	ee86                	sd	ra,344(sp)
     22a:	eaa2                	sd	s0,336(sp)
     22c:	e6a6                	sd	s1,328(sp)
     22e:	e2ca                	sd	s2,320(sp)
     230:	fe4e                	sd	s3,312(sp)
     232:	1280                	addi	s0,sp,352
     234:	84aa                	mv	s1,a0
     236:	892e                	mv	s2,a1
     238:	89b2                	mv	s3,a2
  char infile[12], outfile[12];

  randstring(infile, sizeof(infile));
     23a:	45b1                	li	a1,12
     23c:	fc040513          	addi	a0,s0,-64
     240:	00000097          	auipc	ra,0x0
     244:	df0080e7          	jalr	-528(ra) # 30 <randstring>
  randstring(outfile, sizeof(outfile));
     248:	45b1                	li	a1,12
     24a:	fb040513          	addi	a0,s0,-80
     24e:	00000097          	auipc	ra,0x0
     252:	de2080e7          	jalr	-542(ra) # 30 <randstring>

  writefile(infile, cmd);
     256:	85a6                	mv	a1,s1
     258:	fc040513          	addi	a0,s0,-64
     25c:	00000097          	auipc	ra,0x0
     260:	e48080e7          	jalr	-440(ra) # a4 <writefile>
  unlink(outfile);
     264:	fb040513          	addi	a0,s0,-80
     268:	00001097          	auipc	ra,0x1
     26c:	d16080e7          	jalr	-746(ra) # f7e <unlink>

  int pid = fork();
     270:	00001097          	auipc	ra,0x1
     274:	cb6080e7          	jalr	-842(ra) # f26 <fork>
  if(pid < 0){
     278:	04054f63          	bltz	a0,2d6 <one+0xb0>
     27c:	84aa                	mv	s1,a0
    fprintf(2, "testsh: fork() failed\n");
    exit(-1);
  }

  if(pid == 0){
     27e:	e571                	bnez	a0,34a <one+0x124>
    close(0);
     280:	4501                	li	a0,0
     282:	00001097          	auipc	ra,0x1
     286:	cd4080e7          	jalr	-812(ra) # f56 <close>
    if(open(infile, 0) != 0){
     28a:	4581                	li	a1,0
     28c:	fc040513          	addi	a0,s0,-64
     290:	00001097          	auipc	ra,0x1
     294:	cde080e7          	jalr	-802(ra) # f6e <open>
     298:	ed29                	bnez	a0,2f2 <one+0xcc>
      fprintf(2, "testsh: child open != 0\n");
      exit(-1);
    }
    close(1);
     29a:	4505                	li	a0,1
     29c:	00001097          	auipc	ra,0x1
     2a0:	cba080e7          	jalr	-838(ra) # f56 <close>
    if(open(outfile, O_CREATE|O_WRONLY) != 1){
     2a4:	20100593          	li	a1,513
     2a8:	fb040513          	addi	a0,s0,-80
     2ac:	00001097          	auipc	ra,0x1
     2b0:	cc2080e7          	jalr	-830(ra) # f6e <open>
     2b4:	4785                	li	a5,1
     2b6:	04f50c63          	beq	a0,a5,30e <one+0xe8>
      fprintf(2, "testsh: child open != 1\n");
     2ba:	00001597          	auipc	a1,0x1
     2be:	25658593          	addi	a1,a1,598 # 1510 <malloc+0x1a4>
     2c2:	4509                	li	a0,2
     2c4:	00001097          	auipc	ra,0x1
     2c8:	fbc080e7          	jalr	-68(ra) # 1280 <fprintf>
      exit(-1);
     2cc:	557d                	li	a0,-1
     2ce:	00001097          	auipc	ra,0x1
     2d2:	c60080e7          	jalr	-928(ra) # f2e <exit>
    fprintf(2, "testsh: fork() failed\n");
     2d6:	00001597          	auipc	a1,0x1
     2da:	20258593          	addi	a1,a1,514 # 14d8 <malloc+0x16c>
     2de:	4509                	li	a0,2
     2e0:	00001097          	auipc	ra,0x1
     2e4:	fa0080e7          	jalr	-96(ra) # 1280 <fprintf>
    exit(-1);
     2e8:	557d                	li	a0,-1
     2ea:	00001097          	auipc	ra,0x1
     2ee:	c44080e7          	jalr	-956(ra) # f2e <exit>
      fprintf(2, "testsh: child open != 0\n");
     2f2:	00001597          	auipc	a1,0x1
     2f6:	1fe58593          	addi	a1,a1,510 # 14f0 <malloc+0x184>
     2fa:	4509                	li	a0,2
     2fc:	00001097          	auipc	ra,0x1
     300:	f84080e7          	jalr	-124(ra) # 1280 <fprintf>
      exit(-1);
     304:	557d                	li	a0,-1
     306:	00001097          	auipc	ra,0x1
     30a:	c28080e7          	jalr	-984(ra) # f2e <exit>
    }
    char *argv[2];
    argv[0] = shname;
     30e:	00001497          	auipc	s1,0x1
     312:	57a48493          	addi	s1,s1,1402 # 1888 <_edata>
     316:	6088                	ld	a0,0(s1)
     318:	eaa43023          	sd	a0,-352(s0)
    argv[1] = 0;
     31c:	ea043423          	sd	zero,-344(s0)
    exec(shname, argv);
     320:	ea040593          	addi	a1,s0,-352
     324:	00001097          	auipc	ra,0x1
     328:	c42080e7          	jalr	-958(ra) # f66 <exec>
    fprintf(2, "testsh: exec %s failed\n", shname);
     32c:	6090                	ld	a2,0(s1)
     32e:	00001597          	auipc	a1,0x1
     332:	20258593          	addi	a1,a1,514 # 1530 <malloc+0x1c4>
     336:	4509                	li	a0,2
     338:	00001097          	auipc	ra,0x1
     33c:	f48080e7          	jalr	-184(ra) # 1280 <fprintf>
    exit(-1);
     340:	557d                	li	a0,-1
     342:	00001097          	auipc	ra,0x1
     346:	bec080e7          	jalr	-1044(ra) # f2e <exit>
  }

  if(wait(0) != pid){
     34a:	4501                	li	a0,0
     34c:	00001097          	auipc	ra,0x1
     350:	bea080e7          	jalr	-1046(ra) # f36 <wait>
     354:	04951c63          	bne	a0,s1,3ac <one+0x186>
    fprintf(2, "testsh: unexpected wait() return\n");
    exit(-1);
  }
  unlink(infile);
     358:	fc040513          	addi	a0,s0,-64
     35c:	00001097          	auipc	ra,0x1
     360:	c22080e7          	jalr	-990(ra) # f7e <unlink>

  char out[256];
  readfile(outfile, out, sizeof(out));
     364:	10000613          	li	a2,256
     368:	eb040593          	addi	a1,s0,-336
     36c:	fb040513          	addi	a0,s0,-80
     370:	00000097          	auipc	ra,0x0
     374:	de2080e7          	jalr	-542(ra) # 152 <readfile>
  unlink(outfile);
     378:	fb040513          	addi	a0,s0,-80
     37c:	00001097          	auipc	ra,0x1
     380:	c02080e7          	jalr	-1022(ra) # f7e <unlink>

  if(strstr(out, expect) != 0){
     384:	85ca                	mv	a1,s2
     386:	eb040513          	addi	a0,s0,-336
     38a:	00000097          	auipc	ra,0x0
     38e:	e52080e7          	jalr	-430(ra) # 1dc <strstr>
      fprintf(2, "testsh: saw expected output, but too much else as well\n");
      return 0; // fail
    }
    return 1; // pass
  }
  return 0; // fail
     392:	4781                	li	a5,0
  if(strstr(out, expect) != 0){
     394:	c501                	beqz	a0,39c <one+0x176>
    return 1; // pass
     396:	4785                	li	a5,1
    if(tight && strlen(out) > strlen(expect) + 10){
     398:	02099863          	bnez	s3,3c8 <one+0x1a2>
}
     39c:	853e                	mv	a0,a5
     39e:	60f6                	ld	ra,344(sp)
     3a0:	6456                	ld	s0,336(sp)
     3a2:	64b6                	ld	s1,328(sp)
     3a4:	6916                	ld	s2,320(sp)
     3a6:	79f2                	ld	s3,312(sp)
     3a8:	6135                	addi	sp,sp,352
     3aa:	8082                	ret
    fprintf(2, "testsh: unexpected wait() return\n");
     3ac:	00001597          	auipc	a1,0x1
     3b0:	19c58593          	addi	a1,a1,412 # 1548 <malloc+0x1dc>
     3b4:	4509                	li	a0,2
     3b6:	00001097          	auipc	ra,0x1
     3ba:	eca080e7          	jalr	-310(ra) # 1280 <fprintf>
    exit(-1);
     3be:	557d                	li	a0,-1
     3c0:	00001097          	auipc	ra,0x1
     3c4:	b6e080e7          	jalr	-1170(ra) # f2e <exit>
    if(tight && strlen(out) > strlen(expect) + 10){
     3c8:	eb040513          	addi	a0,s0,-336
     3cc:	00001097          	auipc	ra,0x1
     3d0:	934080e7          	jalr	-1740(ra) # d00 <strlen>
     3d4:	0005049b          	sext.w	s1,a0
     3d8:	854a                	mv	a0,s2
     3da:	00001097          	auipc	ra,0x1
     3de:	926080e7          	jalr	-1754(ra) # d00 <strlen>
     3e2:	2529                	addiw	a0,a0,10
    return 1; // pass
     3e4:	4785                	li	a5,1
    if(tight && strlen(out) > strlen(expect) + 10){
     3e6:	fa957be3          	bgeu	a0,s1,39c <one+0x176>
      fprintf(2, "testsh: saw expected output, but too much else as well\n");
     3ea:	00001597          	auipc	a1,0x1
     3ee:	18658593          	addi	a1,a1,390 # 1570 <malloc+0x204>
     3f2:	4509                	li	a0,2
     3f4:	00001097          	auipc	ra,0x1
     3f8:	e8c080e7          	jalr	-372(ra) # 1280 <fprintf>
      return 0; // fail
     3fc:	4781                	li	a5,0
     3fe:	bf79                	j	39c <one+0x176>

0000000000000400 <t1>:

// test a command with arguments.
void
t1(int *ok)
{
     400:	1101                	addi	sp,sp,-32
     402:	ec06                	sd	ra,24(sp)
     404:	e822                	sd	s0,16(sp)
     406:	e426                	sd	s1,8(sp)
     408:	1000                	addi	s0,sp,32
     40a:	84aa                	mv	s1,a0
  printf("simple echo: ");
     40c:	00001517          	auipc	a0,0x1
     410:	19c50513          	addi	a0,a0,412 # 15a8 <malloc+0x23c>
     414:	00001097          	auipc	ra,0x1
     418:	e9a080e7          	jalr	-358(ra) # 12ae <printf>
  if(one("echo hello goodbye\n", "hello goodbye", 1) == 0){
     41c:	4605                	li	a2,1
     41e:	00001597          	auipc	a1,0x1
     422:	19a58593          	addi	a1,a1,410 # 15b8 <malloc+0x24c>
     426:	00001517          	auipc	a0,0x1
     42a:	1a250513          	addi	a0,a0,418 # 15c8 <malloc+0x25c>
     42e:	00000097          	auipc	ra,0x0
     432:	df8080e7          	jalr	-520(ra) # 226 <one>
     436:	e105                	bnez	a0,456 <t1+0x56>
    printf("FAIL\n");
     438:	00001517          	auipc	a0,0x1
     43c:	1a850513          	addi	a0,a0,424 # 15e0 <malloc+0x274>
     440:	00001097          	auipc	ra,0x1
     444:	e6e080e7          	jalr	-402(ra) # 12ae <printf>
    *ok = 0;
     448:	0004a023          	sw	zero,0(s1)
  } else {
    printf("PASS\n");
  }
}
     44c:	60e2                	ld	ra,24(sp)
     44e:	6442                	ld	s0,16(sp)
     450:	64a2                	ld	s1,8(sp)
     452:	6105                	addi	sp,sp,32
     454:	8082                	ret
    printf("PASS\n");
     456:	00001517          	auipc	a0,0x1
     45a:	19250513          	addi	a0,a0,402 # 15e8 <malloc+0x27c>
     45e:	00001097          	auipc	ra,0x1
     462:	e50080e7          	jalr	-432(ra) # 12ae <printf>
}
     466:	b7dd                	j	44c <t1+0x4c>

0000000000000468 <t2>:

// test a command with arguments.
void
t2(int *ok)
{
     468:	1101                	addi	sp,sp,-32
     46a:	ec06                	sd	ra,24(sp)
     46c:	e822                	sd	s0,16(sp)
     46e:	e426                	sd	s1,8(sp)
     470:	1000                	addi	s0,sp,32
     472:	84aa                	mv	s1,a0
  printf("simple grep: ");
     474:	00001517          	auipc	a0,0x1
     478:	17c50513          	addi	a0,a0,380 # 15f0 <malloc+0x284>
     47c:	00001097          	auipc	ra,0x1
     480:	e32080e7          	jalr	-462(ra) # 12ae <printf>
  if(one("grep constitute README\n", "The code in the files that constitute xv6 is", 1) == 0){
     484:	4605                	li	a2,1
     486:	00001597          	auipc	a1,0x1
     48a:	17a58593          	addi	a1,a1,378 # 1600 <malloc+0x294>
     48e:	00001517          	auipc	a0,0x1
     492:	1a250513          	addi	a0,a0,418 # 1630 <malloc+0x2c4>
     496:	00000097          	auipc	ra,0x0
     49a:	d90080e7          	jalr	-624(ra) # 226 <one>
     49e:	e105                	bnez	a0,4be <t2+0x56>
    printf("FAIL\n");
     4a0:	00001517          	auipc	a0,0x1
     4a4:	14050513          	addi	a0,a0,320 # 15e0 <malloc+0x274>
     4a8:	00001097          	auipc	ra,0x1
     4ac:	e06080e7          	jalr	-506(ra) # 12ae <printf>
    *ok = 0;
     4b0:	0004a023          	sw	zero,0(s1)
  } else {
    printf("PASS\n");
  }
}
     4b4:	60e2                	ld	ra,24(sp)
     4b6:	6442                	ld	s0,16(sp)
     4b8:	64a2                	ld	s1,8(sp)
     4ba:	6105                	addi	sp,sp,32
     4bc:	8082                	ret
    printf("PASS\n");
     4be:	00001517          	auipc	a0,0x1
     4c2:	12a50513          	addi	a0,a0,298 # 15e8 <malloc+0x27c>
     4c6:	00001097          	auipc	ra,0x1
     4ca:	de8080e7          	jalr	-536(ra) # 12ae <printf>
}
     4ce:	b7dd                	j	4b4 <t2+0x4c>

00000000000004d0 <t3>:

// test a command, then a newline, then another command.
void
t3(int *ok)
{
     4d0:	1101                	addi	sp,sp,-32
     4d2:	ec06                	sd	ra,24(sp)
     4d4:	e822                	sd	s0,16(sp)
     4d6:	e426                	sd	s1,8(sp)
     4d8:	1000                	addi	s0,sp,32
     4da:	84aa                	mv	s1,a0
  printf("two commands: ");
     4dc:	00001517          	auipc	a0,0x1
     4e0:	16c50513          	addi	a0,a0,364 # 1648 <malloc+0x2dc>
     4e4:	00001097          	auipc	ra,0x1
     4e8:	dca080e7          	jalr	-566(ra) # 12ae <printf>
  if(one("echo x\necho goodbye\n", "goodbye", 1) == 0){
     4ec:	4605                	li	a2,1
     4ee:	00001597          	auipc	a1,0x1
     4f2:	16a58593          	addi	a1,a1,362 # 1658 <malloc+0x2ec>
     4f6:	00001517          	auipc	a0,0x1
     4fa:	16a50513          	addi	a0,a0,362 # 1660 <malloc+0x2f4>
     4fe:	00000097          	auipc	ra,0x0
     502:	d28080e7          	jalr	-728(ra) # 226 <one>
     506:	e105                	bnez	a0,526 <t3+0x56>
    printf("FAIL\n");
     508:	00001517          	auipc	a0,0x1
     50c:	0d850513          	addi	a0,a0,216 # 15e0 <malloc+0x274>
     510:	00001097          	auipc	ra,0x1
     514:	d9e080e7          	jalr	-610(ra) # 12ae <printf>
    *ok = 0;
     518:	0004a023          	sw	zero,0(s1)
  } else {
    printf("PASS\n");
  }
}
     51c:	60e2                	ld	ra,24(sp)
     51e:	6442                	ld	s0,16(sp)
     520:	64a2                	ld	s1,8(sp)
     522:	6105                	addi	sp,sp,32
     524:	8082                	ret
    printf("PASS\n");
     526:	00001517          	auipc	a0,0x1
     52a:	0c250513          	addi	a0,a0,194 # 15e8 <malloc+0x27c>
     52e:	00001097          	auipc	ra,0x1
     532:	d80080e7          	jalr	-640(ra) # 12ae <printf>
}
     536:	b7dd                	j	51c <t3+0x4c>

0000000000000538 <t4>:

// test output redirection: echo xxx > file
void
t4(int *ok)
{
     538:	7131                	addi	sp,sp,-192
     53a:	fd06                	sd	ra,184(sp)
     53c:	f922                	sd	s0,176(sp)
     53e:	f526                	sd	s1,168(sp)
     540:	0180                	addi	s0,sp,192
     542:	84aa                	mv	s1,a0
  printf("output redirection: ");
     544:	00001517          	auipc	a0,0x1
     548:	13450513          	addi	a0,a0,308 # 1678 <malloc+0x30c>
     54c:	00001097          	auipc	ra,0x1
     550:	d62080e7          	jalr	-670(ra) # 12ae <printf>

  char file[16];
  randstring(file, 12);
     554:	45b1                	li	a1,12
     556:	fd040513          	addi	a0,s0,-48
     55a:	00000097          	auipc	ra,0x0
     55e:	ad6080e7          	jalr	-1322(ra) # 30 <randstring>

  char data[16];
  randstring(data, 12);
     562:	45b1                	li	a1,12
     564:	fc040513          	addi	a0,s0,-64
     568:	00000097          	auipc	ra,0x0
     56c:	ac8080e7          	jalr	-1336(ra) # 30 <randstring>

  char cmd[64];
  strcpy(cmd, "echo ");
     570:	00001597          	auipc	a1,0x1
     574:	12058593          	addi	a1,a1,288 # 1690 <malloc+0x324>
     578:	f8040513          	addi	a0,s0,-128
     57c:	00000097          	auipc	ra,0x0
     580:	73c080e7          	jalr	1852(ra) # cb8 <strcpy>
  strcpy(cmd+strlen(cmd), data);
     584:	f8040513          	addi	a0,s0,-128
     588:	00000097          	auipc	ra,0x0
     58c:	778080e7          	jalr	1912(ra) # d00 <strlen>
     590:	1502                	slli	a0,a0,0x20
     592:	9101                	srli	a0,a0,0x20
     594:	fc040593          	addi	a1,s0,-64
     598:	f8040793          	addi	a5,s0,-128
     59c:	953e                	add	a0,a0,a5
     59e:	00000097          	auipc	ra,0x0
     5a2:	71a080e7          	jalr	1818(ra) # cb8 <strcpy>
  strcpy(cmd+strlen(cmd), " > ");
     5a6:	f8040513          	addi	a0,s0,-128
     5aa:	00000097          	auipc	ra,0x0
     5ae:	756080e7          	jalr	1878(ra) # d00 <strlen>
     5b2:	1502                	slli	a0,a0,0x20
     5b4:	9101                	srli	a0,a0,0x20
     5b6:	00001597          	auipc	a1,0x1
     5ba:	0e258593          	addi	a1,a1,226 # 1698 <malloc+0x32c>
     5be:	f8040793          	addi	a5,s0,-128
     5c2:	953e                	add	a0,a0,a5
     5c4:	00000097          	auipc	ra,0x0
     5c8:	6f4080e7          	jalr	1780(ra) # cb8 <strcpy>
  strcpy(cmd+strlen(cmd), file);
     5cc:	f8040513          	addi	a0,s0,-128
     5d0:	00000097          	auipc	ra,0x0
     5d4:	730080e7          	jalr	1840(ra) # d00 <strlen>
     5d8:	1502                	slli	a0,a0,0x20
     5da:	9101                	srli	a0,a0,0x20
     5dc:	fd040593          	addi	a1,s0,-48
     5e0:	f8040793          	addi	a5,s0,-128
     5e4:	953e                	add	a0,a0,a5
     5e6:	00000097          	auipc	ra,0x0
     5ea:	6d2080e7          	jalr	1746(ra) # cb8 <strcpy>
  strcpy(cmd+strlen(cmd), "\n");
     5ee:	f8040513          	addi	a0,s0,-128
     5f2:	00000097          	auipc	ra,0x0
     5f6:	70e080e7          	jalr	1806(ra) # d00 <strlen>
     5fa:	1502                	slli	a0,a0,0x20
     5fc:	9101                	srli	a0,a0,0x20
     5fe:	00001597          	auipc	a1,0x1
     602:	f6a58593          	addi	a1,a1,-150 # 1568 <malloc+0x1fc>
     606:	f8040793          	addi	a5,s0,-128
     60a:	953e                	add	a0,a0,a5
     60c:	00000097          	auipc	ra,0x0
     610:	6ac080e7          	jalr	1708(ra) # cb8 <strcpy>

  if(one(cmd, "", 1) == 0){
     614:	4605                	li	a2,1
     616:	00001597          	auipc	a1,0x1
     61a:	ef258593          	addi	a1,a1,-270 # 1508 <malloc+0x19c>
     61e:	f8040513          	addi	a0,s0,-128
     622:	00000097          	auipc	ra,0x0
     626:	c04080e7          	jalr	-1020(ra) # 226 <one>
     62a:	e515                	bnez	a0,656 <t4+0x11e>
    printf("FAIL\n");
     62c:	00001517          	auipc	a0,0x1
     630:	fb450513          	addi	a0,a0,-76 # 15e0 <malloc+0x274>
     634:	00001097          	auipc	ra,0x1
     638:	c7a080e7          	jalr	-902(ra) # 12ae <printf>
    *ok = 0;
     63c:	0004a023          	sw	zero,0(s1)
    } else {
      printf("PASS\n");
    }
  }

  unlink(file);
     640:	fd040513          	addi	a0,s0,-48
     644:	00001097          	auipc	ra,0x1
     648:	93a080e7          	jalr	-1734(ra) # f7e <unlink>
}
     64c:	70ea                	ld	ra,184(sp)
     64e:	744a                	ld	s0,176(sp)
     650:	74aa                	ld	s1,168(sp)
     652:	6129                	addi	sp,sp,192
     654:	8082                	ret
    readfile(file, buf, sizeof(buf));
     656:	04000613          	li	a2,64
     65a:	f4040593          	addi	a1,s0,-192
     65e:	fd040513          	addi	a0,s0,-48
     662:	00000097          	auipc	ra,0x0
     666:	af0080e7          	jalr	-1296(ra) # 152 <readfile>
    if(strstr(buf, data) == 0){
     66a:	fc040593          	addi	a1,s0,-64
     66e:	f4040513          	addi	a0,s0,-192
     672:	00000097          	auipc	ra,0x0
     676:	b6a080e7          	jalr	-1174(ra) # 1dc <strstr>
     67a:	c911                	beqz	a0,68e <t4+0x156>
      printf("PASS\n");
     67c:	00001517          	auipc	a0,0x1
     680:	f6c50513          	addi	a0,a0,-148 # 15e8 <malloc+0x27c>
     684:	00001097          	auipc	ra,0x1
     688:	c2a080e7          	jalr	-982(ra) # 12ae <printf>
     68c:	bf55                	j	640 <t4+0x108>
      printf("FAIL\n");
     68e:	00001517          	auipc	a0,0x1
     692:	f5250513          	addi	a0,a0,-174 # 15e0 <malloc+0x274>
     696:	00001097          	auipc	ra,0x1
     69a:	c18080e7          	jalr	-1000(ra) # 12ae <printf>
      *ok = 0;
     69e:	0004a023          	sw	zero,0(s1)
     6a2:	bf79                	j	640 <t4+0x108>

00000000000006a4 <t5>:

// test input redirection: cat < file
void
t5(int *ok)
{
     6a4:	7119                	addi	sp,sp,-128
     6a6:	fc86                	sd	ra,120(sp)
     6a8:	f8a2                	sd	s0,112(sp)
     6aa:	f4a6                	sd	s1,104(sp)
     6ac:	0100                	addi	s0,sp,128
     6ae:	84aa                	mv	s1,a0
  printf("input redirection: ");
     6b0:	00001517          	auipc	a0,0x1
     6b4:	ff050513          	addi	a0,a0,-16 # 16a0 <malloc+0x334>
     6b8:	00001097          	auipc	ra,0x1
     6bc:	bf6080e7          	jalr	-1034(ra) # 12ae <printf>

  char file[32];
  randstring(file, 12);
     6c0:	45b1                	li	a1,12
     6c2:	fc040513          	addi	a0,s0,-64
     6c6:	00000097          	auipc	ra,0x0
     6ca:	96a080e7          	jalr	-1686(ra) # 30 <randstring>

  char data[32];
  randstring(data, 12);
     6ce:	45b1                	li	a1,12
     6d0:	fa040513          	addi	a0,s0,-96
     6d4:	00000097          	auipc	ra,0x0
     6d8:	95c080e7          	jalr	-1700(ra) # 30 <randstring>
  writefile(file, data);
     6dc:	fa040593          	addi	a1,s0,-96
     6e0:	fc040513          	addi	a0,s0,-64
     6e4:	00000097          	auipc	ra,0x0
     6e8:	9c0080e7          	jalr	-1600(ra) # a4 <writefile>

  char cmd[32];
  strcpy(cmd, "cat < ");
     6ec:	00001597          	auipc	a1,0x1
     6f0:	fcc58593          	addi	a1,a1,-52 # 16b8 <malloc+0x34c>
     6f4:	f8040513          	addi	a0,s0,-128
     6f8:	00000097          	auipc	ra,0x0
     6fc:	5c0080e7          	jalr	1472(ra) # cb8 <strcpy>
  strcpy(cmd+strlen(cmd), file);
     700:	f8040513          	addi	a0,s0,-128
     704:	00000097          	auipc	ra,0x0
     708:	5fc080e7          	jalr	1532(ra) # d00 <strlen>
     70c:	1502                	slli	a0,a0,0x20
     70e:	9101                	srli	a0,a0,0x20
     710:	fc040593          	addi	a1,s0,-64
     714:	f8040793          	addi	a5,s0,-128
     718:	953e                	add	a0,a0,a5
     71a:	00000097          	auipc	ra,0x0
     71e:	59e080e7          	jalr	1438(ra) # cb8 <strcpy>
  strcpy(cmd+strlen(cmd), "\n");
     722:	f8040513          	addi	a0,s0,-128
     726:	00000097          	auipc	ra,0x0
     72a:	5da080e7          	jalr	1498(ra) # d00 <strlen>
     72e:	1502                	slli	a0,a0,0x20
     730:	9101                	srli	a0,a0,0x20
     732:	00001597          	auipc	a1,0x1
     736:	e3658593          	addi	a1,a1,-458 # 1568 <malloc+0x1fc>
     73a:	f8040793          	addi	a5,s0,-128
     73e:	953e                	add	a0,a0,a5
     740:	00000097          	auipc	ra,0x0
     744:	578080e7          	jalr	1400(ra) # cb8 <strcpy>

  if(one(cmd, data, 1) == 0){
     748:	4605                	li	a2,1
     74a:	fa040593          	addi	a1,s0,-96
     74e:	f8040513          	addi	a0,s0,-128
     752:	00000097          	auipc	ra,0x0
     756:	ad4080e7          	jalr	-1324(ra) # 226 <one>
     75a:	e515                	bnez	a0,786 <t5+0xe2>
    printf("FAIL\n");
     75c:	00001517          	auipc	a0,0x1
     760:	e8450513          	addi	a0,a0,-380 # 15e0 <malloc+0x274>
     764:	00001097          	auipc	ra,0x1
     768:	b4a080e7          	jalr	-1206(ra) # 12ae <printf>
    *ok = 0;
     76c:	0004a023          	sw	zero,0(s1)
  } else {
    printf("PASS\n");
  }

  unlink(file);
     770:	fc040513          	addi	a0,s0,-64
     774:	00001097          	auipc	ra,0x1
     778:	80a080e7          	jalr	-2038(ra) # f7e <unlink>
}
     77c:	70e6                	ld	ra,120(sp)
     77e:	7446                	ld	s0,112(sp)
     780:	74a6                	ld	s1,104(sp)
     782:	6109                	addi	sp,sp,128
     784:	8082                	ret
    printf("PASS\n");
     786:	00001517          	auipc	a0,0x1
     78a:	e6250513          	addi	a0,a0,-414 # 15e8 <malloc+0x27c>
     78e:	00001097          	auipc	ra,0x1
     792:	b20080e7          	jalr	-1248(ra) # 12ae <printf>
     796:	bfe9                	j	770 <t5+0xcc>

0000000000000798 <t6>:

// test a command with both input and output redirection.
void
t6(int *ok)
{
     798:	711d                	addi	sp,sp,-96
     79a:	ec86                	sd	ra,88(sp)
     79c:	e8a2                	sd	s0,80(sp)
     79e:	e4a6                	sd	s1,72(sp)
     7a0:	1080                	addi	s0,sp,96
     7a2:	84aa                	mv	s1,a0
  printf("both redirections: ");
     7a4:	00001517          	auipc	a0,0x1
     7a8:	f1c50513          	addi	a0,a0,-228 # 16c0 <malloc+0x354>
     7ac:	00001097          	auipc	ra,0x1
     7b0:	b02080e7          	jalr	-1278(ra) # 12ae <printf>
  unlink("testsh.out");
     7b4:	00001517          	auipc	a0,0x1
     7b8:	f2450513          	addi	a0,a0,-220 # 16d8 <malloc+0x36c>
     7bc:	00000097          	auipc	ra,0x0
     7c0:	7c2080e7          	jalr	1986(ra) # f7e <unlink>
  if(one("grep pointers < README > testsh.out\n", "", 1) == 0){
     7c4:	4605                	li	a2,1
     7c6:	00001597          	auipc	a1,0x1
     7ca:	d4258593          	addi	a1,a1,-702 # 1508 <malloc+0x19c>
     7ce:	00001517          	auipc	a0,0x1
     7d2:	f1a50513          	addi	a0,a0,-230 # 16e8 <malloc+0x37c>
     7d6:	00000097          	auipc	ra,0x0
     7da:	a50080e7          	jalr	-1456(ra) # 226 <one>
     7de:	e905                	bnez	a0,80e <t6+0x76>
    printf("FAIL\n");
     7e0:	00001517          	auipc	a0,0x1
     7e4:	e0050513          	addi	a0,a0,-512 # 15e0 <malloc+0x274>
     7e8:	00001097          	auipc	ra,0x1
     7ec:	ac6080e7          	jalr	-1338(ra) # 12ae <printf>
    *ok = 0;
     7f0:	0004a023          	sw	zero,0(s1)
      *ok = 0;
    } else {
      printf("PASS\n");
    }
  }
  unlink("testsh.out");
     7f4:	00001517          	auipc	a0,0x1
     7f8:	ee450513          	addi	a0,a0,-284 # 16d8 <malloc+0x36c>
     7fc:	00000097          	auipc	ra,0x0
     800:	782080e7          	jalr	1922(ra) # f7e <unlink>
}
     804:	60e6                	ld	ra,88(sp)
     806:	6446                	ld	s0,80(sp)
     808:	64a6                	ld	s1,72(sp)
     80a:	6125                	addi	sp,sp,96
     80c:	8082                	ret
    readfile("testsh.out", buf, sizeof(buf));
     80e:	04000613          	li	a2,64
     812:	fa040593          	addi	a1,s0,-96
     816:	00001517          	auipc	a0,0x1
     81a:	ec250513          	addi	a0,a0,-318 # 16d8 <malloc+0x36c>
     81e:	00000097          	auipc	ra,0x0
     822:	934080e7          	jalr	-1740(ra) # 152 <readfile>
    if(strstr(buf, "provides pointers to on-line resources") == 0){
     826:	00001597          	auipc	a1,0x1
     82a:	eea58593          	addi	a1,a1,-278 # 1710 <malloc+0x3a4>
     82e:	fa040513          	addi	a0,s0,-96
     832:	00000097          	auipc	ra,0x0
     836:	9aa080e7          	jalr	-1622(ra) # 1dc <strstr>
     83a:	c911                	beqz	a0,84e <t6+0xb6>
      printf("PASS\n");
     83c:	00001517          	auipc	a0,0x1
     840:	dac50513          	addi	a0,a0,-596 # 15e8 <malloc+0x27c>
     844:	00001097          	auipc	ra,0x1
     848:	a6a080e7          	jalr	-1430(ra) # 12ae <printf>
     84c:	b765                	j	7f4 <t6+0x5c>
      printf("FAIL\n");
     84e:	00001517          	auipc	a0,0x1
     852:	d9250513          	addi	a0,a0,-622 # 15e0 <malloc+0x274>
     856:	00001097          	auipc	ra,0x1
     85a:	a58080e7          	jalr	-1448(ra) # 12ae <printf>
      *ok = 0;
     85e:	0004a023          	sw	zero,0(s1)
     862:	bf49                	j	7f4 <t6+0x5c>

0000000000000864 <t7>:

// test a pipe with cat filename | cat.
void
t7(int *ok)
{
     864:	7135                	addi	sp,sp,-160
     866:	ed06                	sd	ra,152(sp)
     868:	e922                	sd	s0,144(sp)
     86a:	e526                	sd	s1,136(sp)
     86c:	1100                	addi	s0,sp,160
     86e:	84aa                	mv	s1,a0
  printf("simple pipe: ");
     870:	00001517          	auipc	a0,0x1
     874:	ec850513          	addi	a0,a0,-312 # 1738 <malloc+0x3cc>
     878:	00001097          	auipc	ra,0x1
     87c:	a36080e7          	jalr	-1482(ra) # 12ae <printf>

  char name[32], data[32];
  randstring(name, 12);
     880:	45b1                	li	a1,12
     882:	fc040513          	addi	a0,s0,-64
     886:	fffff097          	auipc	ra,0xfffff
     88a:	7aa080e7          	jalr	1962(ra) # 30 <randstring>
  randstring(data, 12);
     88e:	45b1                	li	a1,12
     890:	fa040513          	addi	a0,s0,-96
     894:	fffff097          	auipc	ra,0xfffff
     898:	79c080e7          	jalr	1948(ra) # 30 <randstring>
  writefile(name, data);
     89c:	fa040593          	addi	a1,s0,-96
     8a0:	fc040513          	addi	a0,s0,-64
     8a4:	00000097          	auipc	ra,0x0
     8a8:	800080e7          	jalr	-2048(ra) # a4 <writefile>

  char cmd[64];
  strcpy(cmd, "cat ");
     8ac:	00001597          	auipc	a1,0x1
     8b0:	e9c58593          	addi	a1,a1,-356 # 1748 <malloc+0x3dc>
     8b4:	f6040513          	addi	a0,s0,-160
     8b8:	00000097          	auipc	ra,0x0
     8bc:	400080e7          	jalr	1024(ra) # cb8 <strcpy>
  strcpy(cmd + strlen(cmd), name);
     8c0:	f6040513          	addi	a0,s0,-160
     8c4:	00000097          	auipc	ra,0x0
     8c8:	43c080e7          	jalr	1084(ra) # d00 <strlen>
     8cc:	1502                	slli	a0,a0,0x20
     8ce:	9101                	srli	a0,a0,0x20
     8d0:	fc040593          	addi	a1,s0,-64
     8d4:	f6040793          	addi	a5,s0,-160
     8d8:	953e                	add	a0,a0,a5
     8da:	00000097          	auipc	ra,0x0
     8de:	3de080e7          	jalr	990(ra) # cb8 <strcpy>
  strcpy(cmd + strlen(cmd), " | cat\n");
     8e2:	f6040513          	addi	a0,s0,-160
     8e6:	00000097          	auipc	ra,0x0
     8ea:	41a080e7          	jalr	1050(ra) # d00 <strlen>
     8ee:	1502                	slli	a0,a0,0x20
     8f0:	9101                	srli	a0,a0,0x20
     8f2:	00001597          	auipc	a1,0x1
     8f6:	e5e58593          	addi	a1,a1,-418 # 1750 <malloc+0x3e4>
     8fa:	f6040793          	addi	a5,s0,-160
     8fe:	953e                	add	a0,a0,a5
     900:	00000097          	auipc	ra,0x0
     904:	3b8080e7          	jalr	952(ra) # cb8 <strcpy>
  
  if(one(cmd, data, 1) == 0){
     908:	4605                	li	a2,1
     90a:	fa040593          	addi	a1,s0,-96
     90e:	f6040513          	addi	a0,s0,-160
     912:	00000097          	auipc	ra,0x0
     916:	914080e7          	jalr	-1772(ra) # 226 <one>
     91a:	e515                	bnez	a0,946 <t7+0xe2>
    printf("FAIL\n");
     91c:	00001517          	auipc	a0,0x1
     920:	cc450513          	addi	a0,a0,-828 # 15e0 <malloc+0x274>
     924:	00001097          	auipc	ra,0x1
     928:	98a080e7          	jalr	-1654(ra) # 12ae <printf>
    *ok = 0;
     92c:	0004a023          	sw	zero,0(s1)
  } else {
    printf("PASS\n");
  }

  unlink(name);
     930:	fc040513          	addi	a0,s0,-64
     934:	00000097          	auipc	ra,0x0
     938:	64a080e7          	jalr	1610(ra) # f7e <unlink>
}
     93c:	60ea                	ld	ra,152(sp)
     93e:	644a                	ld	s0,144(sp)
     940:	64aa                	ld	s1,136(sp)
     942:	610d                	addi	sp,sp,160
     944:	8082                	ret
    printf("PASS\n");
     946:	00001517          	auipc	a0,0x1
     94a:	ca250513          	addi	a0,a0,-862 # 15e8 <malloc+0x27c>
     94e:	00001097          	auipc	ra,0x1
     952:	960080e7          	jalr	-1696(ra) # 12ae <printf>
     956:	bfe9                	j	930 <t7+0xcc>

0000000000000958 <t8>:

// test a pipeline that has both redirection and a pipe.
void
t8(int *ok)
{
     958:	711d                	addi	sp,sp,-96
     95a:	ec86                	sd	ra,88(sp)
     95c:	e8a2                	sd	s0,80(sp)
     95e:	e4a6                	sd	s1,72(sp)
     960:	1080                	addi	s0,sp,96
     962:	84aa                	mv	s1,a0
  printf("pipe and redirects: ");
     964:	00001517          	auipc	a0,0x1
     968:	df450513          	addi	a0,a0,-524 # 1758 <malloc+0x3ec>
     96c:	00001097          	auipc	ra,0x1
     970:	942080e7          	jalr	-1726(ra) # 12ae <printf>
  
  if(one("grep suggestions < README | wc > testsh.out\n", "", 1) == 0){
     974:	4605                	li	a2,1
     976:	00001597          	auipc	a1,0x1
     97a:	b9258593          	addi	a1,a1,-1134 # 1508 <malloc+0x19c>
     97e:	00001517          	auipc	a0,0x1
     982:	df250513          	addi	a0,a0,-526 # 1770 <malloc+0x404>
     986:	00000097          	auipc	ra,0x0
     98a:	8a0080e7          	jalr	-1888(ra) # 226 <one>
     98e:	e905                	bnez	a0,9be <t8+0x66>
    printf("FAIL\n");
     990:	00001517          	auipc	a0,0x1
     994:	c5050513          	addi	a0,a0,-944 # 15e0 <malloc+0x274>
     998:	00001097          	auipc	ra,0x1
     99c:	916080e7          	jalr	-1770(ra) # 12ae <printf>
    *ok = 0;
     9a0:	0004a023          	sw	zero,0(s1)
    } else {
      printf("PASS\n");
    }
  }

  unlink("testsh.out");
     9a4:	00001517          	auipc	a0,0x1
     9a8:	d3450513          	addi	a0,a0,-716 # 16d8 <malloc+0x36c>
     9ac:	00000097          	auipc	ra,0x0
     9b0:	5d2080e7          	jalr	1490(ra) # f7e <unlink>
}
     9b4:	60e6                	ld	ra,88(sp)
     9b6:	6446                	ld	s0,80(sp)
     9b8:	64a6                	ld	s1,72(sp)
     9ba:	6125                	addi	sp,sp,96
     9bc:	8082                	ret
    readfile("testsh.out", buf, sizeof(buf));
     9be:	04000613          	li	a2,64
     9c2:	fa040593          	addi	a1,s0,-96
     9c6:	00001517          	auipc	a0,0x1
     9ca:	d1250513          	addi	a0,a0,-750 # 16d8 <malloc+0x36c>
     9ce:	fffff097          	auipc	ra,0xfffff
     9d2:	784080e7          	jalr	1924(ra) # 152 <readfile>
    if(strstr(buf, "1 11 71") == 0){
     9d6:	00001597          	auipc	a1,0x1
     9da:	dca58593          	addi	a1,a1,-566 # 17a0 <malloc+0x434>
     9de:	fa040513          	addi	a0,s0,-96
     9e2:	fffff097          	auipc	ra,0xfffff
     9e6:	7fa080e7          	jalr	2042(ra) # 1dc <strstr>
     9ea:	c911                	beqz	a0,9fe <t8+0xa6>
      printf("PASS\n");
     9ec:	00001517          	auipc	a0,0x1
     9f0:	bfc50513          	addi	a0,a0,-1028 # 15e8 <malloc+0x27c>
     9f4:	00001097          	auipc	ra,0x1
     9f8:	8ba080e7          	jalr	-1862(ra) # 12ae <printf>
     9fc:	b765                	j	9a4 <t8+0x4c>
      printf("FAIL\n");
     9fe:	00001517          	auipc	a0,0x1
     a02:	be250513          	addi	a0,a0,-1054 # 15e0 <malloc+0x274>
     a06:	00001097          	auipc	ra,0x1
     a0a:	8a8080e7          	jalr	-1880(ra) # 12ae <printf>
      *ok = 0;
     a0e:	0004a023          	sw	zero,0(s1)
     a12:	bf49                	j	9a4 <t8+0x4c>

0000000000000a14 <t9>:

// ask the shell to execute many commands, to check
// if it leaks file descriptors.
void
t9(int *ok)
{
     a14:	7159                	addi	sp,sp,-112
     a16:	f486                	sd	ra,104(sp)
     a18:	f0a2                	sd	s0,96(sp)
     a1a:	eca6                	sd	s1,88(sp)
     a1c:	e8ca                	sd	s2,80(sp)
     a1e:	e4ce                	sd	s3,72(sp)
     a20:	e0d2                	sd	s4,64(sp)
     a22:	fc56                	sd	s5,56(sp)
     a24:	f85a                	sd	s6,48(sp)
     a26:	f45e                	sd	s7,40(sp)
     a28:	1880                	addi	s0,sp,112
     a2a:	8baa                	mv	s7,a0
  printf("lots of commands: ");
     a2c:	00001517          	auipc	a0,0x1
     a30:	d7c50513          	addi	a0,a0,-644 # 17a8 <malloc+0x43c>
     a34:	00001097          	auipc	ra,0x1
     a38:	87a080e7          	jalr	-1926(ra) # 12ae <printf>

  char term[32];
  randstring(term, 12);
     a3c:	45b1                	li	a1,12
     a3e:	f9040513          	addi	a0,s0,-112
     a42:	fffff097          	auipc	ra,0xfffff
     a46:	5ee080e7          	jalr	1518(ra) # 30 <randstring>
  
  char *cmd = malloc(25 * 36 + 100);
     a4a:	3e800513          	li	a0,1000
     a4e:	00001097          	auipc	ra,0x1
     a52:	91e080e7          	jalr	-1762(ra) # 136c <malloc>
  if(cmd == 0){
     a56:	14050363          	beqz	a0,b9c <t9+0x188>
     a5a:	84aa                	mv	s1,a0
    fprintf(2, "testsh: malloc failed\n");
    exit(-1);
  }

  cmd[0] = '\0';
     a5c:	00050023          	sb	zero,0(a0)
  for(int i = 0; i < 17+(rand()%6); i++){
     a60:	fffff097          	auipc	ra,0xfffff
     a64:	5a0080e7          	jalr	1440(ra) # 0 <rand>
     a68:	4981                	li	s3,0
    strcpy(cmd + strlen(cmd), "echo x < README > tso\n");
     a6a:	00001b17          	auipc	s6,0x1
     a6e:	d6eb0b13          	addi	s6,s6,-658 # 17d8 <malloc+0x46c>
    strcpy(cmd + strlen(cmd), "echo x | echo\n");
     a72:	00001a97          	auipc	s5,0x1
     a76:	d7ea8a93          	addi	s5,s5,-642 # 17f0 <malloc+0x484>
  for(int i = 0; i < 17+(rand()%6); i++){
     a7a:	4a19                	li	s4,6
    strcpy(cmd + strlen(cmd), "echo x < README > tso\n");
     a7c:	8526                	mv	a0,s1
     a7e:	00000097          	auipc	ra,0x0
     a82:	282080e7          	jalr	642(ra) # d00 <strlen>
     a86:	1502                	slli	a0,a0,0x20
     a88:	9101                	srli	a0,a0,0x20
     a8a:	85da                	mv	a1,s6
     a8c:	9526                	add	a0,a0,s1
     a8e:	00000097          	auipc	ra,0x0
     a92:	22a080e7          	jalr	554(ra) # cb8 <strcpy>
    strcpy(cmd + strlen(cmd), "echo x | echo\n");
     a96:	8526                	mv	a0,s1
     a98:	00000097          	auipc	ra,0x0
     a9c:	268080e7          	jalr	616(ra) # d00 <strlen>
     aa0:	1502                	slli	a0,a0,0x20
     aa2:	9101                	srli	a0,a0,0x20
     aa4:	85d6                	mv	a1,s5
     aa6:	9526                	add	a0,a0,s1
     aa8:	00000097          	auipc	ra,0x0
     aac:	210080e7          	jalr	528(ra) # cb8 <strcpy>
  for(int i = 0; i < 17+(rand()%6); i++){
     ab0:	0019891b          	addiw	s2,s3,1
     ab4:	0009099b          	sext.w	s3,s2
     ab8:	fffff097          	auipc	ra,0xfffff
     abc:	548080e7          	jalr	1352(ra) # 0 <rand>
     ac0:	034577bb          	remuw	a5,a0,s4
     ac4:	27c5                	addiw	a5,a5,17
     ac6:	faf9ebe3          	bltu	s3,a5,a7c <t9+0x68>
  }
  strcpy(cmd + strlen(cmd), "echo ");
     aca:	8526                	mv	a0,s1
     acc:	00000097          	auipc	ra,0x0
     ad0:	234080e7          	jalr	564(ra) # d00 <strlen>
     ad4:	1502                	slli	a0,a0,0x20
     ad6:	9101                	srli	a0,a0,0x20
     ad8:	00001597          	auipc	a1,0x1
     adc:	bb858593          	addi	a1,a1,-1096 # 1690 <malloc+0x324>
     ae0:	9526                	add	a0,a0,s1
     ae2:	00000097          	auipc	ra,0x0
     ae6:	1d6080e7          	jalr	470(ra) # cb8 <strcpy>
  strcpy(cmd + strlen(cmd), term);
     aea:	8526                	mv	a0,s1
     aec:	00000097          	auipc	ra,0x0
     af0:	214080e7          	jalr	532(ra) # d00 <strlen>
     af4:	1502                	slli	a0,a0,0x20
     af6:	9101                	srli	a0,a0,0x20
     af8:	f9040593          	addi	a1,s0,-112
     afc:	9526                	add	a0,a0,s1
     afe:	00000097          	auipc	ra,0x0
     b02:	1ba080e7          	jalr	442(ra) # cb8 <strcpy>
  strcpy(cmd + strlen(cmd), " > tso\n");
     b06:	8526                	mv	a0,s1
     b08:	00000097          	auipc	ra,0x0
     b0c:	1f8080e7          	jalr	504(ra) # d00 <strlen>
     b10:	1502                	slli	a0,a0,0x20
     b12:	9101                	srli	a0,a0,0x20
     b14:	00001597          	auipc	a1,0x1
     b18:	cec58593          	addi	a1,a1,-788 # 1800 <malloc+0x494>
     b1c:	9526                	add	a0,a0,s1
     b1e:	00000097          	auipc	ra,0x0
     b22:	19a080e7          	jalr	410(ra) # cb8 <strcpy>
  strcpy(cmd + strlen(cmd), "cat < tso\n");
     b26:	8526                	mv	a0,s1
     b28:	00000097          	auipc	ra,0x0
     b2c:	1d8080e7          	jalr	472(ra) # d00 <strlen>
     b30:	1502                	slli	a0,a0,0x20
     b32:	9101                	srli	a0,a0,0x20
     b34:	00001597          	auipc	a1,0x1
     b38:	cd458593          	addi	a1,a1,-812 # 1808 <malloc+0x49c>
     b3c:	9526                	add	a0,a0,s1
     b3e:	00000097          	auipc	ra,0x0
     b42:	17a080e7          	jalr	378(ra) # cb8 <strcpy>

  if(one(cmd, term, 0) == 0){
     b46:	4601                	li	a2,0
     b48:	f9040593          	addi	a1,s0,-112
     b4c:	8526                	mv	a0,s1
     b4e:	fffff097          	auipc	ra,0xfffff
     b52:	6d8080e7          	jalr	1752(ra) # 226 <one>
     b56:	e12d                	bnez	a0,bb8 <t9+0x1a4>
    printf("FAIL\n");
     b58:	00001517          	auipc	a0,0x1
     b5c:	a8850513          	addi	a0,a0,-1400 # 15e0 <malloc+0x274>
     b60:	00000097          	auipc	ra,0x0
     b64:	74e080e7          	jalr	1870(ra) # 12ae <printf>
    *ok = 0;
     b68:	000ba023          	sw	zero,0(s7)
  } else {
    printf("PASS\n");
  }

  unlink("tso");
     b6c:	00001517          	auipc	a0,0x1
     b70:	cac50513          	addi	a0,a0,-852 # 1818 <malloc+0x4ac>
     b74:	00000097          	auipc	ra,0x0
     b78:	40a080e7          	jalr	1034(ra) # f7e <unlink>
  free(cmd);
     b7c:	8526                	mv	a0,s1
     b7e:	00000097          	auipc	ra,0x0
     b82:	766080e7          	jalr	1894(ra) # 12e4 <free>
}
     b86:	70a6                	ld	ra,104(sp)
     b88:	7406                	ld	s0,96(sp)
     b8a:	64e6                	ld	s1,88(sp)
     b8c:	6946                	ld	s2,80(sp)
     b8e:	69a6                	ld	s3,72(sp)
     b90:	6a06                	ld	s4,64(sp)
     b92:	7ae2                	ld	s5,56(sp)
     b94:	7b42                	ld	s6,48(sp)
     b96:	7ba2                	ld	s7,40(sp)
     b98:	6165                	addi	sp,sp,112
     b9a:	8082                	ret
    fprintf(2, "testsh: malloc failed\n");
     b9c:	00001597          	auipc	a1,0x1
     ba0:	c2458593          	addi	a1,a1,-988 # 17c0 <malloc+0x454>
     ba4:	4509                	li	a0,2
     ba6:	00000097          	auipc	ra,0x0
     baa:	6da080e7          	jalr	1754(ra) # 1280 <fprintf>
    exit(-1);
     bae:	557d                	li	a0,-1
     bb0:	00000097          	auipc	ra,0x0
     bb4:	37e080e7          	jalr	894(ra) # f2e <exit>
    printf("PASS\n");
     bb8:	00001517          	auipc	a0,0x1
     bbc:	a3050513          	addi	a0,a0,-1488 # 15e8 <malloc+0x27c>
     bc0:	00000097          	auipc	ra,0x0
     bc4:	6ee080e7          	jalr	1774(ra) # 12ae <printf>
     bc8:	b755                	j	b6c <t9+0x158>

0000000000000bca <main>:

int
main(int argc, char *argv[])
{
     bca:	1101                	addi	sp,sp,-32
     bcc:	ec06                	sd	ra,24(sp)
     bce:	e822                	sd	s0,16(sp)
     bd0:	1000                	addi	s0,sp,32
  if(argc != 2){
     bd2:	4789                	li	a5,2
     bd4:	02f50063          	beq	a0,a5,bf4 <main+0x2a>
    fprintf(2, "Usage: testsh nsh\n");
     bd8:	00001597          	auipc	a1,0x1
     bdc:	c4858593          	addi	a1,a1,-952 # 1820 <malloc+0x4b4>
     be0:	4509                	li	a0,2
     be2:	00000097          	auipc	ra,0x0
     be6:	69e080e7          	jalr	1694(ra) # 1280 <fprintf>
    exit(-1);
     bea:	557d                	li	a0,-1
     bec:	00000097          	auipc	ra,0x0
     bf0:	342080e7          	jalr	834(ra) # f2e <exit>
  }
  shname = argv[1];
     bf4:	659c                	ld	a5,8(a1)
     bf6:	00001717          	auipc	a4,0x1
     bfa:	c8f73923          	sd	a5,-878(a4) # 1888 <_edata>
  
  seed += getpid();
     bfe:	00000097          	auipc	ra,0x0
     c02:	3b0080e7          	jalr	944(ra) # fae <getpid>
     c06:	00001717          	auipc	a4,0x1
     c0a:	c7e70713          	addi	a4,a4,-898 # 1884 <seed>
     c0e:	431c                	lw	a5,0(a4)
     c10:	9fa9                	addw	a5,a5,a0
     c12:	c31c                	sw	a5,0(a4)

  int ok = 1;
     c14:	4785                	li	a5,1
     c16:	fef42623          	sw	a5,-20(s0)

  t1(&ok);
     c1a:	fec40513          	addi	a0,s0,-20
     c1e:	fffff097          	auipc	ra,0xfffff
     c22:	7e2080e7          	jalr	2018(ra) # 400 <t1>
  t2(&ok);
     c26:	fec40513          	addi	a0,s0,-20
     c2a:	00000097          	auipc	ra,0x0
     c2e:	83e080e7          	jalr	-1986(ra) # 468 <t2>
  t3(&ok);
     c32:	fec40513          	addi	a0,s0,-20
     c36:	00000097          	auipc	ra,0x0
     c3a:	89a080e7          	jalr	-1894(ra) # 4d0 <t3>
  t4(&ok);
     c3e:	fec40513          	addi	a0,s0,-20
     c42:	00000097          	auipc	ra,0x0
     c46:	8f6080e7          	jalr	-1802(ra) # 538 <t4>
  t5(&ok);
     c4a:	fec40513          	addi	a0,s0,-20
     c4e:	00000097          	auipc	ra,0x0
     c52:	a56080e7          	jalr	-1450(ra) # 6a4 <t5>
  t6(&ok);
     c56:	fec40513          	addi	a0,s0,-20
     c5a:	00000097          	auipc	ra,0x0
     c5e:	b3e080e7          	jalr	-1218(ra) # 798 <t6>
  t7(&ok);
     c62:	fec40513          	addi	a0,s0,-20
     c66:	00000097          	auipc	ra,0x0
     c6a:	bfe080e7          	jalr	-1026(ra) # 864 <t7>
  t8(&ok);
     c6e:	fec40513          	addi	a0,s0,-20
     c72:	00000097          	auipc	ra,0x0
     c76:	ce6080e7          	jalr	-794(ra) # 958 <t8>
  t9(&ok);
     c7a:	fec40513          	addi	a0,s0,-20
     c7e:	00000097          	auipc	ra,0x0
     c82:	d96080e7          	jalr	-618(ra) # a14 <t9>

  if(ok){
     c86:	fec42783          	lw	a5,-20(s0)
     c8a:	cf91                	beqz	a5,ca6 <main+0xdc>
    printf("passed all tests\n");
     c8c:	00001517          	auipc	a0,0x1
     c90:	bac50513          	addi	a0,a0,-1108 # 1838 <malloc+0x4cc>
     c94:	00000097          	auipc	ra,0x0
     c98:	61a080e7          	jalr	1562(ra) # 12ae <printf>
  } else {
    printf("failed some tests\n");
  }
  
  exit(0);
     c9c:	4501                	li	a0,0
     c9e:	00000097          	auipc	ra,0x0
     ca2:	290080e7          	jalr	656(ra) # f2e <exit>
    printf("failed some tests\n");
     ca6:	00001517          	auipc	a0,0x1
     caa:	baa50513          	addi	a0,a0,-1110 # 1850 <malloc+0x4e4>
     cae:	00000097          	auipc	ra,0x0
     cb2:	600080e7          	jalr	1536(ra) # 12ae <printf>
     cb6:	b7dd                	j	c9c <main+0xd2>

0000000000000cb8 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     cb8:	1141                	addi	sp,sp,-16
     cba:	e422                	sd	s0,8(sp)
     cbc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     cbe:	87aa                	mv	a5,a0
     cc0:	0585                	addi	a1,a1,1
     cc2:	0785                	addi	a5,a5,1
     cc4:	fff5c703          	lbu	a4,-1(a1)
     cc8:	fee78fa3          	sb	a4,-1(a5)
     ccc:	fb75                	bnez	a4,cc0 <strcpy+0x8>
    ;
  return os;
}
     cce:	6422                	ld	s0,8(sp)
     cd0:	0141                	addi	sp,sp,16
     cd2:	8082                	ret

0000000000000cd4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     cd4:	1141                	addi	sp,sp,-16
     cd6:	e422                	sd	s0,8(sp)
     cd8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     cda:	00054783          	lbu	a5,0(a0)
     cde:	cb91                	beqz	a5,cf2 <strcmp+0x1e>
     ce0:	0005c703          	lbu	a4,0(a1)
     ce4:	00f71763          	bne	a4,a5,cf2 <strcmp+0x1e>
    p++, q++;
     ce8:	0505                	addi	a0,a0,1
     cea:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     cec:	00054783          	lbu	a5,0(a0)
     cf0:	fbe5                	bnez	a5,ce0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     cf2:	0005c503          	lbu	a0,0(a1)
}
     cf6:	40a7853b          	subw	a0,a5,a0
     cfa:	6422                	ld	s0,8(sp)
     cfc:	0141                	addi	sp,sp,16
     cfe:	8082                	ret

0000000000000d00 <strlen>:

uint
strlen(const char *s)
{
     d00:	1141                	addi	sp,sp,-16
     d02:	e422                	sd	s0,8(sp)
     d04:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     d06:	00054783          	lbu	a5,0(a0)
     d0a:	cf91                	beqz	a5,d26 <strlen+0x26>
     d0c:	0505                	addi	a0,a0,1
     d0e:	87aa                	mv	a5,a0
     d10:	4685                	li	a3,1
     d12:	9e89                	subw	a3,a3,a0
     d14:	00f6853b          	addw	a0,a3,a5
     d18:	0785                	addi	a5,a5,1
     d1a:	fff7c703          	lbu	a4,-1(a5)
     d1e:	fb7d                	bnez	a4,d14 <strlen+0x14>
    ;
  return n;
}
     d20:	6422                	ld	s0,8(sp)
     d22:	0141                	addi	sp,sp,16
     d24:	8082                	ret
  for(n = 0; s[n]; n++)
     d26:	4501                	li	a0,0
     d28:	bfe5                	j	d20 <strlen+0x20>

0000000000000d2a <memset>:

void*
memset(void *dst, int c, uint n)
{
     d2a:	1141                	addi	sp,sp,-16
     d2c:	e422                	sd	s0,8(sp)
     d2e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     d30:	ce09                	beqz	a2,d4a <memset+0x20>
     d32:	87aa                	mv	a5,a0
     d34:	fff6071b          	addiw	a4,a2,-1
     d38:	1702                	slli	a4,a4,0x20
     d3a:	9301                	srli	a4,a4,0x20
     d3c:	0705                	addi	a4,a4,1
     d3e:	972a                	add	a4,a4,a0
    cdst[i] = c;
     d40:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     d44:	0785                	addi	a5,a5,1
     d46:	fee79de3          	bne	a5,a4,d40 <memset+0x16>
  }
  return dst;
}
     d4a:	6422                	ld	s0,8(sp)
     d4c:	0141                	addi	sp,sp,16
     d4e:	8082                	ret

0000000000000d50 <strchr>:

char*
strchr(const char *s, char c)
{
     d50:	1141                	addi	sp,sp,-16
     d52:	e422                	sd	s0,8(sp)
     d54:	0800                	addi	s0,sp,16
  for(; *s; s++)
     d56:	00054783          	lbu	a5,0(a0)
     d5a:	cb99                	beqz	a5,d70 <strchr+0x20>
    if(*s == c)
     d5c:	00f58763          	beq	a1,a5,d6a <strchr+0x1a>
  for(; *s; s++)
     d60:	0505                	addi	a0,a0,1
     d62:	00054783          	lbu	a5,0(a0)
     d66:	fbfd                	bnez	a5,d5c <strchr+0xc>
      return (char*)s;
  return 0;
     d68:	4501                	li	a0,0
}
     d6a:	6422                	ld	s0,8(sp)
     d6c:	0141                	addi	sp,sp,16
     d6e:	8082                	ret
  return 0;
     d70:	4501                	li	a0,0
     d72:	bfe5                	j	d6a <strchr+0x1a>

0000000000000d74 <gets>:

char*
gets(char *buf, int max)
{
     d74:	711d                	addi	sp,sp,-96
     d76:	ec86                	sd	ra,88(sp)
     d78:	e8a2                	sd	s0,80(sp)
     d7a:	e4a6                	sd	s1,72(sp)
     d7c:	e0ca                	sd	s2,64(sp)
     d7e:	fc4e                	sd	s3,56(sp)
     d80:	f852                	sd	s4,48(sp)
     d82:	f456                	sd	s5,40(sp)
     d84:	f05a                	sd	s6,32(sp)
     d86:	ec5e                	sd	s7,24(sp)
     d88:	1080                	addi	s0,sp,96
     d8a:	8baa                	mv	s7,a0
     d8c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d8e:	892a                	mv	s2,a0
     d90:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     d92:	4aa9                	li	s5,10
     d94:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     d96:	89a6                	mv	s3,s1
     d98:	2485                	addiw	s1,s1,1
     d9a:	0344d863          	bge	s1,s4,dca <gets+0x56>
    cc = read(0, &c, 1);
     d9e:	4605                	li	a2,1
     da0:	faf40593          	addi	a1,s0,-81
     da4:	4501                	li	a0,0
     da6:	00000097          	auipc	ra,0x0
     daa:	1a0080e7          	jalr	416(ra) # f46 <read>
    if(cc < 1)
     dae:	00a05e63          	blez	a0,dca <gets+0x56>
    buf[i++] = c;
     db2:	faf44783          	lbu	a5,-81(s0)
     db6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     dba:	01578763          	beq	a5,s5,dc8 <gets+0x54>
     dbe:	0905                	addi	s2,s2,1
     dc0:	fd679be3          	bne	a5,s6,d96 <gets+0x22>
  for(i=0; i+1 < max; ){
     dc4:	89a6                	mv	s3,s1
     dc6:	a011                	j	dca <gets+0x56>
     dc8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     dca:	99de                	add	s3,s3,s7
     dcc:	00098023          	sb	zero,0(s3)
  return buf;
}
     dd0:	855e                	mv	a0,s7
     dd2:	60e6                	ld	ra,88(sp)
     dd4:	6446                	ld	s0,80(sp)
     dd6:	64a6                	ld	s1,72(sp)
     dd8:	6906                	ld	s2,64(sp)
     dda:	79e2                	ld	s3,56(sp)
     ddc:	7a42                	ld	s4,48(sp)
     dde:	7aa2                	ld	s5,40(sp)
     de0:	7b02                	ld	s6,32(sp)
     de2:	6be2                	ld	s7,24(sp)
     de4:	6125                	addi	sp,sp,96
     de6:	8082                	ret

0000000000000de8 <stat>:

int
stat(const char *n, struct stat *st)
{
     de8:	1101                	addi	sp,sp,-32
     dea:	ec06                	sd	ra,24(sp)
     dec:	e822                	sd	s0,16(sp)
     dee:	e426                	sd	s1,8(sp)
     df0:	e04a                	sd	s2,0(sp)
     df2:	1000                	addi	s0,sp,32
     df4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     df6:	4581                	li	a1,0
     df8:	00000097          	auipc	ra,0x0
     dfc:	176080e7          	jalr	374(ra) # f6e <open>
  if(fd < 0)
     e00:	02054563          	bltz	a0,e2a <stat+0x42>
     e04:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     e06:	85ca                	mv	a1,s2
     e08:	00000097          	auipc	ra,0x0
     e0c:	17e080e7          	jalr	382(ra) # f86 <fstat>
     e10:	892a                	mv	s2,a0
  close(fd);
     e12:	8526                	mv	a0,s1
     e14:	00000097          	auipc	ra,0x0
     e18:	142080e7          	jalr	322(ra) # f56 <close>
  return r;
}
     e1c:	854a                	mv	a0,s2
     e1e:	60e2                	ld	ra,24(sp)
     e20:	6442                	ld	s0,16(sp)
     e22:	64a2                	ld	s1,8(sp)
     e24:	6902                	ld	s2,0(sp)
     e26:	6105                	addi	sp,sp,32
     e28:	8082                	ret
    return -1;
     e2a:	597d                	li	s2,-1
     e2c:	bfc5                	j	e1c <stat+0x34>

0000000000000e2e <atoi>:

int
atoi(const char *s)
{
     e2e:	1141                	addi	sp,sp,-16
     e30:	e422                	sd	s0,8(sp)
     e32:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e34:	00054603          	lbu	a2,0(a0)
     e38:	fd06079b          	addiw	a5,a2,-48
     e3c:	0ff7f793          	andi	a5,a5,255
     e40:	4725                	li	a4,9
     e42:	02f76963          	bltu	a4,a5,e74 <atoi+0x46>
     e46:	86aa                	mv	a3,a0
  n = 0;
     e48:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     e4a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     e4c:	0685                	addi	a3,a3,1
     e4e:	0025179b          	slliw	a5,a0,0x2
     e52:	9fa9                	addw	a5,a5,a0
     e54:	0017979b          	slliw	a5,a5,0x1
     e58:	9fb1                	addw	a5,a5,a2
     e5a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     e5e:	0006c603          	lbu	a2,0(a3)
     e62:	fd06071b          	addiw	a4,a2,-48
     e66:	0ff77713          	andi	a4,a4,255
     e6a:	fee5f1e3          	bgeu	a1,a4,e4c <atoi+0x1e>
  return n;
}
     e6e:	6422                	ld	s0,8(sp)
     e70:	0141                	addi	sp,sp,16
     e72:	8082                	ret
  n = 0;
     e74:	4501                	li	a0,0
     e76:	bfe5                	j	e6e <atoi+0x40>

0000000000000e78 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e78:	1141                	addi	sp,sp,-16
     e7a:	e422                	sd	s0,8(sp)
     e7c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     e7e:	02b57663          	bgeu	a0,a1,eaa <memmove+0x32>
    while(n-- > 0)
     e82:	02c05163          	blez	a2,ea4 <memmove+0x2c>
     e86:	fff6079b          	addiw	a5,a2,-1
     e8a:	1782                	slli	a5,a5,0x20
     e8c:	9381                	srli	a5,a5,0x20
     e8e:	0785                	addi	a5,a5,1
     e90:	97aa                	add	a5,a5,a0
  dst = vdst;
     e92:	872a                	mv	a4,a0
      *dst++ = *src++;
     e94:	0585                	addi	a1,a1,1
     e96:	0705                	addi	a4,a4,1
     e98:	fff5c683          	lbu	a3,-1(a1)
     e9c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     ea0:	fee79ae3          	bne	a5,a4,e94 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ea4:	6422                	ld	s0,8(sp)
     ea6:	0141                	addi	sp,sp,16
     ea8:	8082                	ret
    dst += n;
     eaa:	00c50733          	add	a4,a0,a2
    src += n;
     eae:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     eb0:	fec05ae3          	blez	a2,ea4 <memmove+0x2c>
     eb4:	fff6079b          	addiw	a5,a2,-1
     eb8:	1782                	slli	a5,a5,0x20
     eba:	9381                	srli	a5,a5,0x20
     ebc:	fff7c793          	not	a5,a5
     ec0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     ec2:	15fd                	addi	a1,a1,-1
     ec4:	177d                	addi	a4,a4,-1
     ec6:	0005c683          	lbu	a3,0(a1)
     eca:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     ece:	fee79ae3          	bne	a5,a4,ec2 <memmove+0x4a>
     ed2:	bfc9                	j	ea4 <memmove+0x2c>

0000000000000ed4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     ed4:	1141                	addi	sp,sp,-16
     ed6:	e422                	sd	s0,8(sp)
     ed8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     eda:	ca05                	beqz	a2,f0a <memcmp+0x36>
     edc:	fff6069b          	addiw	a3,a2,-1
     ee0:	1682                	slli	a3,a3,0x20
     ee2:	9281                	srli	a3,a3,0x20
     ee4:	0685                	addi	a3,a3,1
     ee6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     ee8:	00054783          	lbu	a5,0(a0)
     eec:	0005c703          	lbu	a4,0(a1)
     ef0:	00e79863          	bne	a5,a4,f00 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     ef4:	0505                	addi	a0,a0,1
    p2++;
     ef6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     ef8:	fed518e3          	bne	a0,a3,ee8 <memcmp+0x14>
  }
  return 0;
     efc:	4501                	li	a0,0
     efe:	a019                	j	f04 <memcmp+0x30>
      return *p1 - *p2;
     f00:	40e7853b          	subw	a0,a5,a4
}
     f04:	6422                	ld	s0,8(sp)
     f06:	0141                	addi	sp,sp,16
     f08:	8082                	ret
  return 0;
     f0a:	4501                	li	a0,0
     f0c:	bfe5                	j	f04 <memcmp+0x30>

0000000000000f0e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     f0e:	1141                	addi	sp,sp,-16
     f10:	e406                	sd	ra,8(sp)
     f12:	e022                	sd	s0,0(sp)
     f14:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     f16:	00000097          	auipc	ra,0x0
     f1a:	f62080e7          	jalr	-158(ra) # e78 <memmove>
}
     f1e:	60a2                	ld	ra,8(sp)
     f20:	6402                	ld	s0,0(sp)
     f22:	0141                	addi	sp,sp,16
     f24:	8082                	ret

0000000000000f26 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     f26:	4885                	li	a7,1
 ecall
     f28:	00000073          	ecall
 ret
     f2c:	8082                	ret

0000000000000f2e <exit>:
.global exit
exit:
 li a7, SYS_exit
     f2e:	4889                	li	a7,2
 ecall
     f30:	00000073          	ecall
 ret
     f34:	8082                	ret

0000000000000f36 <wait>:
.global wait
wait:
 li a7, SYS_wait
     f36:	488d                	li	a7,3
 ecall
     f38:	00000073          	ecall
 ret
     f3c:	8082                	ret

0000000000000f3e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     f3e:	4891                	li	a7,4
 ecall
     f40:	00000073          	ecall
 ret
     f44:	8082                	ret

0000000000000f46 <read>:
.global read
read:
 li a7, SYS_read
     f46:	4895                	li	a7,5
 ecall
     f48:	00000073          	ecall
 ret
     f4c:	8082                	ret

0000000000000f4e <write>:
.global write
write:
 li a7, SYS_write
     f4e:	48c1                	li	a7,16
 ecall
     f50:	00000073          	ecall
 ret
     f54:	8082                	ret

0000000000000f56 <close>:
.global close
close:
 li a7, SYS_close
     f56:	48d5                	li	a7,21
 ecall
     f58:	00000073          	ecall
 ret
     f5c:	8082                	ret

0000000000000f5e <kill>:
.global kill
kill:
 li a7, SYS_kill
     f5e:	4899                	li	a7,6
 ecall
     f60:	00000073          	ecall
 ret
     f64:	8082                	ret

0000000000000f66 <exec>:
.global exec
exec:
 li a7, SYS_exec
     f66:	489d                	li	a7,7
 ecall
     f68:	00000073          	ecall
 ret
     f6c:	8082                	ret

0000000000000f6e <open>:
.global open
open:
 li a7, SYS_open
     f6e:	48bd                	li	a7,15
 ecall
     f70:	00000073          	ecall
 ret
     f74:	8082                	ret

0000000000000f76 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     f76:	48c5                	li	a7,17
 ecall
     f78:	00000073          	ecall
 ret
     f7c:	8082                	ret

0000000000000f7e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     f7e:	48c9                	li	a7,18
 ecall
     f80:	00000073          	ecall
 ret
     f84:	8082                	ret

0000000000000f86 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     f86:	48a1                	li	a7,8
 ecall
     f88:	00000073          	ecall
 ret
     f8c:	8082                	ret

0000000000000f8e <link>:
.global link
link:
 li a7, SYS_link
     f8e:	48cd                	li	a7,19
 ecall
     f90:	00000073          	ecall
 ret
     f94:	8082                	ret

0000000000000f96 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f96:	48d1                	li	a7,20
 ecall
     f98:	00000073          	ecall
 ret
     f9c:	8082                	ret

0000000000000f9e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f9e:	48a5                	li	a7,9
 ecall
     fa0:	00000073          	ecall
 ret
     fa4:	8082                	ret

0000000000000fa6 <dup>:
.global dup
dup:
 li a7, SYS_dup
     fa6:	48a9                	li	a7,10
 ecall
     fa8:	00000073          	ecall
 ret
     fac:	8082                	ret

0000000000000fae <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     fae:	48ad                	li	a7,11
 ecall
     fb0:	00000073          	ecall
 ret
     fb4:	8082                	ret

0000000000000fb6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     fb6:	48b1                	li	a7,12
 ecall
     fb8:	00000073          	ecall
 ret
     fbc:	8082                	ret

0000000000000fbe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     fbe:	48b5                	li	a7,13
 ecall
     fc0:	00000073          	ecall
 ret
     fc4:	8082                	ret

0000000000000fc6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     fc6:	48b9                	li	a7,14
 ecall
     fc8:	00000073          	ecall
 ret
     fcc:	8082                	ret

0000000000000fce <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
     fce:	48d9                	li	a7,22
 ecall
     fd0:	00000073          	ecall
 ret
     fd4:	8082                	ret

0000000000000fd6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     fd6:	1101                	addi	sp,sp,-32
     fd8:	ec06                	sd	ra,24(sp)
     fda:	e822                	sd	s0,16(sp)
     fdc:	1000                	addi	s0,sp,32
     fde:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     fe2:	4605                	li	a2,1
     fe4:	fef40593          	addi	a1,s0,-17
     fe8:	00000097          	auipc	ra,0x0
     fec:	f66080e7          	jalr	-154(ra) # f4e <write>
}
     ff0:	60e2                	ld	ra,24(sp)
     ff2:	6442                	ld	s0,16(sp)
     ff4:	6105                	addi	sp,sp,32
     ff6:	8082                	ret

0000000000000ff8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ff8:	7139                	addi	sp,sp,-64
     ffa:	fc06                	sd	ra,56(sp)
     ffc:	f822                	sd	s0,48(sp)
     ffe:	f426                	sd	s1,40(sp)
    1000:	f04a                	sd	s2,32(sp)
    1002:	ec4e                	sd	s3,24(sp)
    1004:	0080                	addi	s0,sp,64
    1006:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1008:	c299                	beqz	a3,100e <printint+0x16>
    100a:	0805c863          	bltz	a1,109a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    100e:	2581                	sext.w	a1,a1
  neg = 0;
    1010:	4881                	li	a7,0
    1012:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1016:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1018:	2601                	sext.w	a2,a2
    101a:	00001517          	auipc	a0,0x1
    101e:	85650513          	addi	a0,a0,-1962 # 1870 <digits>
    1022:	883a                	mv	a6,a4
    1024:	2705                	addiw	a4,a4,1
    1026:	02c5f7bb          	remuw	a5,a1,a2
    102a:	1782                	slli	a5,a5,0x20
    102c:	9381                	srli	a5,a5,0x20
    102e:	97aa                	add	a5,a5,a0
    1030:	0007c783          	lbu	a5,0(a5)
    1034:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1038:	0005879b          	sext.w	a5,a1
    103c:	02c5d5bb          	divuw	a1,a1,a2
    1040:	0685                	addi	a3,a3,1
    1042:	fec7f0e3          	bgeu	a5,a2,1022 <printint+0x2a>
  if(neg)
    1046:	00088b63          	beqz	a7,105c <printint+0x64>
    buf[i++] = '-';
    104a:	fd040793          	addi	a5,s0,-48
    104e:	973e                	add	a4,a4,a5
    1050:	02d00793          	li	a5,45
    1054:	fef70823          	sb	a5,-16(a4)
    1058:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    105c:	02e05863          	blez	a4,108c <printint+0x94>
    1060:	fc040793          	addi	a5,s0,-64
    1064:	00e78933          	add	s2,a5,a4
    1068:	fff78993          	addi	s3,a5,-1
    106c:	99ba                	add	s3,s3,a4
    106e:	377d                	addiw	a4,a4,-1
    1070:	1702                	slli	a4,a4,0x20
    1072:	9301                	srli	a4,a4,0x20
    1074:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1078:	fff94583          	lbu	a1,-1(s2)
    107c:	8526                	mv	a0,s1
    107e:	00000097          	auipc	ra,0x0
    1082:	f58080e7          	jalr	-168(ra) # fd6 <putc>
  while(--i >= 0)
    1086:	197d                	addi	s2,s2,-1
    1088:	ff3918e3          	bne	s2,s3,1078 <printint+0x80>
}
    108c:	70e2                	ld	ra,56(sp)
    108e:	7442                	ld	s0,48(sp)
    1090:	74a2                	ld	s1,40(sp)
    1092:	7902                	ld	s2,32(sp)
    1094:	69e2                	ld	s3,24(sp)
    1096:	6121                	addi	sp,sp,64
    1098:	8082                	ret
    x = -xx;
    109a:	40b005bb          	negw	a1,a1
    neg = 1;
    109e:	4885                	li	a7,1
    x = -xx;
    10a0:	bf8d                	j	1012 <printint+0x1a>

00000000000010a2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    10a2:	7119                	addi	sp,sp,-128
    10a4:	fc86                	sd	ra,120(sp)
    10a6:	f8a2                	sd	s0,112(sp)
    10a8:	f4a6                	sd	s1,104(sp)
    10aa:	f0ca                	sd	s2,96(sp)
    10ac:	ecce                	sd	s3,88(sp)
    10ae:	e8d2                	sd	s4,80(sp)
    10b0:	e4d6                	sd	s5,72(sp)
    10b2:	e0da                	sd	s6,64(sp)
    10b4:	fc5e                	sd	s7,56(sp)
    10b6:	f862                	sd	s8,48(sp)
    10b8:	f466                	sd	s9,40(sp)
    10ba:	f06a                	sd	s10,32(sp)
    10bc:	ec6e                	sd	s11,24(sp)
    10be:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    10c0:	0005c903          	lbu	s2,0(a1)
    10c4:	18090f63          	beqz	s2,1262 <vprintf+0x1c0>
    10c8:	8aaa                	mv	s5,a0
    10ca:	8b32                	mv	s6,a2
    10cc:	00158493          	addi	s1,a1,1
  state = 0;
    10d0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    10d2:	02500a13          	li	s4,37
      if(c == 'd'){
    10d6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    10da:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    10de:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    10e2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10e6:	00000b97          	auipc	s7,0x0
    10ea:	78ab8b93          	addi	s7,s7,1930 # 1870 <digits>
    10ee:	a839                	j	110c <vprintf+0x6a>
        putc(fd, c);
    10f0:	85ca                	mv	a1,s2
    10f2:	8556                	mv	a0,s5
    10f4:	00000097          	auipc	ra,0x0
    10f8:	ee2080e7          	jalr	-286(ra) # fd6 <putc>
    10fc:	a019                	j	1102 <vprintf+0x60>
    } else if(state == '%'){
    10fe:	01498f63          	beq	s3,s4,111c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    1102:	0485                	addi	s1,s1,1
    1104:	fff4c903          	lbu	s2,-1(s1)
    1108:	14090d63          	beqz	s2,1262 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    110c:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1110:	fe0997e3          	bnez	s3,10fe <vprintf+0x5c>
      if(c == '%'){
    1114:	fd479ee3          	bne	a5,s4,10f0 <vprintf+0x4e>
        state = '%';
    1118:	89be                	mv	s3,a5
    111a:	b7e5                	j	1102 <vprintf+0x60>
      if(c == 'd'){
    111c:	05878063          	beq	a5,s8,115c <vprintf+0xba>
      } else if(c == 'l') {
    1120:	05978c63          	beq	a5,s9,1178 <vprintf+0xd6>
      } else if(c == 'x') {
    1124:	07a78863          	beq	a5,s10,1194 <vprintf+0xf2>
      } else if(c == 'p') {
    1128:	09b78463          	beq	a5,s11,11b0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    112c:	07300713          	li	a4,115
    1130:	0ce78663          	beq	a5,a4,11fc <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1134:	06300713          	li	a4,99
    1138:	0ee78e63          	beq	a5,a4,1234 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    113c:	11478863          	beq	a5,s4,124c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1140:	85d2                	mv	a1,s4
    1142:	8556                	mv	a0,s5
    1144:	00000097          	auipc	ra,0x0
    1148:	e92080e7          	jalr	-366(ra) # fd6 <putc>
        putc(fd, c);
    114c:	85ca                	mv	a1,s2
    114e:	8556                	mv	a0,s5
    1150:	00000097          	auipc	ra,0x0
    1154:	e86080e7          	jalr	-378(ra) # fd6 <putc>
      }
      state = 0;
    1158:	4981                	li	s3,0
    115a:	b765                	j	1102 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    115c:	008b0913          	addi	s2,s6,8
    1160:	4685                	li	a3,1
    1162:	4629                	li	a2,10
    1164:	000b2583          	lw	a1,0(s6)
    1168:	8556                	mv	a0,s5
    116a:	00000097          	auipc	ra,0x0
    116e:	e8e080e7          	jalr	-370(ra) # ff8 <printint>
    1172:	8b4a                	mv	s6,s2
      state = 0;
    1174:	4981                	li	s3,0
    1176:	b771                	j	1102 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1178:	008b0913          	addi	s2,s6,8
    117c:	4681                	li	a3,0
    117e:	4629                	li	a2,10
    1180:	000b2583          	lw	a1,0(s6)
    1184:	8556                	mv	a0,s5
    1186:	00000097          	auipc	ra,0x0
    118a:	e72080e7          	jalr	-398(ra) # ff8 <printint>
    118e:	8b4a                	mv	s6,s2
      state = 0;
    1190:	4981                	li	s3,0
    1192:	bf85                	j	1102 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1194:	008b0913          	addi	s2,s6,8
    1198:	4681                	li	a3,0
    119a:	4641                	li	a2,16
    119c:	000b2583          	lw	a1,0(s6)
    11a0:	8556                	mv	a0,s5
    11a2:	00000097          	auipc	ra,0x0
    11a6:	e56080e7          	jalr	-426(ra) # ff8 <printint>
    11aa:	8b4a                	mv	s6,s2
      state = 0;
    11ac:	4981                	li	s3,0
    11ae:	bf91                	j	1102 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    11b0:	008b0793          	addi	a5,s6,8
    11b4:	f8f43423          	sd	a5,-120(s0)
    11b8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    11bc:	03000593          	li	a1,48
    11c0:	8556                	mv	a0,s5
    11c2:	00000097          	auipc	ra,0x0
    11c6:	e14080e7          	jalr	-492(ra) # fd6 <putc>
  putc(fd, 'x');
    11ca:	85ea                	mv	a1,s10
    11cc:	8556                	mv	a0,s5
    11ce:	00000097          	auipc	ra,0x0
    11d2:	e08080e7          	jalr	-504(ra) # fd6 <putc>
    11d6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    11d8:	03c9d793          	srli	a5,s3,0x3c
    11dc:	97de                	add	a5,a5,s7
    11de:	0007c583          	lbu	a1,0(a5)
    11e2:	8556                	mv	a0,s5
    11e4:	00000097          	auipc	ra,0x0
    11e8:	df2080e7          	jalr	-526(ra) # fd6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    11ec:	0992                	slli	s3,s3,0x4
    11ee:	397d                	addiw	s2,s2,-1
    11f0:	fe0914e3          	bnez	s2,11d8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    11f4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    11f8:	4981                	li	s3,0
    11fa:	b721                	j	1102 <vprintf+0x60>
        s = va_arg(ap, char*);
    11fc:	008b0993          	addi	s3,s6,8
    1200:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    1204:	02090163          	beqz	s2,1226 <vprintf+0x184>
        while(*s != 0){
    1208:	00094583          	lbu	a1,0(s2)
    120c:	c9a1                	beqz	a1,125c <vprintf+0x1ba>
          putc(fd, *s);
    120e:	8556                	mv	a0,s5
    1210:	00000097          	auipc	ra,0x0
    1214:	dc6080e7          	jalr	-570(ra) # fd6 <putc>
          s++;
    1218:	0905                	addi	s2,s2,1
        while(*s != 0){
    121a:	00094583          	lbu	a1,0(s2)
    121e:	f9e5                	bnez	a1,120e <vprintf+0x16c>
        s = va_arg(ap, char*);
    1220:	8b4e                	mv	s6,s3
      state = 0;
    1222:	4981                	li	s3,0
    1224:	bdf9                	j	1102 <vprintf+0x60>
          s = "(null)";
    1226:	00000917          	auipc	s2,0x0
    122a:	64290913          	addi	s2,s2,1602 # 1868 <malloc+0x4fc>
        while(*s != 0){
    122e:	02800593          	li	a1,40
    1232:	bff1                	j	120e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    1234:	008b0913          	addi	s2,s6,8
    1238:	000b4583          	lbu	a1,0(s6)
    123c:	8556                	mv	a0,s5
    123e:	00000097          	auipc	ra,0x0
    1242:	d98080e7          	jalr	-616(ra) # fd6 <putc>
    1246:	8b4a                	mv	s6,s2
      state = 0;
    1248:	4981                	li	s3,0
    124a:	bd65                	j	1102 <vprintf+0x60>
        putc(fd, c);
    124c:	85d2                	mv	a1,s4
    124e:	8556                	mv	a0,s5
    1250:	00000097          	auipc	ra,0x0
    1254:	d86080e7          	jalr	-634(ra) # fd6 <putc>
      state = 0;
    1258:	4981                	li	s3,0
    125a:	b565                	j	1102 <vprintf+0x60>
        s = va_arg(ap, char*);
    125c:	8b4e                	mv	s6,s3
      state = 0;
    125e:	4981                	li	s3,0
    1260:	b54d                	j	1102 <vprintf+0x60>
    }
  }
}
    1262:	70e6                	ld	ra,120(sp)
    1264:	7446                	ld	s0,112(sp)
    1266:	74a6                	ld	s1,104(sp)
    1268:	7906                	ld	s2,96(sp)
    126a:	69e6                	ld	s3,88(sp)
    126c:	6a46                	ld	s4,80(sp)
    126e:	6aa6                	ld	s5,72(sp)
    1270:	6b06                	ld	s6,64(sp)
    1272:	7be2                	ld	s7,56(sp)
    1274:	7c42                	ld	s8,48(sp)
    1276:	7ca2                	ld	s9,40(sp)
    1278:	7d02                	ld	s10,32(sp)
    127a:	6de2                	ld	s11,24(sp)
    127c:	6109                	addi	sp,sp,128
    127e:	8082                	ret

0000000000001280 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1280:	715d                	addi	sp,sp,-80
    1282:	ec06                	sd	ra,24(sp)
    1284:	e822                	sd	s0,16(sp)
    1286:	1000                	addi	s0,sp,32
    1288:	e010                	sd	a2,0(s0)
    128a:	e414                	sd	a3,8(s0)
    128c:	e818                	sd	a4,16(s0)
    128e:	ec1c                	sd	a5,24(s0)
    1290:	03043023          	sd	a6,32(s0)
    1294:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1298:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    129c:	8622                	mv	a2,s0
    129e:	00000097          	auipc	ra,0x0
    12a2:	e04080e7          	jalr	-508(ra) # 10a2 <vprintf>
}
    12a6:	60e2                	ld	ra,24(sp)
    12a8:	6442                	ld	s0,16(sp)
    12aa:	6161                	addi	sp,sp,80
    12ac:	8082                	ret

00000000000012ae <printf>:

void
printf(const char *fmt, ...)
{
    12ae:	711d                	addi	sp,sp,-96
    12b0:	ec06                	sd	ra,24(sp)
    12b2:	e822                	sd	s0,16(sp)
    12b4:	1000                	addi	s0,sp,32
    12b6:	e40c                	sd	a1,8(s0)
    12b8:	e810                	sd	a2,16(s0)
    12ba:	ec14                	sd	a3,24(s0)
    12bc:	f018                	sd	a4,32(s0)
    12be:	f41c                	sd	a5,40(s0)
    12c0:	03043823          	sd	a6,48(s0)
    12c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    12c8:	00840613          	addi	a2,s0,8
    12cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    12d0:	85aa                	mv	a1,a0
    12d2:	4505                	li	a0,1
    12d4:	00000097          	auipc	ra,0x0
    12d8:	dce080e7          	jalr	-562(ra) # 10a2 <vprintf>
}
    12dc:	60e2                	ld	ra,24(sp)
    12de:	6442                	ld	s0,16(sp)
    12e0:	6125                	addi	sp,sp,96
    12e2:	8082                	ret

00000000000012e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    12e4:	1141                	addi	sp,sp,-16
    12e6:	e422                	sd	s0,8(sp)
    12e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    12ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12ee:	00000797          	auipc	a5,0x0
    12f2:	5a27b783          	ld	a5,1442(a5) # 1890 <freep>
    12f6:	a805                	j	1326 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    12f8:	4618                	lw	a4,8(a2)
    12fa:	9db9                	addw	a1,a1,a4
    12fc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1300:	6398                	ld	a4,0(a5)
    1302:	6318                	ld	a4,0(a4)
    1304:	fee53823          	sd	a4,-16(a0)
    1308:	a091                	j	134c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    130a:	ff852703          	lw	a4,-8(a0)
    130e:	9e39                	addw	a2,a2,a4
    1310:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1312:	ff053703          	ld	a4,-16(a0)
    1316:	e398                	sd	a4,0(a5)
    1318:	a099                	j	135e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    131a:	6398                	ld	a4,0(a5)
    131c:	00e7e463          	bltu	a5,a4,1324 <free+0x40>
    1320:	00e6ea63          	bltu	a3,a4,1334 <free+0x50>
{
    1324:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1326:	fed7fae3          	bgeu	a5,a3,131a <free+0x36>
    132a:	6398                	ld	a4,0(a5)
    132c:	00e6e463          	bltu	a3,a4,1334 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1330:	fee7eae3          	bltu	a5,a4,1324 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1334:	ff852583          	lw	a1,-8(a0)
    1338:	6390                	ld	a2,0(a5)
    133a:	02059713          	slli	a4,a1,0x20
    133e:	9301                	srli	a4,a4,0x20
    1340:	0712                	slli	a4,a4,0x4
    1342:	9736                	add	a4,a4,a3
    1344:	fae60ae3          	beq	a2,a4,12f8 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1348:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    134c:	4790                	lw	a2,8(a5)
    134e:	02061713          	slli	a4,a2,0x20
    1352:	9301                	srli	a4,a4,0x20
    1354:	0712                	slli	a4,a4,0x4
    1356:	973e                	add	a4,a4,a5
    1358:	fae689e3          	beq	a3,a4,130a <free+0x26>
  } else
    p->s.ptr = bp;
    135c:	e394                	sd	a3,0(a5)
  freep = p;
    135e:	00000717          	auipc	a4,0x0
    1362:	52f73923          	sd	a5,1330(a4) # 1890 <freep>
}
    1366:	6422                	ld	s0,8(sp)
    1368:	0141                	addi	sp,sp,16
    136a:	8082                	ret

000000000000136c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    136c:	7139                	addi	sp,sp,-64
    136e:	fc06                	sd	ra,56(sp)
    1370:	f822                	sd	s0,48(sp)
    1372:	f426                	sd	s1,40(sp)
    1374:	f04a                	sd	s2,32(sp)
    1376:	ec4e                	sd	s3,24(sp)
    1378:	e852                	sd	s4,16(sp)
    137a:	e456                	sd	s5,8(sp)
    137c:	e05a                	sd	s6,0(sp)
    137e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1380:	02051493          	slli	s1,a0,0x20
    1384:	9081                	srli	s1,s1,0x20
    1386:	04bd                	addi	s1,s1,15
    1388:	8091                	srli	s1,s1,0x4
    138a:	0014899b          	addiw	s3,s1,1
    138e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1390:	00000517          	auipc	a0,0x0
    1394:	50053503          	ld	a0,1280(a0) # 1890 <freep>
    1398:	c515                	beqz	a0,13c4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    139a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    139c:	4798                	lw	a4,8(a5)
    139e:	02977f63          	bgeu	a4,s1,13dc <malloc+0x70>
    13a2:	8a4e                	mv	s4,s3
    13a4:	0009871b          	sext.w	a4,s3
    13a8:	6685                	lui	a3,0x1
    13aa:	00d77363          	bgeu	a4,a3,13b0 <malloc+0x44>
    13ae:	6a05                	lui	s4,0x1
    13b0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    13b4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    13b8:	00000917          	auipc	s2,0x0
    13bc:	4d890913          	addi	s2,s2,1240 # 1890 <freep>
  if(p == (char*)-1)
    13c0:	5afd                	li	s5,-1
    13c2:	a88d                	j	1434 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    13c4:	00000797          	auipc	a5,0x0
    13c8:	4d478793          	addi	a5,a5,1236 # 1898 <base>
    13cc:	00000717          	auipc	a4,0x0
    13d0:	4cf73223          	sd	a5,1220(a4) # 1890 <freep>
    13d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    13d6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    13da:	b7e1                	j	13a2 <malloc+0x36>
      if(p->s.size == nunits)
    13dc:	02e48b63          	beq	s1,a4,1412 <malloc+0xa6>
        p->s.size -= nunits;
    13e0:	4137073b          	subw	a4,a4,s3
    13e4:	c798                	sw	a4,8(a5)
        p += p->s.size;
    13e6:	1702                	slli	a4,a4,0x20
    13e8:	9301                	srli	a4,a4,0x20
    13ea:	0712                	slli	a4,a4,0x4
    13ec:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    13ee:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    13f2:	00000717          	auipc	a4,0x0
    13f6:	48a73f23          	sd	a0,1182(a4) # 1890 <freep>
      return (void*)(p + 1);
    13fa:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    13fe:	70e2                	ld	ra,56(sp)
    1400:	7442                	ld	s0,48(sp)
    1402:	74a2                	ld	s1,40(sp)
    1404:	7902                	ld	s2,32(sp)
    1406:	69e2                	ld	s3,24(sp)
    1408:	6a42                	ld	s4,16(sp)
    140a:	6aa2                	ld	s5,8(sp)
    140c:	6b02                	ld	s6,0(sp)
    140e:	6121                	addi	sp,sp,64
    1410:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1412:	6398                	ld	a4,0(a5)
    1414:	e118                	sd	a4,0(a0)
    1416:	bff1                	j	13f2 <malloc+0x86>
  hp->s.size = nu;
    1418:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    141c:	0541                	addi	a0,a0,16
    141e:	00000097          	auipc	ra,0x0
    1422:	ec6080e7          	jalr	-314(ra) # 12e4 <free>
  return freep;
    1426:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    142a:	d971                	beqz	a0,13fe <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    142c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    142e:	4798                	lw	a4,8(a5)
    1430:	fa9776e3          	bgeu	a4,s1,13dc <malloc+0x70>
    if(p == freep)
    1434:	00093703          	ld	a4,0(s2)
    1438:	853e                	mv	a0,a5
    143a:	fef719e3          	bne	a4,a5,142c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    143e:	8552                	mv	a0,s4
    1440:	00000097          	auipc	ra,0x0
    1444:	b76080e7          	jalr	-1162(ra) # fb6 <sbrk>
  if(p == (char*)-1)
    1448:	fd5518e3          	bne	a0,s5,1418 <malloc+0xac>
        return 0;
    144c:	4501                	li	a0,0
    144e:	bf45                	j	13fe <malloc+0x92>
