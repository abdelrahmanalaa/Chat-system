FROM golang:latest

WORKDIR /go/src/instabug

COPY . .
RUN go get .
RUN GOOS=linux go build -a -o build .

EXPOSE 3001

ENTRYPOINT ["./build"]