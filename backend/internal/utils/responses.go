package utils

import (
	"net/http"
	"github.com/gin-gonic/gin"
)

type ErrorResponse struct {
	Error   string `json:"error"`
	Message string `json:"message,omitempty"`
}

type SuccessResponse struct {
	Message string      `json:"message"`
	Data    interface{} `json:"data,omitempty"`
}

func SendError(c *gin.Context, statusCode int, err string, message ...string) {
	response := ErrorResponse{
		Error: err,
	}
	
	if len(message) > 0 {
		response.Message = message[0]
	}
	
	c.JSON(statusCode, response)
}

func SendSuccess(c *gin.Context, message string, data ...interface{}) {
	response := SuccessResponse{
		Message: message,
	}
	
	if len(data) > 0 {
		response.Data = data[0]
	}
	
	c.JSON(http.StatusOK, response)
}

func ValidateRequired(fields map[string]interface{}) []string {
	var missing []string
	
	for field, value := range fields {
		if value == nil || value == "" {
			missing = append(missing, field)
		}
	}
	
	return missing
}