package com.spring.chat.controller;

import com.spring.chat.dto.ChatMessageDTO;
import com.spring.chat.dto.ChatUserDTO;
import com.spring.chat.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@RestController
@RequestMapping("/chat")
@RequiredArgsConstructor
public class ChatController {
    private final ChatService chatService;

    @GetMapping("/friends")
    public List<ChatUserDTO> getChatFriends(HttpSession session)
    {
        int userId = (int)session.getAttribute("userId");
        return chatService.getChatFriends(userId);
    }

    @GetMapping("/messages/{chatUserId}")
    public List<ChatMessageDTO> getChatMessages(@PathVariable int chatUserId, HttpSession session){
        int userId = (int)session.getAttribute("userId");
        return chatService.getChatMessages(userId, chatUserId);
    }

    @GetMapping("/read/{chatUserId}")
    public int readMessages(@PathVariable int chatUserId, HttpSession session){
        int userId = (int)session.getAttribute("userId");
        return chatService.readChatMessages(userId, chatUserId);
    }

    @GetMapping("/request/{chatUserId}")
    public void requestChat(@PathVariable int chatUserId, HttpSession session){
        int userId = (int)session.getAttribute("userId");
        chatService.requestChat(userId, chatUserId);
    }

    @GetMapping("/accept/{chatUserId}")
    public boolean acceptChat(@PathVariable int chatUserId, HttpSession session){
        int userId = (int)session.getAttribute("userId");
        return chatService.acceptChat(userId, chatUserId);
    }

    @GetMapping("/decline/{chatUserId}")
    public boolean declineChat(@PathVariable int chatUserId, HttpSession session){
        int userId = (int)session.getAttribute("userId");
        return chatService.declineChat(userId, chatUserId);
    }

}
