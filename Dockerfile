FROM node:jod-slim

ENV VERSION=1.0.0 \
    NODE_ENV=production \
    PORT=3000 \
    HOME=/home/arunacore

LABEL name="ArunaCore" \
      version=$VERSION \
      maintainer="LoboMetalurgico <lobometalurgico@allonsve.com>" \
      org.opencontainers.image.source="https://github.com/ArunaBot/ArunaCore-Docker/" \
      org.opencontainers.image.version=$VERSION \
      org.opencontainers.image.vendor="LoboMetalurgico" \
      org.opencontainers.image.title="ArunaCore" \
      org.opencontainers.image.description="ArunaCore is an open source websocket server made with nodejs for intercomunication between applications." \
      org.opencontainers.image.licenses="GPL-3.0"

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates unzip curl && \
    rm -rf /var/lib/apt/lists/*

RUN useradd --system --create-home --shell /bin/sh --user-group arunacore && \
    mkdir -p ${HOME}/.ssh ${HOME}/ArunaCore && \
    touch ${HOME}/.ssh/authorized_keys && \
    chown -R arunacore:arunacore ${HOME} && \
    chmod 700 ${HOME}/.ssh

WORKDIR ${HOME}/ArunaCore

RUN npm install -g npm

# Fix a NPM bug with permissions
RUN chown -R 999:999 ${HOME}/.npm || true

RUN curl -L https://github.com/ArunaBot/ArunaCore/releases/latest/download/arunacore.zip -o arunacore.zip && \
    unzip arunacore.zip && rm arunacore.zip && \
    chown -R arunacore:arunacore .

USER arunacore

RUN npm ci

EXPOSE 3000/tcp

HEALTHCHECK --interval=30s --timeout=5s CMD curl -f http://localhost:$PORT/healthcheck || exit 1

CMD ["npm", "start"]
