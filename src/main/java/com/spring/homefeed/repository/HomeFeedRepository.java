package com.spring.homefeed.repository;

import com.spring.homefeed.dto.HomeFeedDTO;
import com.spring.mbti.dto.MbtiBoardDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class HomeFeedRepository {
    private final SqlSessionTemplate sql;

    public List<HomeFeedDTO> getFeedList() {
        return sql.selectList("HomeFeed.getFeedList");
    }

}
