package com.spring.groupboardcomment.repository;

import com.spring.groupboardcomment.dto.GroupBoardCommentDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class GroupBoardCommentRepository {

    private final SqlSessionTemplate sql;

    public void save(GroupBoardCommentDTO groupBoardCommentDTO) {
        sql.insert("GroupBoardComment.save", groupBoardCommentDTO);
    }

    public List<GroupBoardCommentDTO> findByBoardId(int boardId) {
        return sql.selectList("GroupBoardComment.findByBoardId", boardId);
    }

    public void delete(int id) {
        sql.update("GroupBoardComment.delete", id);
    }

}
