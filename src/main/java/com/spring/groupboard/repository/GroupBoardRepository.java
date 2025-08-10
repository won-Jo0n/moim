package com.spring.groupboard.repository;

import com.spring.groupboard.dto.GroupBoardDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class GroupBoardRepository {

    private final SqlSessionTemplate sql;

    // 게시글 목록
    public List<GroupBoardDTO> findByGroupId(int groupId) {
        return sql.selectList("GroupBoard.findByGroupId", groupId);
    }

    // 게시글 상세조회
    public GroupBoardDTO findById(int id) {
        return sql.selectOne("GroupBoard.findById", id);
    }

    // 게시글 저장
    public void save(GroupBoardDTO groupBoardDTO) {
        sql.insert("GroupBoard.save", groupBoardDTO);
    }

    // 게시글 수정
    public void update(GroupBoardDTO dto) {
        sql.update("GroupBoard.update", dto);
    }

    // 게시글 삭제
    public void delete(int id) {
        sql.delete( "GroupBoard.delete", id);
    }

    // 조회수 증가
    public void increaseHits(int id) {
        sql.update("GroupBoard.increaseHits", id);
    }
}
