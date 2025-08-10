package com.spring.chat.repository;

import com.spring.chat.dto.ChatMessageDTO;
import com.spring.chat.dto.ChatUserDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;
import java.util.List;

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

    public ChatMessageDTO myLastMessage(int userId, int chatUserId){
        ChatMessageDTO chatMessageDTO = new ChatMessageDTO();
        chatMessageDTO.setRequestUserId(userId);
        chatMessageDTO.setResponseUserId(chatUserId);
        return sql.selectOne("Chat.myLastMessage", chatMessageDTO);
    }

    public int sendChatMessage(int userId, int chatUserId, String content) {
        ChatMessageDTO chatMessageDTO = new ChatMessageDTO();
        chatMessageDTO.setRequestUserId(userId);
        chatMessageDTO.setResponseUserId(chatUserId);
        chatMessageDTO.setContent(content);
        return sql.insert("Chat.sendChatMessage", chatMessageDTO);
    }

    public int readChatMessage(int userId, int chatUserId, int chatId) {
        ChatMessageDTO chatMessageDTO = new ChatMessageDTO();
        chatMessageDTO.setRequestUserId(chatUserId);
        chatMessageDTO.setResponseUserId(userId);
        chatMessageDTO.setId(chatId);
        return sql.update("Chat.readChatMessage", chatMessageDTO);
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

    public List<ChatUserDTO> searchUserList(ChatUserDTO chatUserDTO) {
        return sql.selectList("Chat.searchUserList", chatUserDTO);
    }

    public ChatUserDTO getChatFriendById(int userId, int chatUserId) {
        ChatMessageDTO chatMessageDTO = new ChatMessageDTO();
        chatMessageDTO.setRequestUserId(userId);
        chatMessageDTO.setResponseUserId(chatUserId);
        return sql.selectOne("Chat.getChatFriendById", chatMessageDTO);
    }
}
