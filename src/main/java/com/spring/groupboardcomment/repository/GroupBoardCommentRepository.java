package com.spring.groupboardcomment.repository;

import com.spring.groupboardcomment.dto.GroupBoardCommentDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    public void update(int id, String content) {
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        params.put("content", content);
        sql.update("GroupBoardComment.update", params);
    }

    public void delete(int id) {
        sql.update("GroupBoardComment.delete", id);
    }

}
