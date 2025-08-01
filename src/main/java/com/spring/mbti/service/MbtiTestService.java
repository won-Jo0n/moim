package com.spring.mbti.service;

import com.spring.mbti.dto.MbtiTestDTO;
import com.spring.mbti.repository.MbtiTestRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class MbtiTestService {

    private final MbtiTestRepository mbtiTestRepository;

    // 1. 모든 질문 불러오기
    public List<MbtiTestDTO> findAllQuestions() {
        return mbtiTestRepository.findAllQuestions();
    }
    public int findUserIdByLoginId(String loginId) {
        return mbtiTestRepository.findUserIdByLoginId(loginId);
    }


    // 2. 점수로 MBTI 계산하고 DB 저장까지 처리
    public String calculateMbti(int userId, List<Integer> answers) {
        List<MbtiTestDTO> questions = findAllQuestions();

        // 점수 누적용 맵 (예: ei → 10점, ie → 5점)
        Map<String, Integer> scoreMap = new HashMap<>();
        for (int i = 0; i < questions.size(); i++) {
            MbtiTestDTO q = questions.get(i);
            String type = q.getType();
            int score = answers.get(i);

            scoreMap.put(type, scoreMap.getOrDefault(type, 0) + score);
        }

        // 각 축별 dominant 성향 선택
        StringBuilder result = new StringBuilder();
        result.append(scoreMap.getOrDefault("ei", 0) >= scoreMap.getOrDefault("ie", 0) ? "E" : "I");
        result.append(scoreMap.getOrDefault("sn", 0) >= scoreMap.getOrDefault("ns", 0) ? "S" : "N");
        result.append(scoreMap.getOrDefault("tf", 0) >= scoreMap.getOrDefault("ft", 0) ? "T" : "F");
        result.append(scoreMap.getOrDefault("jp", 0) >= scoreMap.getOrDefault("pj", 0) ? "J" : "P");

        String mbtiCode = result.toString();

        // 3. MBTI 결과를 user 테이블에 반영
        int mbtiId = mbtiTestRepository.findMbtiIdByCode(mbtiCode);
        mbtiTestRepository.updateUserMbti(userId, mbtiId);

        return mbtiCode;
    }

}
