FROM ubuntu:latest

RUN apt-get update && apt-get install -y curl

WORKDIR /app

COPY message.txt /app/

EXPOSE 8080

CMD ["cat", "/app/message.txt"]
