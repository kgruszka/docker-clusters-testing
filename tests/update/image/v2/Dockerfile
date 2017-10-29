FROM alpine
RUN apk update && apk add curl
COPY int.sh int.sh

RUN  chmod +x ./int.sh

ENTRYPOINT ["./int.sh"]