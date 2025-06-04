package main

import (
    "github.com/gin-gonic/gin"
    "log"
    "github.com/officiallyutso/strato-ai-backend/internal/api"
    "github.com/officiallyutso/strato-ai-backend/internal/storage"
    "os"
    "github.com/gin-contrib/cors"
)

func main() {
    // Initialize Firestore
    serviceAccountPath := os.Getenv("GOOGLE_APPLICATION_CREDENTIALS")
    projectID := os.Getenv("FIREBASE_PROJECT_ID")
    if serviceAccountPath != "" && projectID != "" {
        if err := storage.InitFirestore(serviceAccountPath, projectID); err != nil {
            log.Fatalf("Failed to initialize Firestore: %v", err)
        }
    } else {
        log.Println("Warning: Firestore not initialized. Set GOOGLE_APPLICATION_CREDENTIALS and FIREBASE_PROJECT_ID env vars.")
    }

    r := gin.Default()
    
    // Configure CORS
    r.Use(cors.New(cors.Config{
        AllowOrigins:     []string{"*"},
        AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
        AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
        ExposeHeaders:    []string{"Content-Length"},
        AllowCredentials: true,
    }))

    api.SetupRoutes(r) // register endpoints

    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }

    log.Printf("Starting server at :%s", port)
    if err := r.Run(":" + port); err != nil {
        log.Fatalf("Failed to start: %v", err)
    }
}
