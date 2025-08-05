package com.spring.chat.repository;

import com.spring.chat.dto.ChatMessageDTO;
import com.spring.chat.dto.ChatUserDTO;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.annotations.Param;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class ChatRepository {
    private final SqlSessionTemplate sql;

    public List<ChatUserDTO> getChatFriends(int userId) {
        return sql.selectList("Chat.getChatFriends", userId);
    }

    public List<ChatMessageDTO> getChatMessages(int userId, int chatUserId) {
        ChatMessageDTO chatMessageDTO = new ChatMessageDTO();
        chatMessageDTO.setRequestUserId(userId);
        chatMessageDTO.setResponseUserId(chatUserId);
        return sql.selectList("Chat.getChatMessages", chatMessageDTO);
    }

    public int readChatMessages(int userId, int chatUserId) {
        ChatMessageDTO chatMessageDTO = new ChatMessageDTO();
        chatMessageDTO.setRequestUserId(userId);
        chatMessageDTO.setResponseUserId(chatUserId);
        return sql.update("Chat.readChatMessages", chatMessageDTO);
    }

    public void requestChat(int userId, int chatUserId) {
        ChatMessageDTO chatMessageDTO = new ChatMessageDTO();
        chatMessageDTO.setRequestUserId(userId);
        chatMessageDTO.setResponseUserId(chatUserId);
        sql.insert("Chat.requestChat", chatMessageDTO);
    }

    public boolean acceptChat(int userId, int chatUserId) {
        ChatMessageDTO chatMessageDTO = new ChatMessageDTO();
        chatMessageDTO.setRequestUserId(userId);
        chatMessageDTO.setResponseUserId(chatUserId);
        return sql.update("Chat.acceptChat", chatMessageDTO) > 0;
    }

    public boolean declineChat(int userId, int chatUserId) {
        ChatMessageDTO chatMessageDTO = new ChatMessageDTO();
        chatMessageDTO.setRequestUserId(userId);
        chatMessageDTO.setResponseUserId(chatUserId);
        return sql.update("Chat.declineChat", chatMessageDTO) > 0;
    }
}
