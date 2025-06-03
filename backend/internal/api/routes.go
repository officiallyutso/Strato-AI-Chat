package api

import (
    "github.com/gin-gonic/gin"
    "github.com/officiallyutso/strato-ai-backend/internal/llm"
)

func SetupRoutes(r *gin.Engine) {
    r.GET("/ping", func(c *gin.Context) {
        c.JSON(200, gin.H{"message": "pong"})
    })

    r.POST("/prompt", llm.HandlePrompt) // send prompt to LLMs
}
