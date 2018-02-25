FROM alpine:3.7

COPY ./nsjail.patch /

RUN apk add --no-cache \
        libstdc++ \
        protobuf \
    && apk add --no-cache --virtual=.nsjail-build-deps \
        bison \
        bsd-compat-headers \
        build-base \
        flex \
        git \
        linux-headers \
        protobuf-dev \
    && git clone --depth=1 --branch=2.5 https://github.com/google/nsjail.git /nsjail \
    && cd /nsjail \
    && patch -p1 < /nsjail.patch \
    && make \
    && mv /nsjail/nsjail /usr/sbin \
    && rm -rf /nsjail /nsjail.patch \
    && apk del --purge .nsjail-build-deps

CMD ["/usr/sbin/nsjail", "-Mo", "--user", "99999", "--group", "99999", "--chroot", "/", "--", "/bin/sh"]
