FROM debian:latest

ARG USERNAME=appuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ENV GEM_HOME=/var/app/.gems

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo make build-essential autoconf zlib1g-dev ruby ruby-dev locales \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

WORKDIR /var/app
COPY . /var/app

USER $USERNAME
RUN sudo chown -R $USER_UID:$USER_GID /var/app  \
    && sudo gem install bundler \
    && bundle config set path '/var/app/vendor/bundle' \
    && echo "en_US UTF-8" | sudo tee -a /etc/locale.gen \
    && sudo locale-gen en_US.UTF-8
