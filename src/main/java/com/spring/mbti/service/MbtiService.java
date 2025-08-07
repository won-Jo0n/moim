package com.spring.mbti.service;

import com.spring.admin.dto.ChartCountDTO;
import com.spring.admin.dto.MbtiGroupActivityAverageDTO;
import com.spring.admin.dto.UserAgeRatioDTO;
import com.spring.admin.dto.UserGenderRatioDTO;
import com.spring.mbti.dto.MbtiDTO;
import com.spring.mbti.repository.MbtiRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MbtiService {
    private final MbtiRepository mbtiRepository;

    public MbtiDTO getMbti(int id){
        return mbtiRepository.getMbti(id);
    }


    public List<MbtiDTO> getMbtiList() {
        return mbtiRepository.getMbtiList();
    }

    public List<String> getMbtiLabels() {
        return mbtiRepository.getMbtiLabels();
    }

    public List<ChartCountDTO> getCountGroupByMbti() {
        return mbtiRepository.getCountGroupByMbti();
    }

    public List<UserGenderRatioDTO> getCountGroupByGender() {
        return mbtiRepository.getCountGroupByGender();
    }

    public List<UserAgeRatioDTO> getCountGroupByAge() {
        return mbtiRepository.getCountGroupByAge();
    }

    public List<MbtiGroupActivityAverageDTO> getMbtiGroupActivity() {
        return mbtiRepository.getMbtiGroupActivity();
    }
}
