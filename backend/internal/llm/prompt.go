package llm

import (
	"fmt"
	"net/http"
	"time"
	"sync"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/officiallyutso/strato-ai-backend/internal/models"
	"github.com/officiallyutso/strato-ai-backend/internal/storage"
)

func HandlePrompt(c *gin.Context) {
	var req PromptRequest
	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid request payload"})
		return
	}

	if req.UserID == "" || req.Prompt == "" || len(req.ModelIDs) == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "missing required fields"})
		return
	}

	// Get or create chat
	var chat *models.Chat
	var err error

	if req.ChatID != "" {
		chat, err = storage.GetChat(req.ChatID)
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "chat not found"})
			return
		}
	} else {
		// Create new chat
		chat = &models.Chat{
			ID:        uuid.New().String(),
			UserID:    req.UserID,
			Title:     generateChatTitle(req.Prompt),
			Messages:  []models.Message{},
			CreatedAt: time.Now(),
			UpdatedAt: time.Now(),
		}
	}

	// Create user message
	userMessage := models.Message{
		ID:        uuid.New().String(),
		Content:   req.Prompt,
		Role:      "user",
		Timestamp: time.Now(),
		Responses: []models.Response{},
	}

	// Generate responses from multiple models concurrently
	responses := generateResponses(req.UserID, req.ModelIDs, req.Prompt)

	userMessage.Responses = responses
	chat.Messages = append(chat.Messages, userMessage)
	chat.UpdatedAt = time.Now()

	// Save chat to database
	chatID, err := storage.SaveChat(chat)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to save chat"})
		return
	}

	response := PromptResponse{
		ChatID:    chatID,
		MessageID: userMessage.ID,
		Responses: responses,
	}

	c.JSON(http.StatusOK, response)
}

func generateResponses(userID string, modelIDs []string, prompt string) []models.Response {
	var responses []models.Response
	var mu sync.Mutex
	var wg sync.WaitGroup

	for _, modelID := range modelIDs {
		wg.Add(1)
		go func(id string) {
			defer wg.Done()
			
			response := generateSingleResponse(userID, id, prompt)
			
			mu.Lock()
			responses = append(responses, response)
			mu.Unlock()
		}(modelID)
	}

	wg.Wait()
	return responses
}

func generateSingleResponse(userID, modelID, prompt string) models.Response {
	response := models.Response{
		ID:      uuid.New().String(),
		ModelID: modelID,
		Content: "",
	}

	// Find model info
	var model *LLMModel
	for _, m := range GetAvailableModels() {
		if m.ID == modelID {
			model = &m
			break
		}
	}

	if model == nil {
		response.Content = "Error: Model not found"
		return response
	}

	response.Provider = model.Provider

	// Get API key for provider
	apiKey, err := storage.GetAPIKey(userID, model.Provider)
	if err != nil {
		response.Content = "Error: API key not found for " + model.Provider
		return response
	}

	// Generate response based on provider
	var content string
	switch model.Provider {
	case "Google":
		content, err = callGemini(apiKey.Key, prompt)
	case "OpenRouter":
		content, err = callOpenRouter(apiKey.Key, modelID, prompt)
	case "HuggingFace":
		content, err = callHuggingFace(apiKey.Key, modelID, prompt)
	default:
		err = fmt.Errorf("unsupported provider: %s", model.Provider)
	}

	if err != nil {
		response.Content = "Error: " + err.Error()
	} else {
		response.Content = content
	}

	return response
}

func generateChatTitle(prompt string) string {
	if len(prompt) > 50 {
		return prompt[:47] + "..."
	}
	return prompt
}