package com.spring.profile.controller;

import com.spring.mbti.dto.MbtiBoardDTO;
import com.spring.profile.dto.ProfileDTO;
import com.spring.profile.service.ProfileService;
import com.spring.user.dto.UserDTO;
import com.spring.user.service.UserService;
import com.spring.mbti.repository.MbtiBoardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class ProfileController {

    private final ProfileService profileService;
    private final MbtiBoardRepository boardRepository;
    private final UserService userService;

    // 마이페이지 메인
    @GetMapping("/profile")
    public String profileMain(Model model, HttpSession session, @RequestParam(value = "userId", required = false) Long userIdParam) {
        Long sessionUserId = (Long) session.getAttribute("userId");
        Long targetUserId = userIdParam != null ? userIdParam : sessionUserId;

        ProfileDTO profile = profileService.findByUserId(targetUserId);
        //List<MbtiBoardDTO> boardList = boardRepository.findByAuthor(targetUserId);

        model.addAttribute("profile", profile);
        //model.addAttribute("boardList", boardList);
        model.addAttribute("isOwner", targetUserId.equals(sessionUserId));

        return "profile/profile";
    }

    // 프로필 수정 페이지
    @GetMapping("/profile/edit")
    public String profileEditPage(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        ProfileDTO profile = profileService.findByUserId(userId);
        model.addAttribute("profile", profile);
        return "profile/ProfileEdit";
    }

    // 프로필 수정 처리
    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute ProfileDTO profile, HttpSession session) {
        int userId = (int) session.getAttribute("userId");
        profile.setUserId(userId);
        profileService.updateProfile(profile);
        return "redirect:/profile";
    }

    // 친구 목록 페이지
    @GetMapping("/profile/friends")
    public String profileFriends(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        List<ProfileDTO> friendList = profileService.findAcceptedFriends(userId);
        model.addAttribute("friendList", friendList);
        return "profile/ProfileFriends";
    }
}
