# Use an official Golang runtime as a parent image
FROM golang:1.20-alpine AS builder
# Set the working directory to /go/src/app
WORKDIR /go/src/app
# Copy the current directory contents into the container at /go/src/app
COPY . .
# Build the Go app with optimizations and strip debug symbols
RUN go build -ldflags="-s -w" -o app
# Use a minimal base image for the final image
FROM alpine:3.15
# Set the working directory to /app
WORKDIR /app
# Copy the binary from the builder stage
COPY --from=builder /go/src/app/app .
# Set the binary as the entry point of the container
ENTRYPOINT ["./app"]
# Set environment variable to disable the Go module cache
ENV GO111MODULE=on GOPROXY=https://proxy.golang.org,direct