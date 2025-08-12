package com.spring.mbti.service;
import com.spring.mbti.dto.MbtiBoardCommentDTO;
import com.spring.mbti.dto.MbtiBoardDTO;
import com.spring.mbti.repository.MbtiBoardCommentRepository;
import com.spring.notification.dto.NotificationDTO;
import com.spring.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MbtiBoardCommentService {
    private final NotificationService notificationService;
    private final MbtiBoardService mbtiBoardService;
    private final MbtiBoardCommentRepository commentRepository;

    public void save(MbtiBoardCommentDTO dto) {
        commentRepository.save(dto);
        //모임 글에 댓글을 달면 알림이 가게 하는 코드
        NotificationDTO notificationDTO = new NotificationDTO();
        MbtiBoardDTO mbtiBoardDTO = mbtiBoardService.findById(dto.getBoardId());
        notificationDTO.setUserId(mbtiBoardDTO.getAuthor());
        notificationDTO.setRequestUserId(dto.getAuthor());
        notificationDTO.setRelatedId(dto.getBoardId().intValue());
        notificationDTO.setType("NEW_COMMENT");
        notificationDTO.setContent(mbtiBoardDTO.getNickName());
        notificationDTO.setPath("/mbti/board/detail/" + dto.getBoardId().intValue());
        notificationService.createNotification(notificationDTO);
    }

    public List<MbtiBoardCommentDTO> findAllByBoardId(Long boardId) {
        return commentRepository.findAllByBoardId(boardId);
    }

    public MbtiBoardCommentDTO findById(Long id) {
        return commentRepository.findById(id);
    }

    public void update(MbtiBoardCommentDTO dto) {
        commentRepository.update(dto);
    }

    public void delete(Long id) {
        commentRepository.delete(id);
    }

    public List<MbtiBoardCommentDTO> getComments(int boardId) {
        return commentRepository.findCommentsByBoardId(boardId);
    }



}
