FROM golang:1.17 AS build

WORKDIR /usr/src/hello

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN CGO_ENABLED=0 go build -v -o /usr/local/bin/hello ./...

FROM scratch
COPY --from=build /usr/local/bin/hello /hello
ENTRYPOINT ["/hello"]