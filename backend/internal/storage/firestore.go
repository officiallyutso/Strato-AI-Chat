package storage

import (
	"cloud.google.com/go/firestore"
	"context"
	"google.golang.org/api/option"
	"log"
	"github.com/officiallyutso/strato-ai-backend/internal/models"
)

var Client *firestore.Client

func InitFirestore(serviceAccountPath string, projectID string) {
	ctx := context.Background()
	sa := option.WithCredentialsFile(serviceAccountPath)
	client, err := firestore.NewClient(ctx, projectID, sa)
	if err != nil {
		log.Fatalf("Failed to create Firestore client: %v", err)
	}
	Client = client
}

// SaveChat saves a chat session to Firestore
func SaveChat(chat models.Chat) (string, error) {
	ctx := context.Background()
	
	if chat.ID == "" {
		ref := Client.Collection("chats").NewDoc()
		chat.ID = ref.ID
	}
	
	_, err := Client.Collection("chats").Doc(chat.ID).Set(ctx, chat)
	return chat.ID, err
}

// GetChat retrieves a chat by ID
func GetChat(chatID string) (models.Chat, error) {
	ctx := context.Background()
	var chat models.Chat
	
	doc, err := Client.Collection("chats").Doc(chatID).Get(ctx)
	if err != nil {
		return chat, err
	}
	
	err = doc.DataTo(&chat)
	return chat, err
}

// GetUserChats retrieves all chats for a user
func GetUserChats(userID string) ([]models.Chat, error) {
	ctx := context.Background()
	var chats []models.Chat
	
	iter := Client.Collection("chats").Where("user_id", "==", userID).OrderBy("created_at", firestore.Desc).Documents(ctx)
	docs, err := iter.GetAll()
	if err != nil {
		return chats, err
	}
	
	for _, doc := range docs {
		var chat models.Chat
		if err := doc.DataTo(&chat); err == nil {
			chats = append(chats, chat)
		}
	}
	
	return chats, nil
}

// SaveAPIKey saves a user's API key
func SaveAPIKey(apiKey models.APIKey) error {
	ctx := context.Background()
	
	if apiKey.ID == "" {
		ref := Client.Collection("api_keys").NewDoc()
		apiKey.ID = ref.ID
	}
	
	_, err := Client.Collection("api_keys").Doc(apiKey.ID).Set(ctx, apiKey)
	return err
}

// GetUserAPIKeys retrieves all API keys for a user
func GetUserAPIKeys(userID string) ([]models.APIKey, error) {
	ctx := context.Background()
	var keys []models.APIKey
	
	iter := Client.Collection("api_keys").Where("user_id", "==", userID).Documents(ctx)
	docs, err := iter.GetAll()
	if err != nil {
		return keys, err
	}
	
	for _, doc := range docs {
		var key models.APIKey
		if err := doc.DataTo(&key); err == nil {
			keys = append(keys, key)
		}
	}
	
	return keys, nil
}