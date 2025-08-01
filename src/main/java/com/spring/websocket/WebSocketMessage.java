package com.spring.websocket;

public class WebSocketMessage {
    private String name;

    public WebSocketMessage() {
    }

    public WebSocketMessage(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
