FROM node:gallium-slim
ENV VERSION 1.0.0

LABEL name="ArunaCore"
LABEL version=$VERSION
LABEL mantainer="LoboMetalurgico <lobometalurgico@allonsve.com>"
LABEL org.opencontainers.image.source="https://github.com/ArunaBot/ArunaCore-Docker/"
LABEL org.opencontainers.image.version=$VERSION
LABEL org.opencontainers.image.VENDOR="LoboMetalurgico"
LABEL org.opencontainers.image.title="ArunaCore"
LABEL org.opencontainers.image.description="ArunaCore is an open source websocket server made with nodejs for intercomunication between applications."
LABEL org.opencontainers.image.licenses="GPL-3.0"

HEALTHCHECK --interval=30s --timeout=5s CMD curl -f http://localhost:$PORT/healthCheck || exit 1

# Add user early to get a consistent userid
# - the root group so it can run with any uid
# - the tty group for /dev/std* access
RUN \
  useradd --shell /bin/sh --user-group arunacore --groups root,tty \
  && mkdir -p /home/arunacore/.ssh \
  && touch /home/arunacore/.ssh/authorized_keys \
  && chown -R arunacore:arunacore /home/arunacore \
  && chmod 700 /home/arunacore/.ssh

# Home directory
ENV HOME=/home/arunacore

RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y \
    git \
    unzip \
    wget \
    curl

# Install ArunaCore
RUN \
    git clone https://github.com/ArunaBot/ArunaCore $HOME

# Set NODE_ENV to production
ENV NODE_ENV=production

# Set the working directory to ArunaCore bundle
WORKDIR $HOME/bundle

RUN npm run setup

# Expose the port
EXPOSE 3000/tcp

# Run ArunaCore
CMD ["npm", "start", "--ignore-scripts"]
