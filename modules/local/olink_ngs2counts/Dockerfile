FROM ubuntu:26.04
ARG NGS2COUNT_VERSION=""
LABEL description="Docker image containing ngs2count"
LABEL version="$NGS2COUNT_VERSION"

RUN apt-get update \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ngs2count /usr/bin/ngs2count

RUN chmod a+x /usr/bin/ngs2count

USER nobody

ENTRYPOINT ["ngs2count"]