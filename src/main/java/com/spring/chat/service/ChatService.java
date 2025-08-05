package com.spring.chat.service;

import com.spring.chat.dto.ChatMessageDTO;
import com.spring.chat.dto.ChatUserDTO;
import com.spring.chat.repository.ChatRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatService {
    private final ChatRepository chatRepository;

    public List<ChatUserDTO> getChatFriends(int userId) {
        return chatRepository.getChatFriends(userId);
    }

    public List<ChatMessageDTO> getChatMessages(int userId, int chatUserId) {
        return chatRepository.getChatMessages(userId, chatUserId);
    }

    public int readChatMessages(int userId, int chatUserId) {
        return chatRepository.readChatMessages(userId, chatUserId);
    }

    public void requestChat(int userId, int chatUserId) {
        chatRepository.requestChat(userId, chatUserId);
    }

    public boolean acceptChat(int userId, int chatUserId) {
        return chatRepository.acceptChat(userId, chatUserId);
    }

    public boolean declineChat(int userId, int chatUserId) {
        return chatRepository.declineChat(userId, chatUserId);
    }
}
