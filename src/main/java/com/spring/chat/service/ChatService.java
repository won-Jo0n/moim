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

    public ChatMessageDTO sendChatMessage(int userId, int chatUserId, String content) {
        if(chatRepository.sendChatMessage(userId, chatUserId, content) > 0){
            return chatRepository.myLastMessage(userId, chatUserId);
        }
        return null;
    }

    public int readChatMessage(int userId, int chatUserId, int chatId) {
        return chatRepository.readChatMessage(userId, chatUserId, chatId);
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

    public ChatUserDTO getChatFriendById(int userId, int chatUserId){
        return chatRepository.getChatFriendById(userId, chatUserId);
    }

    public List<ChatUserDTO> searchUserList(ChatUserDTO chatUserDTO) {
        return chatRepository.searchUserList(chatUserDTO);
    }
}
