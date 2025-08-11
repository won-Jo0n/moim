package com.spring.groupboard.service;

import com.spring.groupboard.dto.GroupBoardDTO;
import com.spring.groupboard.repository.GroupBoardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GroupBoardService {

    private final GroupBoardRepository groupBoardRepository;

    // 그룹ID로 게시글 목록 조회
    public List<GroupBoardDTO> findByGroupId(int groupId) {
        return groupBoardRepository.findByGroupId(groupId);
    }

    // 게시글 상세조회
    public GroupBoardDTO findById(int id) {
        return groupBoardRepository.findById(id);
    }

    // 게시글 저장
    public void save(GroupBoardDTO dto) {
        groupBoardRepository.save(dto);
    }

    // 게시글 수정
    public void update(GroupBoardDTO dto) {
        groupBoardRepository.update(dto);
    }

    // 게시글 삭제
    public void delete(int id) {
        groupBoardRepository.delete(id);
    }

    // 조회수 증가
    public void increaseHits(int id) {
        groupBoardRepository.increaseHits(id);
    }



}
