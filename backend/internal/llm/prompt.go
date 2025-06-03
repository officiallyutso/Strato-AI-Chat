package llm

import (
    "bytes"
    "encoding/json"
    "net/http"

    "github.com/gin-gonic/gin"
)

type PromptRequest struct {
    Prompt   string `json:"prompt"`
    Provider string `json:"provider"` // e.g., "huggingface"
    Model    string `json:"model"`    // e.g., "google/flan-t5-large"
    APIKey   string `json:"api_key"`  // Optional
}

func HandlePrompt(c *gin.Context) {
    var req PromptRequest
    if err := c.BindJSON(&req); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "invalid payload"})
        return
    }

    // HuggingFace Example
    if req.Provider == "huggingface" {
        url := "https://api-inference.huggingface.co/models/" + req.Model
        client := &http.Client{}

        body, _ := json.Marshal(map[string]string{"inputs": req.Prompt})
        request, _ := http.NewRequest("POST", url, bytes.NewBuffer(body))
        request.Header.Set("Authorization", "Bearer "+req.APIKey)
        request.Header.Set("Content-Type", "application/json")

        resp, err := client.Do(request)
        if err != nil {
            c.JSON(500, gin.H{"error": err.Error()})
            return
        }
        defer resp.Body.Close()

        var response interface{}
        json.NewDecoder(resp.Body).Decode(&response)

        c.JSON(200, gin.H{
            "response": response,
        })
        return
    }

    c.JSON(400, gin.H{"error": "provider not supported"})
}
