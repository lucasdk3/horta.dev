package main

import (
	"context"
	"log"
	"net/http"

	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/dapr/go-sdk/service/common"
	daprd "github.com/dapr/go-sdk/service/http"
)

func main() {
	// Dapr app for Gamification Service
	s := daprd.NewService(":8082")

	sub := &common.Subscription{
		PubsubName: "pubsub",
		Topic:      "response_submitted",
		Route:      "/response_submitted",
	}

	err := s.AddTopicEventHandler(sub, eventHandler)
	if err != nil {
		log.Fatalf("error adding topic subscription: %v", err)
	}

	// Also start a simple Gin router for health check if needed, or just let Dapr handle the HTTP
	go func() {
		r := gin.Default()
		r.Use(cors.New(cors.Config{
			AllowOrigins:  []string{"*"},
			AllowMethods:  []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
			AllowHeaders:  []string{"Origin", "Content-Type", "Authorization"},
			ExposeHeaders: []string{"Content-Length"},
			MaxAge:        12 * time.Hour,
		}))
		r.GET("/health", func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{"status": "ok", "service": "gamification"})
		})
		r.Run(":8083")
	}()

	if err := s.Start(); err != nil && err != http.ErrServerClosed {
		log.Fatalf("error starting service: %v", err)
	}
}

func eventHandler(ctx context.Context, e *common.TopicEvent) (retry bool, err error) {
	log.Printf("Received response event, applying gamification logic: %s", e.Data)
	return false, nil
}
