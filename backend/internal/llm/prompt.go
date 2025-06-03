package llm

import (
    "bytes"
    "encoding/json"
    "net/http"
    "time"
    "github.com/gin-gonic/gin"
    "github.com/google/uuid"
    "github.com/officiallyutso/strato-ai-backend/internal/models"
    "github.com/officiallyutso/strato-ai-backend/internal/storage"
)

type PromptRequest struct {
    Prompt    string   `json:"prompt"`
    Providers []string `json:"providers"` // List of provider IDs to query
    UserID    string   `json:"user_id"`
}

type PromptResponse struct {
    ChatID    string            `json:"chat_id"`
    Prompt    string            `json:"prompt"`
    Responses []models.Response `json:"responses"`
}

// HandlePrompt processes a prompt across multiple LLM providers
func HandlePrompt(c *gin.Context) {
    var req PromptRequest
    if err := c.BindJSON(&req); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "invalid payload"})
        return
    }

    // Create a new chat session
    chat := models.Chat{
        UserID:    req.UserID,
        Prompt:    req.Prompt,
        Responses: []models.Response{},
        CreatedAt: time.Now(),
    }

    // Get user's API keys
    userKeys, err := storage.GetUserAPIKeys(req.UserID)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to retrieve API keys"})
        return
    }

    // Map of provider ID to API key
    keyMap := make(map[string]string)
    for _, key := range userKeys {
        keyMap[key.Provider] = key.Key
    }

    // Process each provider
    for _, providerID := range req.Providers {
        response := processProvider(providerID, req.Prompt, keyMap[providerID])
        chat.Responses = append(chat.Responses, response)
    }

    // Save the chat session
    chatID, err := storage.SaveChat(chat)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to save chat"})
        return
    }

    c.JSON(http.StatusOK, PromptResponse{
        ChatID:    chatID,
        Prompt:    req.Prompt,
        Responses: chat.Responses,
    })
}