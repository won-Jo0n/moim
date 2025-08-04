package com.spring.mbti.service;

import com.spring.admin.dto.ChartCountDTO;
import com.spring.mbti.dto.MbtiDTO;
import com.spring.mbti.repository.MbtiRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MbtiService {
    private final MbtiRepository mbtiRepository;


    public List<MbtiDTO> getMbtiList() {
        return mbtiRepository.getMbtiList();
    }

    public List<String> getMbtiLabels() {
        return mbtiRepository.getMbtiLabels();
    }

    public List<ChartCountDTO> getCountGroupByMbti() {
        return mbtiRepository.getCountGroupByMbti();
    }
}
