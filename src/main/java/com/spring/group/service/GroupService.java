package com.spring.group.service;

import com.spring.group.dto.GroupDTO;
import com.spring.group.repository.GroupRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GroupService {

    private final GroupRepository groupRepository;

    public void createGroup(GroupDTO groupDTO) {
        return groupRepository.createGroup(groupDTO);
    }

    public boolean update(GroupDTO groupDTO) {
        int isUpdate = groupRepository.update(groupDTO);
        if(isUpdate>0){
            return true; // 수정 완료
        }else{
            return false;
        }
    }

    public void delete(int id) {
        groupRepository.delete(id);
    }


}
