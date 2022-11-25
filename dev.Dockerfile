# IMAGE FOR BUILDING
FROM golang:1.19.3-alpine3.16 as lnd

RUN apk --no-cache add \
    bash \
    su-exec \
    ca-certificates \
    make

ENV CGO_ENABLED=0

COPY ./lnd /go/src/github.com/lightningnetwork/lnd

RUN cd /go/src/github.com/lightningnetwork/lnd \
    &&  make \
    &&  make install tags="signrpc walletrpc chainrpc invoicesrpc peersrpc"

# Start a new, final image to reduce size.
FROM lnd as final

# Expose lnd ports (server, rpc).
EXPOSE 9735 10009

# Copy the binaries and entrypoint from the builder image.
COPY --from=lnd /go/bin/lncli /bin/
COPY --from=lnd /go/bin/lnd /bin/


# FINAL IMAGE
COPY ./taro /go/src/github.com/taro
RUN cd /go/src/github.com/taro \
    && make install
RUN mv /go/bin/tarod /bin/
RUN mv /go/bin/tarocli /bin/

WORKDIR /
COPY ./taro/docker-entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh
VOLUME ["/home/taro/.taro"]
VOLUME ["/go/src/github.com/taro"]

EXPOSE 10029
EXPOSE 8089


#ENTRYPOINT ["/bin/sh"]