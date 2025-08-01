package com.spring.group.service;

import com.spring.group.dto.GroupDTO;
import com.spring.group.repository.GroupRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GroupService {

    private final GroupRepository groupRepository;

    // 그룹 생성하여 저장
    public void save(GroupDTO groupDTO) {
        groupRepository.save(groupDTO);
    }

    // 그룹 전체 조회
    public List<GroupDTO> findAll() {
        return groupRepository.findAll();
    }

    // 그룹 상세 조회 // 모임장 권한 체크에 필요
    public GroupDTO findById(int id) {
        return groupRepository.findById(id);
    }

    // 그룹 수정
    public boolean update(GroupDTO groupDTO) {
        int isUpdate = groupRepository.update(groupDTO);
        return isUpdate>0;

    }

    // 그룹 삭제
    public void delete(int id) {
        groupRepository.delete(id);
    }



}
