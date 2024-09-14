FROM ubuntu:latest AS prerequisites
#FROM arm64v8/ubuntu:latest AS prerequisites

RUN apt update
RUN apt upgrade -y
RUN apt install git -y
RUN apt install cmake -y
RUN apt install build-essential -y
RUN apt install unzip -y
RUN apt install wget -y
RUN apt install gettext -y

# neovim install from source
RUN git clone https://github.com/neovim/neovim.git \
&& cd /neovim \
&& make -j 8 install \
&& rm -rf /neovim

# FROM yourDesiredBaseImage
FROM ubuntu:latest 
#FROM arm64v8/ubuntu:latest 

RUN apt update \
&& apt upgrade -y \
&& apt install git -y \
&& apt install python3 -y \
&& apt install python3-venv -y \
&& apt install python3-pip -y \
&& apt install clang-format -y \
&& apt install build-essential -y \
&& apt install unzip -y \
&& apt install gettext -y \
&& apt install gdb -y \
&& apt install clangd -y

COPY --from=prerequisites /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=prerequisites /usr/local/share/nvim /usr/local/share/nvim

RUN mkdir -p /root/.config/nvim
COPY nvim /root/.config/nvim

# create python env
ENV VIRTUAL_ENV=/opt/dev
RUN python3 -m venv $VIRTUAL_ENV
RUN echo "source $VIRTUAL_ENV/bin/activate" >> /root/.bashrc

