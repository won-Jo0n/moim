package com.spring.profile.controller;

import com.spring.friends.service.FriendsService;
import com.spring.mbti.dto.MbtiDTO;
import com.spring.mbti.service.MbtiService;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.spring.group.dto.GroupDTO;

@Controller
@RequiredArgsConstructor
@RequestMapping("/profile")
public class ProfileController {

    private final org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;
    private final FriendsService friendsService;
    private final ProfileService profileService;
    private final MbtiBoardService mbtiBoardService;
    private final MbtiService mbtiService;

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

        // 내 프로필
        ProfileDTO profile = profileService.getProfile(userId);
        if (profile == null) profile = new ProfileDTO();
        profile.setUserId(userId);
        Integer fileId = profile.getFileId();
        if (fileId == null) fileId = 0;
        profile.setFileId(fileId);

        List<MbtiBoardDTO> boardList = mbtiBoardService.findByAuthor(userId);

        // 친구 목록
        List<UserDTO> friendList = friendsService.getFriends(userId.intValue());

        // MBTI 맵
        Map<Integer, String> friendMbtiMap = new HashMap<>();
        for (UserDTO u : friendList) {
            MbtiDTO mbti = mbtiService.getMbti(u.getMbtiId());
            if (mbti != null) friendMbtiMap.put(u.getId(), mbti.getMbti());
        }

        // ✅ 친구 사진 맵: friend.id -> fileId (각 친구의 프로필을 직접 조회)
        Map<Integer, Integer> friendPhotoMap = new HashMap<>();
        for (UserDTO f : friendList) {
            Integer fid = f.getId();
            if (fid == null) continue;
            ProfileDTO fp = profileService.findByUserId(fid.longValue());
            friendPhotoMap.put(fid, fp != null ? fp.getFileId() : null);
        }
        model.addAttribute("friendPhotoMap", friendPhotoMap); // JSP에서 사용

        model.addAttribute("profile", profile);
        model.addAttribute("boardList", boardList);
        model.addAttribute("friendList", friendList);
        model.addAttribute("friendMbtiMap", friendMbtiMap);
        model.addAttribute("isOwner", true);

        // ✅ 내 페이지에서는 버튼 안 보이지만 JSP에서 사용하는 값 기본 세팅
        model.addAttribute("friendshipStatus", "NONE");

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

        Integer fileId = profile.getFileId();
        if (fileId == null) fileId = 0;
        profile.setFileId(fileId);

        List<MbtiBoardDTO> boardList = mbtiBoardService.findByAuthor(userId);
        List<UserDTO> friendList = friendsService.getFriends(userId.intValue());

        // ✅ 다른 사람 페이지에서도 사진 맵 제공 (동일 로직)
        Map<Integer, Integer> friendPhotoMap = new HashMap<>();
        for (UserDTO f : friendList) {
            Integer fid = f.getId();
            if (fid == null) continue;
            ProfileDTO fp = profileService.findByUserId(fid.longValue());
            friendPhotoMap.put(fid, fp != null ? fp.getFileId() : null);
        }
        model.addAttribute("friendPhotoMap", friendPhotoMap);

        Object sid = session.getAttribute("userId");
        Long sessionUserId = null;
        if (sid instanceof Integer) sessionUserId = ((Integer) sid).longValue();
        else if (sid instanceof Long) sessionUserId = (Long) sid;
        boolean isOwner = (sessionUserId != null && sessionUserId.equals(userId));

        // ✅ 친구 상태 조회해서 JSP로 전달 (NONE | PENDING | ACCEPTED)
        String friendshipStatus = "NONE";
        if (sessionUserId != null && !isOwner) {
            String status = friendsService.getFriendshipStatus(sessionUserId, userId);
            friendshipStatus = (status != null) ? status : "NONE";
        }
        model.addAttribute("friendshipStatus", friendshipStatus);

        model.addAttribute("profile", profile);
        model.addAttribute("boardList", boardList);
        model.addAttribute("friendList", friendList);
        model.addAttribute("isOwner", isOwner);
        return "profile/profile";
    }

    @PostMapping("/photo")
    public String updateProfilePhoto(HttpSession session,
                                     @RequestParam(value = "profileFile", required = false) MultipartFile profileFile,
                                     @RequestParam(value = "deletePhoto", required = false, defaultValue = "false") boolean deletePhoto
    ) throws IOException {
        Object uid = session.getAttribute("userId");
        if (uid == null) return "redirect:/login";
        Long userId = (uid instanceof Integer) ? ((Integer) uid).longValue() : (Long) uid;

        if (profileFile != null && !profileFile.isEmpty()) {
            int newFileId = fileUtil.fileSave(profileFile);
            profileService.updateFileId(userId, newFileId);
            return "redirect:/profile";
        }

        if (deletePhoto) {
            profileService.updateFileId(userId, null);
        }
        return "redirect:/profile";
    }

    @PostMapping("/photo/delete")
    public String deleteProfilePhoto(HttpSession session) {
        Object uid = session.getAttribute("userId");
        if (uid == null) return "redirect:/login";
        Long userId = (uid instanceof Integer) ? ((Integer) uid).longValue() : (Long) uid;

        profileService.updateFileId(userId, null);
        return "redirect:/profile/profile/update";
    }

    @PostMapping("/withdraw")
    public String withdraw(HttpSession session,
                           @RequestParam("password") String password,
                           org.springframework.web.servlet.mvc.support.RedirectAttributes ra) {
        Object uid = session.getAttribute("userId");
        if (uid == null) return "redirect:/login";
        Long userId = (uid instanceof Integer) ? ((Integer) uid).longValue() : (Long) uid;

        String encoded = profileService.getPasswordHash(userId);
        if (encoded == null || !passwordEncoder.matches(password, encoded)) {
            ra.addFlashAttribute("withdrawError", "비밀번호를 잘못 입력하셨습니다.");
            return "redirect:/profile/profile/update";
        }

        profileService.withdraw(userId);
        session.invalidate();
        return "redirect:/";
    }

    @PostMapping("/friends/delete")
    public String deleteFriend(@RequestParam("friendId") Long friendId,
                               HttpSession session,
                               org.springframework.web.servlet.mvc.support.RedirectAttributes ra) {
        Object userIdObj = session.getAttribute("userId");
        Long userId = null;
        if (userIdObj instanceof Integer) userId = ((Integer) userIdObj).longValue();
        else if (userIdObj instanceof Long) userId = (Long) userIdObj;

        if (userId == null) return "redirect:/login";

        int affected = friendsService.deleteFriendship(userId, friendId);
        if (affected > 0) ra.addFlashAttribute("msg", "친구를 삭제했어요.");
        else ra.addFlashAttribute("msg", "삭제할 친구 관계가 없어요.");

        return "redirect:/profile/friends";
    }
}
