package com.spring.groupboard.repository;

import com.spring.groupboard.dto.GroupBoardDTO;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class GroupBoardRepository {

    private final SqlSession sql;

    private static final String NAMESPACE = "com.spring.groupboard.repository.GroupBoardRepository";

    public List<GroupBoardDTO> findByGroupId(int groupId) {
        return sql.selectList(NAMESPACE + ".findByGroupId", groupId);
    }

    public void save(GroupBoardDTO dto) {
        sql.insert(NAMESPACE + ".save", dto);
    }

    public void delete(int id) {
        sql.delete(NAMESPACE + ".delete", id);
    }
}
