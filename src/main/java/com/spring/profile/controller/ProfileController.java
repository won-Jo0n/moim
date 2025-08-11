package com.spring.profile.controller;

import com.spring.friends.service.FriendsService;
import com.spring.profile.dto.ProfileDTO;
import com.spring.profile.service.ProfileService;
import com.spring.mbti.dto.MbtiBoardDTO;
import com.spring.mbti.service.MbtiBoardService;
import com.spring.user.dto.UserDTO;
import com.spring.utils.FileUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import com.spring.group.dto.GroupDTO;

@Controller
@RequiredArgsConstructor
@RequestMapping("/profile")
public class ProfileController {

    private final org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;
    private final FriendsService friendsService;
    private final ProfileService profileService;
    private final MbtiBoardService mbtiBoardService;

    // 파일 저장만 사용 (User 모듈 미수정)
    private final FileUtil fileUtil;

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

        List<GroupDTO> groupList = profileService.getGroupList(userId);
        model.addAttribute("groupList", groupList);

        // 프로필 조회 (fileId 포함)
        ProfileDTO profile = profileService.getProfile(userId);
        if (profile == null) profile = new ProfileDTO();
        profile.setUserId(userId);

        // 화면 표시용 기본 이미지(id=0) 적용
        Integer fileId = profile.getFileId();
        if (fileId == null) fileId = 0;
        profile.setFileId(fileId);

        List<MbtiBoardDTO> boardList = mbtiBoardService.findByAuthor(userId);
        List<UserDTO> friendList = friendsService.getFriends(userId.intValue());

        model.addAttribute("profile", profile);
        model.addAttribute("boardList", boardList);
        model.addAttribute("friendList", friendList);
        model.addAttribute("isOwner", true);

        return "profile/profile";
    }

    @GetMapping("/mbti/board/{id}")
    public String detail(@PathVariable Long id, Model model) {
        MbtiBoardDTO board = mbtiBoardService.findById(id);
        model.addAttribute("board", board);
        return "MbtiBoardViews/detail";
    }

    // 기존 경로 유지(⇒ 실제 호출 URL: /profile/profile/update)
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
        if (profile == null) profile = new ProfileDTO();
        profile.setUserId(userId);

        // 화면 표시용 기본 이미지(id=0) 적용
        Integer fileId = profile.getFileId();
        if (fileId == null) fileId = 0;
        profile.setFileId(fileId);

        model.addAttribute("profile", profile);
        model.addAttribute("isOwner", true);
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
    public String viewOther(@PathVariable Long userId, HttpSession session, Model model) {
        ProfileDTO profile = profileService.findByUserId(userId);
        if (profile == null) profile = new ProfileDTO();
        profile.setUserId(userId);

        // 화면 표시용 기본 이미지(id=0) 적용
        Integer fileId = profile.getFileId();
        if (fileId == null) fileId = 0;
        profile.setFileId(fileId);

        List<MbtiBoardDTO> boardList = mbtiBoardService.findByAuthor(userId);
        List<UserDTO> friendList = friendsService.getFriends(userId.intValue());

        // isOwner 계산
        Object sid = session.getAttribute("userId");
        Long sessionUserId = null;
        if (sid instanceof Integer) sessionUserId = ((Integer) sid).longValue();
        else if (sid instanceof Long) sessionUserId = (Long) sid;
        boolean isOwner = (sessionUserId != null && sessionUserId.equals(userId));

        model.addAttribute("profile", profile);
        model.addAttribute("boardList", boardList);
        model.addAttribute("friendList", friendList);
        model.addAttribute("isOwner", isOwner);
        return "profile/profile";
    }

    // 프로필 사진 업로드/교체 (profile 테이블만 갱신)
    @PostMapping("/photo")
    public String updateProfilePhoto(HttpSession session,
                                     @RequestParam(value = "profileFile", required = false) MultipartFile profileFile) throws IOException {
        Object uid = session.getAttribute("userId");
        if (uid == null) return "redirect:/login";
        Long userId = (uid instanceof Integer) ? ((Integer) uid).longValue() : (Long) uid;

        if (profileFile != null && !profileFile.isEmpty()) {
            int newFileId = fileUtil.fileSave(profileFile);
            profileService.updateFileId(userId, newFileId);
        }
        return "redirect:/profile";
    }

    // 프로필 사진 제거 (NULL 저장 → 조회 시 기본 0으로 표시)
    @PostMapping("/photo/delete")
    public String deleteProfilePhoto(HttpSession session) {
        Object uid = session.getAttribute("userId");
        if (uid == null) return "redirect:/login";
        Long userId = (uid instanceof Integer) ? ((Integer) uid).longValue() : (Long) uid;

        profileService.updateFileId(userId, null); // profile.fileId = NULL
        return "redirect:/profile/profile/update";
    }

    // 회원 탈퇴 (비밀번호 확인 후 status = -1 로 소프트 삭제)
    @PostMapping("/withdraw")
    public String withdraw(HttpSession session,
                           @RequestParam("password") String password,
                           org.springframework.web.servlet.mvc.support.RedirectAttributes ra) {
        Object uid = session.getAttribute("userId");
        if (uid == null) return "redirect:/login";
        Long userId = (uid instanceof Integer) ? ((Integer) uid).longValue() : (Long) uid;

        String encoded = profileService.getPasswordHash(userId);
        if (encoded == null || !passwordEncoder.matches(password, encoded)) {
            ra.addFlashAttribute("error", "비밀번호가 일치하지 않습니다.");
            return "redirect:/profile/profile/update";
        }

        profileService.withdraw(userId);   // status = -1 로 업데이트
        session.invalidate();
        return "redirect:/";
    }
}
