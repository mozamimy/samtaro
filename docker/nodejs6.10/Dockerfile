FROM 137112412989.dkr.ecr.ap-northeast-1.amazonaws.com/amazonlinux

ARG NVM_VERSION=v0.33.1
ARG NODE_VERSION=v6.10.2

RUN yum -y update && \
    yum -y groupinstall "Development Tools"

ENV NVM_DIR=$HOME/.nvm

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash && \
    source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

ENV NODE_PATH=$NVM_DIR/$NODE_VERSION/lib/node_modules
ENV PATH=$NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

CMD ["node", "--version"]
