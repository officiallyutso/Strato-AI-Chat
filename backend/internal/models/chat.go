package models

import (
	"time"
)

// Chat represents a complete chat session with multiple LLM responses
type Chat struct {
	ID           string    `json:"id" firestore:"id"`
	UserID       string    `json:"user_id" firestore:"user_id"`
	Prompt       string    `json:"prompt" firestore:"prompt"`
	Responses    []Response `json:"responses" firestore:"responses"`
	SelectedID   string    `json:"selected_id,omitempty" firestore:"selected_id,omitempty"`
	CreatedAt    time.Time `json:"created_at" firestore:"created_at"`
	ChainedChats []string  `json:"chained_chats,omitempty" firestore:"chained_chats,omitempty"`
}

// Response represents a single LLM response to a prompt
type Response struct {
	ID        string    `json:"id" firestore:"id"`
	Provider  string    `json:"provider" firestore:"provider"`
	Model     string    `json:"model" firestore:"model"`
	Content   string    `json:"content" firestore:"content"`
	CreatedAt time.Time `json:"created_at" firestore:"created_at"`
	Error     string    `json:"error,omitempty" firestore:"error,omitempty"`
}

// APIKey represents a user's API key for a specific provider
type APIKey struct {
	ID        string    `json:"id" firestore:"id"`
	UserID    string    `json:"user_id" firestore:"user_id"`
	Provider  string    `json:"provider" firestore:"provider"`
	Key       string    `json:"key" firestore:"key"`
	CreatedAt time.Time `json:"created_at" firestore:"created_at"`
}

// LLMProvider represents an available LLM provider
type LLMProvider struct {
	ID          string   `json:"id" firestore:"id"`
	Name        string   `json:"name" firestore:"name"`
	Description string   `json:"description" firestore:"description"`
	Models      []string `json:"models" firestore:"models"`
	RequiresKey bool     `json:"requires_key" firestore:"requires_key"`
	Endpoint    string   `json:"endpoint,omitempty" firestore:"endpoint,omitempty"`
}