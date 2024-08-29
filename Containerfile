FROM golang:1.22.3-alpine3.19 AS build
WORKDIR /app/src
COPY betterbell/ /app/src
RUN apk add --no-cache --update gcc musl-dev pkgconfig alsa-lib-dev
ENV CGO_ENABLED 1
RUN go build codeberg.org/logo/betterbell

FROM alpine:3.19
CMD ["/bin/sh"]
RUN apk add --no-cache --update pipewire pipewire-alsa alsa-utils
RUN addgroup root audio
WORKDIR /app/src
COPY --from=build /app/src/betterbell /app/src/
COPY --from=build /app/src/templates /app/src/templates
COPY --from=build /app/src/static /app/src/static
ENV DB_LOCATION /db/betterbell.db
CMD ["./betterbell"]
