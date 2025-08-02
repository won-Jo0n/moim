package com.spring.websocket;

public class WebSocketResponseMessage {
    private String content;

    public WebSocketResponseMessage() {
    }

    public WebSocketResponseMessage(String content) {
        this.content = content;
    }

    public String getContent() {
        return content;
    }
}
