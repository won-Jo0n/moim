package com.spring.groupboardcomment.service;

import com.spring.groupboardcomment.dto.GroupBoardCommentDTO;
import com.spring.groupboardcomment.repository.GroupBoardCommentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GroupBoardCommentService {

    public final GroupBoardCommentRepository groupBoardCommentRepository;

    public void save(GroupBoardCommentDTO dto) {
        groupBoardCommentRepository.save(dto);
    }

    public List<GroupBoardCommentDTO> findByBoardId(int boardId) {
        return groupBoardCommentRepository.findByBoardId(boardId);
    }

    public void delete(int id) {
        groupBoardCommentRepository.delete(id);
    }
}
