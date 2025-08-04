package com.spring.websocket;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.support.DefaultHandshakeHandler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.Principal;
import java.util.Map;

public class CustomHandShakeHandler extends DefaultHandshakeHandler {
    @Override
    protected Principal determineUser(ServerHttpRequest request, WebSocketHandler wsHandler, Map<String, Object> attributes) {
        HttpServletRequest httpRequest = ((ServletServerHttpRequest)request).getServletRequest();
        HttpSession session = httpRequest.getSession(false);
        int userId = (int)session.getAttribute("userId");
        return new CustomPrincipal(String.valueOf(userId));
    }
}
