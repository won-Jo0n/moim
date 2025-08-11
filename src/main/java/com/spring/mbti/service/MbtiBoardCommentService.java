package com.spring.mbti.service;

import com.spring.mbti.dto.MbtiBoardCommentDTO;
import com.spring.mbti.repository.MbtiBoardCommentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MbtiBoardCommentService {

    private final MbtiBoardCommentRepository commentRepository;

    public void save(MbtiBoardCommentDTO dto) {
        commentRepository.save(dto);
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
