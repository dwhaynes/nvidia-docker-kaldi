FROM ubuntu:18.04

RUN apt-get update && apt-get install -y apt-utils 

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git gcc g++ gcc-6 g++-6 libpython3-dev python3-dev libatlas-base-dev autoconf make automake cmake git libtool subversion libapache2-mod-svn wget curl zlib1g-dev gawk grep make perl flac swig sox htop unzip

RUN wget https://repo.continuum.io/miniconda/Miniconda2-4.4.10-Linux-x86_64.sh
RUN bash Miniconda2-4.4.10-Linux-x86_64.sh -b
RUN rm Miniconda2-4.4.10-Linux-x86_64.sh

# Set path to conda
ENV PATH /root/miniconda2/bin:$PATH

RUN ldconfig

RUN pip install --upgrade pip

RUN cd && mkdir kaldi && git clone https://github.com/kaldi-asr/kaldi.git kaldi --origin upstream 

RUN export CXX=g++-6

RUN cd && cd kaldi/tools && ./extras/check_dependencies.sh && make -j 8

RUN cd && cd kaldi/src && ./configure --shared && make depend -j 8 && make -j 8

RUN cd && cd kaldi/tools && ./extras/install_irstlm.sh

COPY srilm.tgz /root/kaldi/tools
RUN cd && cd kaldi/tools && ./extras/install_srilm.sh

RUN fallocate -l 10G /swapfile2 && dd if=/dev/zero of=/swapfile2 bs=1k count=10240k && mkswap /swapfile2 && echo "/swapfile2 swap swap auto 0 0" | tee -a /etc/fstab && chmod 0600 /swapfile2

