package main

import (
	"log"
	"net/http"
	"context"

	"github.com/gin-gonic/gin"
	dapr "github.com/dapr/go-sdk/client"
)

func main() {
	r := gin.Default()

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "ok", "service": "response"})
	})

	r.POST("/responses", func(c *gin.Context) {
		// Mock logic to process response
		client, err := dapr.NewClient()
		if err == nil {
			defer client.Close()
			// Publish event to gamification service
			err = client.PublishEvent(context.Background(), "pubsub", "response_submitted", []byte(`{"userId": "123", "xp": 10}`))
			if err != nil {
				log.Printf("Failed to publish event: %v", err)
			}
		}

		c.JSON(http.StatusOK, gin.H{"status": "success"})
	})

	r.Run(":8081")
}
