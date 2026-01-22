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

# ユーザー作成
ARG USERNAME=agent
RUN useradd -m -s /bin/zsh $USERNAME

# コマンド履歴の永続化
RUN mkdir /commandhistory \
  && touch /commandhistory/.bash_history \
  && chown -R $USERNAME /commandhistory

ENV DEVCONTAINER=true

# ワークスペースと設定ディレクトリ
RUN mkdir -p /workspace /home/$USERNAME/.claude /home/$USERNAME/.local/bin \
  && chown -R $USERNAME:$USERNAME /workspace /home/$USERNAME/.claude /home/$USERNAME/.local

WORKDIR /workspace

# ユーザー切り替え
USER $USERNAME

ENV SHELL=/bin/zsh
ENV PATH="/home/agent/.local/bin:$PATH"

# mise インストール
RUN curl https://mise.run | sh

# ファイアウォールスクリプト
COPY init-firewall.sh /usr/local/bin/
USER root
RUN chmod +x /usr/local/bin/init-firewall.sh && \
  echo "agent ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/agent-nopasswd && \
  chmod 0440 /etc/sudoers.d/agent-nopasswd
USER $USERNAME
