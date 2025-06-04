package models

import "time"

type Chat struct {
	ID         string    `json:"id" firestore:"id"`
	UserID     string    `json:"user_id" firestore:"user_id"`
	Title      string    `json:"title" firestore:"title"`
	Messages   []Message `json:"messages" firestore:"messages"`
	CreatedAt  time.Time `json:"created_at" firestore:"created_at"`
	UpdatedAt  time.Time `json:"updated_at" firestore:"updated_at"`
	SelectedID string    `json:"selected_id" firestore:"selected_id"`
}

type Message struct {
	ID        string     `json:"id" firestore:"id"`
	Content   string     `json:"content" firestore:"content"`
	Role      string     `json:"role" firestore:"role"` // "user" or "assistant"
	Timestamp time.Time  `json:"timestamp" firestore:"timestamp"`
	Responses []Response `json:"responses,omitempty" firestore:"responses,omitempty"`
}

type Response struct {
	ID       string `json:"id" firestore:"id"`
	ModelID  string `json:"model_id" firestore:"model_id"`
	Content  string `json:"content" firestore:"content"`
	Provider string `json:"provider" firestore:"provider"`
}

type APIKey struct {
	ID        string    `json:"id" firestore:"id"`
	UserID    string    `json:"user_id" firestore:"user_id"`
	Provider  string    `json:"provider" firestore:"provider"`
	Key       string    `json:"key" firestore:"key"`
	CreatedAt time.Time `json:"created_at" firestore:"created_at"`
}

type LLMProvider struct {
	ID          string   `json:"id"`
	Name        string   `json:"name"`
	Description string   `json:"description"`
	Models      []string `json:"models"`
	RequiresKey bool     `json:"requires_key"`
}