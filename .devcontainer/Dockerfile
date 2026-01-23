FROM node:22

ARG TZ
ENV TZ="$TZ"

# 基本パッケージ + ファイアウォール関連（miseで入れられないもの）
RUN apt-get update && apt-get install -y --no-install-recommends \
  git \
  curl \
  sudo \
  zsh \
  locales \
  build-essential \
  # ファイアウォールスクリプト用
  iptables \
  ipset \
  iproute2 \
  dnsutils \
  aggregate \
  jq \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
  && locale-gen

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ARG USERNAME=node

# コマンド履歴の永続化
RUN mkdir /commandhistory \
  && touch /commandhistory/.bash_history \
  && chown -R $USERNAME /commandhistory

ENV DEVCONTAINER=true

# ワークスペースと設定ディレクトリ
RUN mkdir -p /workspace /home/node/.claude /home/node/.local/bin \
  && chown -R node:node /workspace /home/node/.claude /home/node/.local

WORKDIR /workspace

# ユーザー切り替え
USER node

ENV SHELL=/bin/zsh
ENV PATH="/home/node/.local/bin:$PATH"

# mise インストール
RUN curl https://mise.run | sh

# ファイアウォールスクリプト
COPY init-firewall.sh /usr/local/bin/
USER root
RUN chmod +x /usr/local/bin/init-firewall.sh && \
  echo "node ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/node-firewall && \
  chmod 0440 /etc/sudoers.d/node-firewall
USER node
