FROM node:gallium-slim
ENV VERSION 1.0.0
ENV BRANCH unstable

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
    ca-certificates \
    unzip \
    curl

WORKDIR ${HOME}

# Download ArunaCore
RUN curl -L https://github.com/ArunaBot/ArunaCore/archive/refs/heads/${BRANCH}.zip -o arunacore.zip

# Unzip ArunaCore
RUN unzip arunacore.zip

# Rename ArunaCore folder
RUN mv ArunaCore-${BRANCH} ArunaCore

# Delete ArunaCore.zip
RUN rm arunacore.zip

# Set the working directory to ArunaCore bundle
WORKDIR ${HOME}/ArunaCore/bundle

# Upgrade NPM
RUN npm install -g npm@8.x

# Setup ArunaCore
RUN npm run cisetup

# Set NODE_ENV to production
ENV NODE_ENV=production

# Run build cleanup tasks
RUN npm run docker:cleanup

# Remove apt packages
RUN apt-get remove -y unzip curl ca-certificates \
    && apt-get autoremove -y \
    && apt-get clean \
    && apt-get autoclean

# Expose the port
EXPOSE 3000/tcp

# Run ArunaCore
CMD ["npm", "start"]
