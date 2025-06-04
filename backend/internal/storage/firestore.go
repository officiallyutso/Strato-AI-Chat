package storage

import (
	"context"
	"log"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go/v4"
	"github.com/officiallyutso/strato-ai-backend/internal/models"
	"google.golang.org/api/option"
)

var client *firestore.Client

func InitFirestore(serviceAccountPath, projectID string) error {
	ctx := context.Background()
	
	opt := option.WithCredentialsFile(serviceAccountPath)
	app, err := firebase.NewApp(ctx, &firebase.Config{
		ProjectID: projectID,
	}, opt)
	if err != nil {
		return err
	}

	client, err = app.Firestore(ctx)
	if err != nil {
		return err
	}

	log.Println("Firestore initialized successfully")
	return nil
}

func SaveChat(chat *models.Chat) (string, error) {
	ctx := context.Background()
	
	if chat.ID == "" {
		// Create new chat
		docRef, _, err := client.Collection("chats").Add(ctx, chat)
		if err != nil {
			return "", err
		}
		chat.ID = docRef.ID
		return docRef.ID, nil
	}
	
	// Update existing chat
	_, err := client.Collection("chats").Doc(chat.ID).Set(ctx, chat)
	return chat.ID, err
}

func GetChat(chatID string) (*models.Chat, error) {
	ctx := context.Background()
	
	doc, err := client.Collection("chats").Doc(chatID).Get(ctx)
	if err != nil {
		return nil, err
	}

	var chat models.Chat
	if err := doc.DataTo(&chat); err != nil {
		return nil, err
	}
	
	chat.ID = doc.Ref.ID
	return &chat, nil
}

func GetUserChats(userID string) ([]models.Chat, error) {
	ctx := context.Background()
	
	iter := client.Collection("chats").Where("user_id", "==", userID).
		OrderBy("updated_at", firestore.Desc).Documents(ctx)
	
	var chats []models.Chat
	for {
		doc, err := iter.Next()
		if err != nil {
			break
		}
		
		var chat models.Chat
		if err := doc.DataTo(&chat); err != nil {
			continue
		}
		chat.ID = doc.Ref.ID
		chats = append(chats, chat)
	}
	
	return chats, nil
}