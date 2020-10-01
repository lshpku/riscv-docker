# riscv-docker
RISC-V toolchain and Qemu in Docker.

## Build
```bash
$ cd riscv-docker
$ docker build -t lshpku/riscv:64g_toolchain-v20200924_qemu-4.2.1 .
```

## Simple Test
```bash
$ docker run -it --rm lshpku/riscv:64g_toolchain-v20200924_qemu-4.2.1
$ cat <<EOF > hello.c
#include <stdio.h>
int main() {
    printf("Hello, world!\n");
}
EOF
$ riscv64-unknown-linux-gnu-gcc -o hello hello.c
$ qemu-riscv64 -L /opt/riscv/sysroot hello
# Hello, world!
$ exit
```