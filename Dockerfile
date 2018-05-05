FROM ubuntu:16.04

RUN apt-get update && apt-get install -y locales git build-essential cmake libuv1-dev uuid-dev libmicrohttpd-dev

RUN dpkg-reconfigure locales && \
  locale-gen en_US.UTF-8 && \
  update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

RUN sed -i -e "s@constexpr const int kDonateLevel = 2@constexpr const int kDonateLevel = 0@" src/donate.h && mkdir build && cd build && \
  cmake .. -DCMAKE_BUILD_TYPE=Release -DUV_LIBRARY=/usr/lib/x86_64-linux-gnu/libuv.a && \
  make && mv xmrig-proxy /

FROM ubuntu:16.04
WORKDIR    /
RUN apt-get update && apt-get install -y libmicrohttpd10 && apt-get clean -y
COPY --from=0 /xmrig-proxy .
ENTRYPOINT ["./xmrig-proxy"]
