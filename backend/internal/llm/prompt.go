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

    // omne map of provider ID to API key
    keyMap := make(map[string]string)
    for _, key := range userKeys {
        keyMap[key.Provider] = key.Key
    }

    for _, providerID := range req.Providers {
        response := processProvider(providerID, req.Prompt, keyMap[providerID])
        chat.Responses = append(chat.Responses, response)
    }

    // Saveddd chat session
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


// processProvider handles sending a prompt to a specific LLM provider
func processProvider(providerID, prompt, apiKey string) models.Response {
    response := models.Response{
        ID:        uuid.New().String(),
        Provider:  providerID,
        CreatedAt: time.Now(),
    }

    // Handle different providers
    switch providerID {
    case "huggingface":
        result, err := callHuggingFace(prompt, apiKey)
        if err != nil {
            response.Error = err.Error()
        } else {
            response.Content = result
            response.Model = "huggingface/default"
        }

    case "gemini":
        result, err := callGemini(prompt, apiKey)
        if err != nil {
            response.Error = err.Error()
        } else {
            response.Content = result
            response.Model = "gemini-pro"
        }

    case "mistral":
        result, err := callMistral(prompt, apiKey)
        if err != nil {
            response.Error = err.Error()
        } else {
            response.Content = result
            response.Model = "mistral-small"
        }

    default:
        response.Error = "unsupported provider"
    }

    return response
}

// callHuggingFace sends a prompt to HuggingFace API
func callHuggingFace(prompt, apiKey string) (string, error) {
    url := "https://api-inference.huggingface.co/models/google/flan-t5-large"
    client := &http.Client{}

    body, _ := json.Marshal(map[string]string{"inputs": prompt})
    request, _ := http.NewRequest("POST", url, bytes.NewBuffer(body))
    request.Header.Set("Authorization", "Bearer "+apiKey)
    request.Header.Set("Content-Type", "application/json")

    resp, err := client.Do(request)
    if err != nil {
        return "", err
    }
    defer resp.Body.Close()

    var result []string
    if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
        return "", err
    }

    if len(result) > 0 {
        return result[0], nil
    }
    return "", nil
}

// callGemini sends a prompt to Google's Gemini API
func callGemini(prompt, apiKey string) (string, error) {
    // This would be a real API cali in production
    return "This is a simulated response from Gemini: " + prompt, nil
}

// callMistral sends a prompt to Mistral API
func callMistral(prompt, apiKey string) (string, error) {
    // This would be a real API call in production
    return "This is a simulated response from Mistral: " + prompt, nil
}