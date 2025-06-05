package storage

import (
	"context"
	"github.com/officiallyutso/strato-ai-backend/internal/models"
)

func SaveAPIKey(apiKey models.APIKey) error {
	ctx := context.Background()
	
	if apiKey.ID == "" {
		_, _, err := client.Collection("api_keys").Add(ctx, apiKey)
		return err
	}
	
	_, err := client.Collection("api_keys").Doc(apiKey.ID).Set(ctx, apiKey)
	return err
}

func GetUserAPIKeys(userID string) ([]models.APIKey, error) {
	ctx := context.Background()
	
	iter := client.Collection("api_keys").Where("user_id", "==", userID).Documents(ctx)
	
	var keys []models.APIKey
	for {
		doc, err := iter.Next()
		if err != nil {
			break
		}
		
		var apiKey models.APIKey
		if err := doc.DataTo(&apiKey); err != nil {
			continue
		}
		apiKey.ID = doc.Ref.ID
		keys = append(keys, apiKey)
	}
	
	return keys, nil
}

func GetAPIKey(userID, provider string) (*models.APIKey, error) {
	ctx := context.Background()
	
	iter := client.Collection("api_keys").
		Where("user_id", "==", userID).
		Where("provider", "==", provider).
		Limit(1).Documents(ctx)
	
	doc, err := iter.Next()
	if err != nil {
		return nil, err
	}
	
	var apiKey models.APIKey
	if err := doc.DataTo(&apiKey); err != nil {
		return nil, err
	}
	apiKey.ID = doc.Ref.ID
	
	return &apiKey, nil
}