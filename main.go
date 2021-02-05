package main

import (
	"net/http"
	"strings"

	"github.com/labstack/echo/v4"
)

//Model
type Data struct {
	Data []Message `json:"data"`
}

type Message struct {
	Text  string `json:"text"`
	Count int    `json:"count"`
}

func main() {
	e := echo.New()
	m := make(map[string]int)
	e.POST("/messages", func(c echo.Context) error {
		//รับค่า request มาแสดง
		message := new(Message)                 //สร้างตัวแปรมาเก็บค่า request
		if err := c.Bind(message); err != nil { //เก็บค่า request ลงตัวแปร
			return c.String(500, "error")
		}

		message.Text = strings.ToLower(message.Text)
		//เช็คค่าใน map
		if count, found := m[message.Text]; found {
			countplus := count + 1
			m[message.Text] = countplus
		} else {
			m[message.Text] = 1
		}

		return c.String(http.StatusOK, "Success!")
	})

	e.GET("/messages", func(c echo.Context) error {
		messages := []Message{}

		//loop แสดง text กับ count ใน array
		for text, count := range m {
			message := Message{Text: text, Count: count}
			messages = append(messages, message)
		}

		data := Data{Data: messages}
		return c.JSON(http.StatusOK, data)
	})

	e.Logger.Fatal(e.Start(":8080"))
}
