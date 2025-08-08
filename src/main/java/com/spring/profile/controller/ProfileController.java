package com.spring.profile.controller;

import com.spring.friends.service.FriendsService;
import com.spring.profile.dto.ProfileDTO;
import com.spring.profile.service.ProfileService;
import com.spring.mbti.dto.MbtiBoardDTO;
import com.spring.mbti.service.MbtiBoardService;
import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/profile")
public class ProfileController {
    private  final FriendsService friendsService;
    private final ProfileService profileService;
    private final MbtiBoardService mbtiBoardService;

    @GetMapping
    public String myPage(HttpSession session, Model model) {
        Object userIdObj = session.getAttribute("userId");
        Long userId = null;

        if (userIdObj instanceof Integer) {
            userId = ((Integer) userIdObj).longValue();
        } else if (userIdObj instanceof Long) {
            userId = (Long) userIdObj;
        }

        if (userId == null) return "redirect:/login";

        ProfileDTO profile = profileService.getProfile(userId);
        List<MbtiBoardDTO> boardList = mbtiBoardService.findByAuthor(userId);
        // FriendsService 의존성 주입받아서 사용하면됨 택준이형이 만들어놨어
        List<UserDTO> friendList = friendsService.getFriends(userId.intValue()); // 친구 3개 표시용

        model.addAttribute("profile", profile);
        model.addAttribute("boardList", boardList);
        model.addAttribute("friendList", friendList);

        return "profile/profile";
    }

    @GetMapping("/mbti/board/{id}")
    public String detail(@PathVariable Long id, Model model) {
        MbtiBoardDTO board = mbtiBoardService.findById(id);
        model.addAttribute("board", board);
        return "MbtiBoardViews/detail";
    }

    @GetMapping("/profile/update")
    public String editForm(HttpSession session, Model model) {
        Object userIdObj = session.getAttribute("userId");
        Long userId = null;

        if (userIdObj instanceof Integer) {
            userId = ((Integer) userIdObj).longValue();
        } else if (userIdObj instanceof Long) {
            userId = (Long) userIdObj;
        }

        if (userId == null) return "redirect:/login";

        ProfileDTO profile = profileService.findByUserId(userId);
        model.addAttribute("profile", profile);
        return "profile/ProfileEdit";
    }


    @GetMapping("/friends")
    public String friendList(HttpSession session, Model model) {
        Object userIdObj = session.getAttribute("userId");
        Long userId = null;

        if (userIdObj instanceof Integer) {
            userId = ((Integer) userIdObj).longValue();
        } else if (userIdObj instanceof Long) {
            userId = (Long) userIdObj;
        }

        if (userId == null) return "redirect:/login";

        List<ProfileDTO> friends = profileService.getFriendList(userId);
        model.addAttribute("friends", friends);
        return "profile/friends";
    }
    @GetMapping("/view/{userId}")
    public String viewOther(@PathVariable Long userId, Model model) {
        ProfileDTO profile = profileService.findByUserId(userId);
        if (profile == null) return "redirect:/profile";

        List<MbtiBoardDTO> boardList = mbtiBoardService.findByAuthor(userId);
        List<UserDTO> friendList = friendsService.getFriends(userId.intValue());

        model.addAttribute("profile", profile);
        model.addAttribute("boardList", boardList);
        model.addAttribute("friendList", friendList);
        return "profile/profile";
    }
}
