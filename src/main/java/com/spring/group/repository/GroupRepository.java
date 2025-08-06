package com.spring.group.repository;

import com.spring.group.dto.GroupDTO;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.annotations.Param;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class GroupRepository {
    private final SqlSessionTemplate sql;

    // 그룹 생성하여 저장
    public void save(GroupDTO groupDTO) {
        sql.insert("Group.createGroup",groupDTO);
    }

    // 그룹 전체 조회
    public List<GroupDTO> findAll() {
        return sql.selectList("Group.findAll");
    }

    // 그룹 검색 조회
    public List<GroupDTO> searchByKeyword(@Param("keyword") String keyword) {
        return sql.selectList("Group.searchByKeyword", keyword);
    }

    // 그룹 상세 조회
    public GroupDTO findById(int id) {
        return sql.selectOne("Group.findById", id);
    }

    // 그룹 수정
    public int update(GroupDTO groupDTO) {
        return sql.update("Group.update",groupDTO);
    }

    // 그룹 삭제
    public int delete(int id) {
        return sql.delete("Group.delete",id);
    }


}
