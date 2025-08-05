package com.spring.mbti.service;

import com.spring.mbti.dto.FeedBoardCommentDTO;
import com.spring.mbti.repository.FeedBoardCommentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FeedBoardCommentService {

    private final FeedBoardCommentRepository repository;

    public void save(FeedBoardCommentDTO dto) {
        repository.save(dto);
    }

    public List<FeedBoardCommentDTO> findAllByFeedId(Long feedId) {
        return repository.findAllByFeedId(feedId);
    }

    public void update(FeedBoardCommentDTO dto) {
        repository.update(dto);
    }

    public void delete(Long id) {
        repository.delete(id);
    }

    public List<FeedBoardCommentDTO> findReplies(Long parentId) {
        return repository.findRepliesByParentId(parentId);
    }
}
