package main

import (
    "github.com/gin-gonic/gin"
    "log"
    "github.com/officiallyutso/strato-ai-backend/internal/api"
	
)

func main() {
    r := gin.Default()

    api.SetupRoutes(r) // register endpoints

    log.Println("Starting server at :8080")
    if err := r.Run(":8080"); err != nil {
        log.Fatalf("Failed to start: %v", err)
    }
}
