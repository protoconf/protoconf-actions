FROM protoconf/protoconf:v0.1.0-pre2 AS protoconf
FROM ubuntu:latest

COPY --from=protoconf /app/cmd/protoconf/protoconf /protoconf
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
