package com.spring.mbti.service;

import com.spring.mbti.dto.MbtiTestDTO;
import com.spring.mbti.repository.MbtiTestRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class MbtiTestService {

    private final MbtiTestRepository mbtiTestRepository;

    public List<MbtiTestDTO> findAllQuestions() {
        return mbtiTestRepository.findAllQuestions();
    }

    public String calculateMbti(int userId, List<Integer> answers) {
        List<MbtiTestDTO> questions = mbtiTestRepository.findAllQuestions();

        Map<String, Integer> scoreMap = new HashMap<>();
        scoreMap.put("ie", 0); scoreMap.put("ei", 0);
        scoreMap.put("sn", 0); scoreMap.put("ns", 0);
        scoreMap.put("tf", 0); scoreMap.put("ft", 0);
        scoreMap.put("jp", 0); scoreMap.put("pj", 0);

        for (int i = 0; i < answers.size(); i++) {
            MbtiTestDTO dto = questions.get(i);
            String type = dto.getType();
            int point = answers.get(i);

            scoreMap.put(type, scoreMap.get(type) + point);
        }

        StringBuilder result = new StringBuilder();
        result.append(scoreMap.get("ie") >= scoreMap.get("ei") ? "E" : "I");
        result.append(scoreMap.get("sn") >= scoreMap.get("ns") ? "S" : "N");
        result.append(scoreMap.get("tf") >= scoreMap.get("ft") ? "T" : "F");
        result.append(scoreMap.get("jp") >= scoreMap.get("pj") ? "J" : "P");

        return result.toString();
    }
}