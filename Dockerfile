FROM edenlabllc/elixir:1.9.1-otp-22-alpine as builder

ARG APP_NAME

ADD . /app

WORKDIR /app

ENV MIX_ENV=prod

RUN apk add git build-base
RUN mix do \
      local.hex --force, \
      local.rebar --force, \
      deps.get, \
      deps.compile

RUN mix release "${APP_NAME}"

RUN git log --pretty=format:"%H %cd %s" > commits.txt

FROM alpine:3.9

ARG APP_NAME

RUN apk add --no-cache \
      ncurses-libs \
      zlib \
      ca-certificates \
      openssl \
      bash

WORKDIR /app

COPY --from=builder /app/_build /app
COPY --from=builder /app/commits.txt /app

ENV REPLACE_OS_VARS=true \
      APP=${APP_NAME}

CMD prod/rel/${APP}/bin/${APP} start
