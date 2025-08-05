package com.spring.profile.controller;

import com.spring.profile.dto.ProfileDTO;
import com.spring.profile.service.ProfileService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class ProfileController {

    private final ProfileService profileService;

    // 마이페이지 접속 (본인만 가능)
    @GetMapping("/mypage")
    public String myPage(Model model, HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        Map<String, Object> result = profileService.getProfileWithMyBoards(userId);
        model.addAttribute("profile", result.get("profile"));
        model.addAttribute("myPosts", result.get("myPosts"));

        return "profile/profile"; // /WEB-INF/views/profile/profile.jsp
    }

    // (선택) 테스트용: 게시글 작성 시 호출
    @GetMapping("/mypage/test/post")
    public String simulatePost(HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId != null) {
            profileService.onPostCreated(userId); // 게시글 작성 시 온도 +0.5, 포인트 +10, 등급 점수 +10
        }

        return "redirect:/mypage";
    }



}
