FROM golang:1.25-alpine

WORKDIR /app

# Copy the entire horta-api context
COPY . .

# Run mod download and tidy if necessary (since we manually created go.mod)
RUN go mod tidy || true

# Build the survey service
RUN go build -o survey-api ./services/survey

CMD ["./survey-api"]
