FROM alpine

RUN apk add curl git zsh python3 ansible docker-cli

# default user
RUN addgroup -S riley && adduser -S riley -G riley
USER riley
WORKDIR /home/riley

# ohmyzsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

RUN sed -i 's/^ZSH_THEME=.*/ZSH_THEME="gnzh"/' .zshrc \
  && sed 's/^plugins=.*/plugins=(git kubectl)/' .zshrc \
  && echo 'source <(kubectl completion zsh)' >> .zshrc

ENTRYPOINT /bin/zsh