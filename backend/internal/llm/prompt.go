package llm

import (
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
