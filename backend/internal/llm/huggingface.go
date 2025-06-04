package llm

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

type HuggingFaceRequest struct {
	Inputs     string `json:"inputs"`
	Parameters struct {
		Temperature    float64 `json:"temperature"`
		MaxLength      int     `json:"max_length"`
		ReturnFullText bool    `json:"return_full_text"`
	} `json:"parameters"`
}

type HuggingFaceResponse []struct {
	GeneratedText string `json:"generated_text"`
}

func callHuggingFace(apiKey, modelID, prompt string) (string, error) {
	url := fmt.Sprintf("https://api-inference.huggingface.co/models/%s", modelID)
	
	reqBody := HuggingFaceRequest{
		Inputs: prompt,
		Parameters: struct {
			Temperature    float64 `json:"temperature"`
			MaxLength      int     `json:"max_length"`
			ReturnFullText bool    `json:"return_full_text"`
		}{
			Temperature:    0.7,
			MaxLength:      1024,
			ReturnFullText: false,
		},
	}

	jsonBody, err := json.Marshal(reqBody)
	if err != nil {
		return "", err
	}

	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonBody))
	if err != nil {
		return "", err
	}
	
	req.Header.Set("Authorization", "Bearer "+apiKey)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	if resp.StatusCode != 200 {
		return "", fmt.Errorf("huggingFace API error: %s", string(body))
	}

	var hfResp HuggingFaceResponse
	if err := json.Unmarshal(body, &hfResp); err != nil {
		return "", err
	}

	if len(hfResp) > 0 {
		return hfResp[0].GeneratedText, nil
	}

	return "", fmt.Errorf("no response from HuggingFace")
}