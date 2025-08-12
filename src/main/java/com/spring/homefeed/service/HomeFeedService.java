package com.spring.homefeed.service;

import com.spring.homefeed.dto.HomeFeedDTO;
import com.spring.homefeed.repository.HomeFeedRepository;
import com.spring.mbti.dto.MbtiBoardDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class HomeFeedService {
    private final HomeFeedRepository homeFeedRepository;

    public List<HomeFeedDTO> getFeedList(int mbtiId){
        return homeFeedRepository.getFeedList(mbtiId);
    }

}
