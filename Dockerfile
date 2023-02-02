FROM ubuntu:latest

RUN apt update \
&& apt upgrade -y \
&& apt install git -y \
&& apt install cmake -y \
&& apt install pkg-config -y \
&& apt install libtool-bin -y \
&& apt install build-essential -y \
&& apt install unzip -y \
&& apt install gettext -y

## plugin dependencies
RUN apt install python3 -y \
&& apt install python3-venv -y \
&& apt install clang-format -y

# neovim install from source
RUN git clone https://github.com/neovim/neovim.git \
&& cd /neovim \
&& make install \
&& rm -rf /neovim

RUN mkdir -p /root/.config/nvim
COPY nvim /root/.config/nvim
