FROM golang:1.25-alpine

WORKDIR /app

COPY . .

RUN go mod tidy || true

RUN go build -o auth-api ./services/auth

CMD ["./auth-api"]
