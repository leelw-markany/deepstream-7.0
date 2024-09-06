FROM nvcr.io/nvidia/deepstream:7.0-gc-triton-devel

ENV LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

ENV CUDA_VER=12
WORKDIR /opt/nvidia/deepstream/deepstream/sources/apps