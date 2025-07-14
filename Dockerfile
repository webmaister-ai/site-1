# Multi-stage build for minimal Go static server
FROM golang:alpine AS server-builder

WORKDIR /app

# Create the Go static server
COPY <<EOL main.go
package main

import (
    "log"
    "net/http"
    "os"
    "path/filepath"
    "strings"
)

func main() {
    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }
    
    root := "./static"
    
    fs := &StaticServer{
        root:    http.Dir(root),
        handler: http.FileServer(http.Dir(root)),
    }
    
    http.Handle("/", fs)
    
    log.Printf("Static server starting on :%s", port)
    log.Fatal(http.ListenAndServe(":"+port, nil))
}

type StaticServer struct {
    root    http.Dir
    handler http.Handler
}

func (s *StaticServer) ServeHTTP(w http.ResponseWriter, r *http.Request) {
    // Security: prevent directory traversal
    if strings.Contains(r.URL.Path, "..") {
        http.Error(w, "Invalid path", http.StatusBadRequest)
        return
    }
    
    // Add cache headers
    if isStaticAsset(r.URL.Path) {
        // Static assets: 1 day with revalidation
        w.Header().Set("Cache-Control", "public, max-age=86400, must-revalidate")
    } else {
        // HTML pages: 5 minutes
        w.Header().Set("Cache-Control", "public, max-age=300")
    }
    
    // Add security headers
    w.Header().Set("X-Content-Type-Options", "nosniff")
    w.Header().Set("X-Frame-Options", "DENY")
    w.Header().Set("X-XSS-Protection", "1; mode=block")
    
    s.handler.ServeHTTP(w, r)
}

func isStaticAsset(path string) bool {
    ext := strings.ToLower(filepath.Ext(path))
    staticExts := []string{".css", ".js", ".png", ".jpg", ".jpeg", ".gif", 
                          ".ico", ".svg", ".woff", ".woff2", ".ttf", ".eot"}
    
    for _, staticExt := range staticExts {
        if ext == staticExt {
            return true
        }
    }
    return false
}
EOL

# Build the Go server
RUN CGO_ENABLED=0 GOOS=linux go build -o server main.go

# Final minimal container
FROM scratch

# Copy the server binary and static files
COPY --from=server-builder /app/server /server
COPY _site /static

EXPOSE 8080
ENTRYPOINT ["/server"]