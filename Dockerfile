FROM ubuntu:18.04 AS env
RUN apt update && \
    apt-get install -y autoconf automake autotools-dev curl python3 \
    libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex \
    texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev \
    libglib2.0-dev libfdt-dev libpixman-1-dev vim && \
    apt clean

FROM env AS toolchain
RUN apt update && apt install -y git && apt clean
RUN git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
WORKDIR /riscv-gnu-toolchain
RUN ./configure --prefix=/opt/riscv && make linux -j `nproc`

FROM env AS qemu
RUN curl -O https://download.qemu.org/qemu-4.2.1.tar.xz && \
    tar -xvJf qemu-4.2.1.tar.xz
WORKDIR /qemu-4.2.1
RUN ./configure --target-list=riscv64-linux-user && make -j `nproc`

FROM env
COPY --from=toolchain /opt/riscv /opt/riscv
COPY --from=qemu /qemu-4.2.1/riscv64-linux-user/qemu-riscv64 /usr/local/bin/
RUN ln -s /opt/riscv/bin/* /usr/local/bin/
WORKDIR /root
