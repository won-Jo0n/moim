package com.spring.userjoingroup.controller;


import com.spring.userjoingroup.dto.UserJoinGroupDTO;
import com.spring.userjoingroup.service.UserJoinGroupService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/groupjoin")
public class UserJoinGroupController {
    private final UserJoinGroupService userJoinGroupService;

    // 참여 신청
    @PostMapping("/apply")
    public String apply(@RequestParam int groupId, HttpSession session) {
        int userId = (int) session.getAttribute("userId");
        userJoinGroupService.applyToGroup(userId, groupId);
        return "redirect:/group/detail?groupId=" + groupId;
    }

    // 신청 취소
    @PostMapping("/cancel")
    public String cancel(@RequestParam int groupId, HttpSession session) {
        int userId = (int) session.getAttribute("userId");
        userJoinGroupService.cancelApplication(userId, groupId);
        return "redirect:/group/detail?groupId=" + groupId;
    }

    // 모임장이 신청자 확인
    @GetMapping("/requests")
    public String viewRequests(@RequestParam int groupId, Model model) {
        List<UserJoinGroupDTO> pendingList = userJoinGroupService.getPendingRequests(groupId);
        model.addAttribute("pendingList", pendingList);
        return "/group/request-list"; // JSP 페이지
    }

    // 승인
    @PostMapping("/approve")
    public String approve(@RequestParam int userId, @RequestParam int groupId) {
        userJoinGroupService.updateStatus(userId, groupId, "approved");
        return "redirect:/groupjoin/requests?groupId=" + groupId;
    }

    // 거절
    @PostMapping("/reject")
    public String reject(@RequestParam int userId, @RequestParam int groupId) {
        userJoinGroupService.updateStatus(userId, groupId, "rejected");
        return "redirect:/groupjoin/requests?groupId=" + groupId;
    }
}


