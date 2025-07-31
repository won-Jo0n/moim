package com.spring.group.repository;

import com.spring.group.dto.GroupDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class GroupRepository {
    private final SqlSessionTemplate sqlSessionTemplate;

    public void createGroup(GroupDTO groupDTO) {
        return sql.insert("Group.createGroup",groupDTO);

    }

    public int update(GroupDTO groupDTO) {
        return sql.update("Group.update",groupDTO);
    }

    public void delete(int id) {
        return sql.delete("Group.delete",id);
    }
}
