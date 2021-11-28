FROM debian:stable-slim

LABEL "author"="Tony Spegel"

LABEL "com.github.actions.name"="Build & bundle with Zola & RollUp, deploy to GH Pages"
LABEL "com.github.actions.description"="Build and deploy a Zola site to GitHub Pages and bundle its imports"
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="gray"

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get update && apt-get install -y wget git

RUN wget -q -O - \
    "https://github.com/getzola/zola/releases/download/v0.14.1/zola-v0.14.1-x86_64-unknown-linux-gnu.tar.gz" \
    | tar xzf - -C /usr/local/bin

COPY build.sh /build.sh

ENTRYPOINT ["/build.sh"]
