#FROM ubuntu:latest AS prerequisites
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 AS prerequisites

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
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 

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
&& apt install clangd -y \
&& apt install openssh-server -y

COPY --from=prerequisites /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=prerequisites /usr/local/share/nvim /usr/local/share/nvim

RUN mkdir -p /root/.config/nvim
COPY nvim /root/.config/nvim

# ssh support
RUN mkdir /var/run/sshd
RUN echo 'root:yourpassword' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
EXPOSE 22

# make sure user with ssh login still have cuda related in PATH
RUN echo 'export PATH="/usr/local/cuda/bin:/usr/local/cuda/bin:${PATH}"' >> /root/.bashrc

# create python env
ENV VIRTUAL_ENV=/opt/dev
RUN python3 -m venv $VIRTUAL_ENV
RUN echo "source $VIRTUAL_ENV/bin/activate" >> /root/.bashrc

CMD ["/usr/sbin/sshd", "-D"]

