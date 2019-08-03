package main

import (
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis"
	"github.com/jrallison/go-workers"
	"github.com/spf13/viper"
)

func init() {
	viper.SetConfigFile(`config.json`)
	err := viper.ReadInConfig()
	if err != nil {
		panic(err)
	}
}

//token_chats
//token_(chat_number)

func main() {

	redisConnectionString := viper.GetString(`REDIS_CONNECTION_STRING`)

	client := redis.NewClient(&redis.Options{
		Addr: redisConnectionString,
		DB:   0, // use default DB
	})

	workers.Configure(map[string]string{
		"server":   redisConnectionString,
		"database": "0",
		"pool":     "30",
		"process":  "1",
	})

	router := gin.Default()

	type MessageRequestBody struct {
		Body string `json:"body" binding:"required"`
	}

	router.POST("/applications/:token/chats", func(c *gin.Context) {
		applicationToken := c.Param("token")

		applicationChatsCountKey := fmt.Sprintf("%s_chats", applicationToken)

		chatNumber := client.Incr(applicationChatsCountKey).Val()

		stringifiedChatNumber := strconv.FormatInt(chatNumber, 10)

		_, err := workers.Enqueue("default", "ChatWorker", []string{applicationToken, stringifiedChatNumber})

		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		chatsMessagesCountKey := fmt.Sprintf("%s_%s_messages", applicationToken, stringifiedChatNumber)

		err = client.Set(chatsMessagesCountKey, 0, 0).Err()

		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"chat_number": chatNumber})
		return

	})

	router.POST("/applications/:token/chats/:chat_number/messages", func(c *gin.Context) {
		applicationToken := c.Param("token")
		chatNumber := c.Param("chat_number")

		var requestBody MessageRequestBody

		if err := c.ShouldBindJSON(&requestBody); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		chatMessagesCountKey := fmt.Sprintf("%s_%s_messages", applicationToken, chatNumber)

		chatMessageNumber := client.Incr(chatMessagesCountKey).Val()

		stringifiedChatMessageNumber := strconv.FormatInt(chatMessageNumber, 10)

		_, err := workers.Enqueue("default", "MessageWorker", []string{applicationToken, chatNumber, stringifiedChatMessageNumber, requestBody.Body})

		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message_number": chatMessageNumber})
		return
	})

	httpServerPort := viper.GetString(`HTTP_SERVER_PORT`)
	router.Run(fmt.Sprintf(":%s", httpServerPort))
}
