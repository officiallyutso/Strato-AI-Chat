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


// selectResponse marks a response as selected in a chat
func selectResponse(c *gin.Context) {
    chatID := c.Param("chatID")
    responseID := c.Param("responseID")
    
    chat, err := storage.GetChat(chatID)
    if err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "chat not found"})
        return
    }
    
    chat.SelectedID = responseID
    _, err = storage.SaveChat(chat)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to update chat"})
        return
    }
    
    c.JSON(http.StatusOK, chat)
}

// saveAPIKey saves a user's API key
func saveAPIKey(c *gin.Context) {
    var apiKey models.APIKey
    if err := c.BindJSON(&apiKey); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "invalid payload"})
        return
    }
    
    apiKey.CreatedAt = time.Now()
    if apiKey.ID == "" {
        apiKey.ID = uuid.New().String()
    }
    
    err := storage.SaveAPIKey(apiKey)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to save API key"})
        return
    }
    
    c.JSON(http.StatusOK, apiKey)
}

// getUserAPIKeys retrieves all API keys for a user
func getUserAPIKeys(c *gin.Context) {
    userID := c.Param("userID")
    keys, err := storage.GetUserAPIKeys(userID)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusOK, keys)
}

// getProviders returns available LLM providers
func getProviders(c *gin.Context) {
    // In a real implementation, these would come from a database
    providers := []models.LLMProvider{
        {
            ID:          "huggingface",
            Name:        "HuggingFace",
            Description: "Access to open-source models hosted on HuggingFace",
            Models:      []string{"google/flan-t5-large", "facebook/bart-large-cnn"},
            RequiresKey: true,
        },
        {
            ID:          "gemini",
            Name:        "Google Gemini",
            Description: "Google's Gemini models via free API access",
            Models:      []string{"gemini-pro"},
            RequiresKey: true,
        },
        {
            ID:          "mistral",
            Name:        "Mistral AI",
            Description: "Mistral's open-weight models",
            Models:      []string{"mistral-small", "mistral-medium"},
            RequiresKey: true,
        },
    }
    
    c.JSON(http.StatusOK, providers)
}
