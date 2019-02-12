FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

RUN apt-get update && apt-get install -y apt-utils

RUN apt-get install -y build-essential git gcc g++ gcc-6 g++-6 libpython3-dev python3-dev libatlas-base-dev autoconf make automake cmake git libtool subversion libapache2-mod-svn wget curl zlib1g-dev gawk grep make perl flac swig sox htop unzip nano

RUN wget https://repo.continuum.io/miniconda/Miniconda2-4.5.12-Linux-x86_64.sh
RUN bash Miniconda2-4.5.12-Linux-x86_64.sh -b
RUN rm Miniconda2-4.5.12-Linux-x86_64.sh

# Set path to conda
ENV PATH /root/miniconda2/bin:$PATH

RUN ldconfig

RUN pip install --upgrade pip

RUN cd && mkdir kaldi && git clone https://github.com/kaldi-asr/kaldi.git kaldi --origin upstream

#RUN dpkg --configure -a

#RUN apt-get install -y nvidia-cuda-toolkit 

RUN ldconfig

ENV CXX=g++-6

WORKDIR /root/kaldi/tools

RUN ./extras/check_dependencies.sh && make -j 8

WORKDIR /root/kaldi/src

RUN ./configure --shared && make clean -j 8 && make depend -j 8 && make -j 8

COPY srilm.tgz /root/kaldi/tools
RUN pip install numpy && cd && cd kaldi/tools && ./extras/install_sequitur.sh && ./extras/install_irstlm.sh && ./extras/install_srilm.sh && ./extras/install_beamformit.sh && ./extras/install_faster_rnnlm.sh && ./extras/install_ffv.sh && ./extras/install_jieba.sh && ./extras/install_morfessor.sh && ./extras/install_mpg123.sh && ./extras/install_phonetisaurus.sh && ./extras/install_pocolm.sh && ./extras/install_portaudio.sh && ./extras/install_sctk_patched.sh && ./extras/install_speex.sh

WORKDIR /root

