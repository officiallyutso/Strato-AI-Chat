package llm

import "github.com/officiallyutso/strato-ai-backend/internal/models"

type LLMModel struct {
	ID          string `json:"id"`
	Name        string `json:"name"`
	Provider    string `json:"provider"`
	Description string `json:"description"`
	IconPath    string `json:"icon_path"`
	IsAvailable bool   `json:"is_available"`
}

func GetAvailableModels() []LLMModel {
	return []LLMModel{
		// Gemini
		{
			ID:          "gemini-pro",
			Name:        "Gemini Pro",
			Provider:    "Google",
			Description: "Google's most capable model",
			IconPath:    "assets/icons/gemini.png",
			IsAvailable: true,
		},
		// OpenRouter Free Models
		{
			ID:          "mistralai/mistral-7b-instruct",
			Name:        "Mistral 7B Instruct",
			Provider:    "OpenRouter",
			Description: "Mistral AI's 7B parameter instruction-tuned model",
			IconPath:    "assets/icons/mistral.png",
			IsAvailable: true,
		},
		{
			ID:          "mistralai/mixtral-8x7b-instruct",
			Name:        "Mixtral 8x7B Instruct",
			Provider:    "OpenRouter",
			Description: "High-quality sparse mixture of experts model",
			IconPath:    "assets/icons/mistral.png",
			IsAvailable: true,
		},
		{
			ID:          "meta-llama/llama-3-8b-instruct",
			Name:        "Llama 3 8B Instruct",
			Provider:    "OpenRouter",
			Description: "Meta's Llama 3 8B instruction-tuned model",
			IconPath:    "assets/icons/llama.png",
			IsAvailable: true,
		},
		{
			ID:          "meta-llama/llama-3-70b-instruct",
			Name:        "Llama 3 70B Instruct",  
			Provider:    "OpenRouter",
			Description: "Meta's Llama 3 70B instruction-tuned model",
			IconPath:    "assets/icons/llama.png",
			IsAvailable: true,
		},
		{
			ID:          "HuggingFaceH4/zephyr-7b-beta",
			Name:        "Zephyr 7B Beta",
			Provider:    "HuggingFace",
			Description: "Zephyr conversational model",
			IconPath:    "assets/icons/huggingface.png",
			IsAvailable: true,
		},
	}
}

type PromptRequest struct {
	UserID   string   `json:"user_id"`
	ChatID   string   `json:"chat_id,omitempty"`
	Prompt   string   `json:"prompt"`
	ModelIDs []string `json:"model_ids"`
}

type PromptResponse struct {
	ChatID    string             `json:"chat_id"`
	MessageID string             `json:"message_id"`
	Responses []models.Response  `json:"responses"`
}