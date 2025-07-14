# Build your 11ty site
FROM node:alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Create minimal server
FROM golang:alpine AS server
COPY <<EOF main.go
package main
import (
    "log"
    "net/http"
    "os"
)
func main() {
    port := os.Getenv("PORT")
    if port == "" { port = "8080" }
    fs := http.FileServer(http.Dir("./static"))
    http.Handle("/", fs)
    log.Fatal(http.ListenAndServe(":"+port, nil))
}
EOF
RUN CGO_ENABLED=0 go build -o server main.go

# Final minimal container
FROM scratch
COPY --from=server /go/server /server
COPY --from=builder /app/_site /static
EXPOSE 8080
ENTRYPOINT ["/server"]