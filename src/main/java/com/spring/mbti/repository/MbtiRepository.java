package com.spring.mbti.repository;

import com.spring.admin.dto.ChartCountDTO;
import com.spring.admin.dto.MbtiGroupActivityAverageDTO;
import com.spring.admin.dto.UserAgeRatioDTO;
import com.spring.admin.dto.UserGenderRatioDTO;
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

    public List<String> getMbtiLabels() {
        return sql.selectList("Mbti.getMbtiLabels");
    }

    public List<ChartCountDTO> getCountGroupByMbti() {
        return sql.selectList("Mbti.getCountGroupByMbti");
    }

    public List<UserGenderRatioDTO> getCountGroupByGender() {
        return sql.selectList("Mbti.getCountGroupByGender");
    }

    public List<UserAgeRatioDTO> getCountGroupByAge() {
        return sql.selectList("Mbti.getCountGroupByAge");
    }

    public MbtiDTO getMbti(int id) {
        return sql.selectOne("Mbti.getMbti", id);
    }

    public List<MbtiGroupActivityAverageDTO> getMbtiGroupActivity() {
        return sql.selectList("Mbti.getMbtiGroupActivity");
    }
}
