FROM golang:1.17
WORKDIR /gotty
COPY . /gotty
RUN apt-get update && apt-get install -y nodejs npm
RUN CGO_ENABLED=0 make

FROM alpine:latest
RUN apk update && \
    apk upgrade && \
    apk --no-cache add ca-certificates && \
    apk add bash && \
    apk add lnav
WORKDIR /root
COPY --from=0 /gotty/gotty /usr/bin/
CMD ["gotty", "-w", "-p", "6383", "lnav", "/docker/logs/*.log"]
EXPOSE 6383