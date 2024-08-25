package main

import (
	"main/app/index"
	"time"

	"github.com/labstack/echo/v4"
	"golang.org/x/net/websocket"
)

func ws(c echo.Context) error {
	websocket.Handler(func(ws *websocket.Conn) {
		defer ws.Close()
		for {
			time.Sleep(time.Second)
		}
	}).ServeHTTP(c.Response(), c.Request())
	return nil
}

func main() {
	e := echo.New()

	e.Static("/dist", "dist")

	e.GET("/", func(c echo.Context) error {
		component := index.Index("John")
		return component.Render(c.Request().Context(), c.Response().Writer)
	})
	e.GET("/ws", ws)

	e.Logger.Fatal(e.Start(":1323"))
}
