package com.spring.mbti.service;

import com.spring.mbti.dto.MbtiBoardDTO;
import com.spring.mbti.repository.MbtiBoardRepository;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MbtiBoardService {

    private final SqlSessionTemplate sqlSession;

    public List<MbtiBoardDTO> findAll() {
        return sqlSession.selectList("MbtiBoard.findAll");
    }

    public MbtiBoardDTO findById(Long id) {
        return sqlSession.selectOne("MbtiBoard.findById", id);
    }

    public void save(MbtiBoardDTO dto) {
        sqlSession.insert("MbtiBoard.save", dto);
    }

    public void update(MbtiBoardDTO dto) {
        System.out.println(dto.getAuthor());
        System.out.println(dto.getTitle());
        System.out.println(dto.getContent());
        sqlSession.update("MbtiBoard.update", dto);
    }

    public void delete(Long id) {
        sqlSession.delete("MbtiBoard.delete", id);
    }

    private final MbtiBoardRepository boardRepository;

    public List<MbtiBoardDTO> findByAuthor(Long userId) {
        return boardRepository.findByAuthor(userId);
    }

    public void increaseHitsIfFirstView(HttpSession session, Long boardId) {
        String key = "viewed_board_" + boardId;
        if (session.getAttribute(key) == null) {
            boardRepository.incrementHits(boardId);
            session.setAttribute(key, Boolean.TRUE);
        }
    }

    public void updateFileId(MbtiBoardDTO dto) {
        sqlSession.update("MbtiBoard.updateFileId", dto);
    }
}
