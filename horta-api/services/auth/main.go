package main

import (
	"context"
	"log"
	"net/http"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"google.golang.org/api/idtoken"
)

type AuthRequest struct {
	IDToken string `json:"idToken" binding:"required"`
}

func main() {
	r := gin.Default()
	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		MaxAge:           12 * time.Hour,
	}))

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "ok", "service": "auth"})
	})

	r.POST("/auth/google", func(c *gin.Context) {
		var req AuthRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		ctx := context.Background()
		// Usually you would pass the Google Client ID here. Empty string means we skip audience validation for this simple example.
		// Replace "" with your actual Google Client ID when deploying to production.
		payload, err := idtoken.Validate(ctx, req.IDToken, "")
		if err != nil {
			log.Printf("Invalid token: %v", err)
			c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid google token"})
			return
		}

		// Token is valid. payload.Claims contains email, name, etc.
		// email := payload.Claims["email"]
		log.Printf("User authenticated: %v", payload.Claims["email"])

		// Here you would typically lookup or create the user in your database,
		// and then issue your own JWT or session token.
		// For this implementation, we will issue a mock custom JWT.
		
		customJwt := "mock_custom_jwt_for_" + payload.Subject

		c.JSON(http.StatusOK, gin.H{
			"token": customJwt,
			"user": payload.Claims,
		})
	})

	log.Println("Auth service running on port 8081")
	r.Run(":8081")
}
