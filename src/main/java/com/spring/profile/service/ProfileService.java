package com.spring.profile.service;

import com.spring.mbti.dto.MbtiBoardDTO;
import com.spring.profile.dto.ProfileDTO;
import com.spring.profile.repository.ProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ProfileService {
    private final ProfileRepository repository;

    public ProfileDTO getProfileByUserId(int userId) {
        ProfileDTO dto = repository.findProfileByUserId(userId);
        dto.setGrade(getGradeByRating(dto.getRating()));
        return dto;
    }

    private String getGradeByRating(int rating) {
        if (rating >= 800) return " 다이아";
        if (rating >= 500) return " 플래티넘";
        if (rating >= 300) return " 골드";
        if (rating >= 100) return " 실버";
        return " 브론즈";
    }

    // 게시글 작성 시 호출할 메서드
    public void onPostCreated(int userId) {
        repository.updateRating(userId, 10);
        repository.updatePoint(userId, 10);
    }

    // 댓글 작성 시 호출할 메서드
    public void onCommentCreated(int userId) {
        repository.updateRating(userId, 5);
        repository.updatePoint(userId, 5);
    }

    public Map<String, Object> getProfileWithMyBoards(int userId) {
        ProfileDTO profile = repository.findProfileByUserId(userId);
        profile.setGrade(getGradeByRating(profile.getRating()));

        List<MbtiBoardDTO> myPosts = repository.findBoardsByUserId(userId);

        Map<String, Object> result = new HashMap<>();
        result.put("profile", profile);
        result.put("myPosts", myPosts);
        return result;
    }

}

