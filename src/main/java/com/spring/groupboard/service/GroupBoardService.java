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

    public List<GroupBoardDTO> findByGroupId(int groupId) {
        return groupBoardRepository.findByGroupId(groupId);
    }

    public void save(GroupBoardDTO dto) {
        groupBoardRepository.save(dto);
    }

    public void delete(int id) {
        groupBoardRepository.delete(id);
    }
}
