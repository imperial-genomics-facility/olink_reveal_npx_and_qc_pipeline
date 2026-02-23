FROM ubuntu:26.04
ARG NGS2COUNTS_VERSION="6.2.0"
LABEL description="Docker image containing ngs2counts"
LABEL version="$NGS2COUNTS_VERSION"

RUN apt-get update \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ngs2counts /usr/bin/ngs2counts

RUN chmod a+x /usr/bin/ngs2counts

USER nobody

ENTRYPOINT ["ngs2counts"]