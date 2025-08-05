package com.spring.group.service;

import com.spring.group.dto.GroupDTO;
import com.spring.group.repository.GroupRepository;
import com.spring.userjoingroup.dto.UserJoinGroupDTO;
import com.spring.userjoingroup.repository.UserJoinGroupRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GroupService {

    private final GroupRepository groupRepository;
    private final UserJoinGroupRepository userJoinGroupRepository;

    // 그룹 생성하여 저장
    // userJoinGroup 같이 처리 (모임장 함께 등록)
    @Transactional
    public void save(GroupDTO groupDTO, int loginUserId) {
        groupRepository.save(groupDTO);  // 그룹 insert
        // 그룹 생성 후, userJoinGroup에 leader 등록
        UserJoinGroupDTO join = new UserJoinGroupDTO();
        join.setUserId(loginUserId);
        join.setGroupId(groupDTO.getId());  // auto_increment 된 ID
        join.setRole("leader");

        userJoinGroupRepository.insert(join);
    }

    // 그룹 검색 조회
    public List<GroupDTO> searchGroups(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return groupRepository.findAll();
        }else{
            return groupRepository.searchByKeyword(keyword);
        }
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
    // userJoinGroup 같이 처리
    public void delete(int id) {
        userJoinGroupRepository.deleteByGroupId(id); // 연관 테이블 먼저 정리
        groupRepository.delete(id); // 이후 삭제
    }

}
