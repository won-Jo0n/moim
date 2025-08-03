package com.spring.mbti.repository;

import com.spring.mbti.dto.MbtiDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class MbtiRepository {
    private final SqlSessionTemplate sql;

    public List<MbtiDTO> getMbtiList(){
        return sql.selectList("Mbti.getMbtiList");
    }
}
