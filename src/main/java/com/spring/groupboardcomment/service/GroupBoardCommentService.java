package com.spring.groupboardcomment.service;

import com.spring.groupboard.dto.GroupBoardDTO;
import com.spring.groupboard.service.GroupBoardService;
import com.spring.groupboardcomment.dto.GroupBoardCommentDTO;
import com.spring.groupboardcomment.repository.GroupBoardCommentRepository;
import com.spring.notification.dto.NotificationDTO;
import com.spring.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GroupBoardCommentService {
    private final NotificationService notificationService;
    private final GroupBoardService groupBoardService;
    public final GroupBoardCommentRepository groupBoardCommentRepository;

    public void save(GroupBoardCommentDTO dto) {
        groupBoardCommentRepository.save(dto);
        //모임 글에 댓글을 달면 알림이 가게 하는 코드
        NotificationDTO notificationDTO = new NotificationDTO();
        GroupBoardDTO groupBoardDTO = groupBoardService.findById(dto.getBoardId());
        notificationDTO.setUserId(groupBoardDTO.getAuthor());
        notificationDTO.setRequestUserId(dto.getAuthor());
        notificationDTO.setRelatedId(dto.getBoardId());
        notificationDTO.setType("NEW_COMMENT");
        notificationDTO.setContent(groupBoardDTO.getAuthorNickName());
        notificationDTO.setPath(null);
        notificationService.createNotification(notificationDTO);
    }

    public List<GroupBoardCommentDTO> findByBoardId(int boardId) {
        return groupBoardCommentRepository.findByBoardId(boardId);
    }

    public void update(int id, String content) {
        groupBoardCommentRepository.update(id, content);
    }

    public void delete(int id) {
        groupBoardCommentRepository.delete(id);
    }


}
