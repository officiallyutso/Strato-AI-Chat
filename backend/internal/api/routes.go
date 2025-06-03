package api

import (
    "github.com/gin-gonic/gin"
    "github.com/officiallyutso/strato-ai-backend/internal/llm"
    "github.com/officiallyutso/strato-ai-backend/internal/storage"
    "github.com/officiallyutso/strato-ai-backend/internal/models"
    "net/http"
    "time"
    "github.com/google/uuid"
)

func SetupRoutes(r *gin.Engine) {
    r.GET("/ping", func(c *gin.Context) {
        c.JSON(200, gin.H{"message": "pong"})
    })

    // LLM routes
    r.POST("/prompt", llm.HandlePrompt)
    
    // Chat history routes
    r.GET("/chats/:userID", getChats)
    r.GET("/chat/:chatID", getChat)
    r.PUT("/chat/:chatID/select/:responseID", selectResponse)
    
    // API key management
    r.POST("/apikey", saveAPIKey)
    r.GET("/apikeys/:userID", getUserAPIKeys)
    
    // Available LLM providers
    r.GET("/providers", getProviders)
}

// getChats retrieves all chats for a user
func getChats(c *gin.Context) {
    userID := c.Param("userID")
    chats, err := storage.GetUserChats(userID)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusOK, chats)
}

// getChat retrieves a specific chat by ID
func getChat(c *gin.Context) {
    chatID := c.Param("chatID")
    chat, err := storage.GetChat(chatID)
    if err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "chat not found"})
        return
    }
    c.JSON(http.StatusOK, chat)
}
