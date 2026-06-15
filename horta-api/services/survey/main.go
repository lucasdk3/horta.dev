package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"time"

	"cloud.google.com/go/firestore"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"google.golang.org/api/iterator"
)

const projectID = "horta-495401"
const firestoreDB = "ai-studio-ae6efca7-de42-416a-bd0c-dd80122fa556"

type LocalizedString map[string]string

type QuestionOption struct {
	Value string          `json:"value" firestore:"value"`
	Label LocalizedString `json:"label" firestore:"label"`
}

type Question struct {
	ID      string           `json:"id" firestore:"id"`
	Type    string           `json:"type" firestore:"type"`
	Label   LocalizedString  `json:"label" firestore:"label"`
	Options []QuestionOption `json:"options,omitempty" firestore:"options,omitempty"`
}

type Survey struct {
	ID          string          `json:"id" firestore:"-"`
	Title       LocalizedString `json:"title" firestore:"title"`
	Description LocalizedString `json:"description" firestore:"description"`
	Category    string          `json:"category" firestore:"category"`
	Tags        []string        `json:"tags" firestore:"tags"`
	Active      bool            `json:"active" firestore:"active"`
	Questions   []Question      `json:"questions" firestore:"questions"`
	CreatedAt   time.Time       `json:"createdAt" firestore:"createdAt"`
	CreatedBy   string          `json:"createdBy" firestore:"createdBy"`
}

var fs *firestore.Client

func main() {
	ctx := context.Background()

	var err error
	fs, err = firestore.NewClientWithDatabase(ctx, projectID, firestoreDB)
	if err != nil {
		log.Printf("Warning: error initializing firestore client: %v\n", err)
	} else {
		log.Println("Firestore connected to database:", firestoreDB)
	}

	r := gin.Default()
	r.Use(cors.New(cors.Config{
		AllowOrigins:  []string{"*"},
		AllowMethods:  []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders:  []string{"Origin", "Content-Type", "Authorization"},
		ExposeHeaders: []string{"Content-Length"},
		MaxAge:        12 * time.Hour,
	}))

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "ok", "service": "survey"})
	})

	v1 := r.Group("/api/v1")
	{
		v1.GET("/surveys", listSurveys)
		v1.POST("/surveys", createSurvey)
		v1.GET("/surveys/:id", getSurvey)
		v1.GET("/surveys/:id/responses", listSurveyResponses)
		v1.POST("/responses", submitResponse)
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	r.Run(":" + port)
}

func listSurveys(c *gin.Context) {
	if fs == nil {
		c.JSON(http.StatusServiceUnavailable, gin.H{"error": "database not connected"})
		return
	}

	ctx := c.Request.Context()
	iter := fs.Collection("surveys").Documents(ctx)
	defer iter.Stop()

	var surveys []map[string]any
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		data := doc.Data()
		data["id"] = doc.Ref.ID
		surveys = append(surveys, data)
	}

	if surveys == nil {
		surveys = []map[string]any{}
	}
	c.JSON(http.StatusOK, gin.H{"surveys": surveys})
}

func getSurvey(c *gin.Context) {
	if fs == nil {
		c.JSON(http.StatusServiceUnavailable, gin.H{"error": "database not connected"})
		return
	}

	id := c.Param("id")
	ctx := c.Request.Context()

	doc, err := fs.Collection("surveys").Doc(id).Get(ctx)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "survey not found"})
		return
	}

	data := doc.Data()
	data["id"] = doc.Ref.ID
	c.JSON(http.StatusOK, data)
}

type SurveyResponse struct {
	SurveyID  string         `json:"surveyId" firestore:"surveyId"`
	Answers   map[string]any `json:"answers" firestore:"answers"`
	Country   string         `json:"country" firestore:"country"`
	CreatedAt time.Time      `json:"createdAt" firestore:"createdAt"`
}

func listSurveyResponses(c *gin.Context) {
	if fs == nil {
		c.JSON(http.StatusServiceUnavailable, gin.H{"error": "database not connected"})
		return
	}

	surveyID := c.Param("id")
	ctx := c.Request.Context()

	iter := fs.Collection("responses").Where("surveyId", "==", surveyID).Documents(ctx)
	defer iter.Stop()

	var responses []map[string]any
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		data := doc.Data()
		data["id"] = doc.Ref.ID
		responses = append(responses, data)
	}

	if responses == nil {
		responses = []map[string]any{}
	}
	c.JSON(http.StatusOK, gin.H{"responses": responses})
}

func submitResponse(c *gin.Context) {
	if fs == nil {
		c.JSON(http.StatusServiceUnavailable, gin.H{"error": "database not connected"})
		return
	}

	var payload SurveyResponse
	if err := c.ShouldBindJSON(&payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	payload.CreatedAt = time.Now().UTC()

	ctx := c.Request.Context()
	ref := fs.Collection("responses").NewDoc()
	if _, err := ref.Set(ctx, payload); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"id": ref.ID, "message": "response submitted"})
}

func createSurvey(c *gin.Context) {
	if fs == nil {
		c.JSON(http.StatusServiceUnavailable, gin.H{"error": "database not connected"})
		return
	}

	var survey Survey
	if err := c.ShouldBindJSON(&survey); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	survey.CreatedAt = time.Now().UTC()
	if survey.CreatedBy == "" {
		survey.CreatedBy = "api"
	}

	ctx := c.Request.Context()

	var ref *firestore.DocumentRef
	if survey.ID != "" {
		ref = fs.Collection("surveys").Doc(survey.ID)
	} else {
		ref = fs.Collection("surveys").NewDoc()
	}

	_, err := ref.Set(ctx, survey)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"id": ref.ID, "message": "survey created"})
}
