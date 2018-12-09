FROM golang:1.11 as builder
WORKDIR /module
COPY ./src/ /module
RUN CGO_ENABLED=0 GOOS=linux go build -o ./bin/app

FROM alpine
RUN apk add tzdata && \
    cp /usr/share/zoneinfo/Asia/Bangkok /etc/localtime && \
    echo "Asia/Bangkok" >  /etc/timezone && \
    apk del tzdata
WORKDIR /root/
COPY --from=builder /module/bin .
EXPOSE 3000

ENV GIN_MODE release
CMD ./app 
