package com.spring.userjoingroup.controller;


import com.spring.group.dto.GroupDTO;
import com.spring.group.service.GroupService;
import com.spring.userjoingroup.dto.UserJoinGroupDTO;
import com.spring.userjoingroup.repository.UserJoinGroupRepository;
import com.spring.userjoingroup.service.UserJoinGroupService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/groupjoin")
public class UserJoinGroupController {
    private final UserJoinGroupService userJoinGroupService;
    private final GroupService groupService;
    private final UserJoinGroupRepository userJoinGroupRepository;

    // 참여 신청
    @PostMapping("/apply")
    public String applyToGroup(@ModelAttribute UserJoinGroupDTO userJoinGroupDTO,
                               HttpSession session) {
        UserJoinGroupDTO existing = userJoinGroupRepository.findOne(userJoinGroupDTO);

        if (existing != null) {
            throw new IllegalStateException("이미 신청한 모임입니다.");
        }

        userJoinGroupDTO.setStatus("pending");
        userJoinGroupDTO.setRole("member");
        userJoinGroupDTO.setJoinedAt(null); // 승인 전이므로 null
        userJoinGroupRepository.insertRequest(userJoinGroupDTO);

        return "redirect:/group/detail?groupId=" + userJoinGroupDTO.getGroupId();
    }

    // 신청 취소
    @PostMapping("/cancel")
    public String cancel(@RequestParam("groupId") int groupId, HttpSession session) {
        int userId = (int) session.getAttribute("userId");
        userJoinGroupService.cancelApplication(userId, groupId);

        return "redirect:/group/detail?groupId=" + groupId;
    }

    // 모임장이 신청자 확인 // 신청자 목록 보기
    @GetMapping("/requests")
    public String viewRequests(@RequestParam("groupId") int groupId,
                               Model model,
                               HttpSession session) {
        GroupDTO group = groupService.findById(groupId);
        int loginUserId = (int) session.getAttribute("userId");

        // 모임장이 아닐 경우 접근 차단
        if(loginUserId != group.getLeader()){
            return "redirect:/group/detail?groupId=" + groupId;
        }

        List<UserJoinGroupDTO> pendingList = userJoinGroupService.getPendingRequests(groupId);

        model.addAttribute("pendingList", pendingList);
        model.addAttribute("groupId",groupId);
        return "group/requestList";
    }


    // 승인 처리
    @PostMapping("/approve")
    public String approve(@RequestParam("userId") int userId,
                          @RequestParam("groupId") int groupId) {
        userJoinGroupService.updateStatus(userId, groupId, "approved");
        return "redirect:/groupjoin/requests?groupId=" + groupId;
    }

    // 거절 처리
    @PostMapping("/reject")
    public String reject(@RequestParam("userId") int userId,
                         @RequestParam("groupId") int groupId) {
        userJoinGroupService.updateStatus(userId, groupId, "rejected");
        return "redirect:/groupjoin/requests?groupId=" + groupId;
    }

    // 그룹 탈퇴
    @PostMapping("/leave")
    public String leaveGroup(@RequestParam("groupId") int groupId, HttpSession session){
        int userId = (int) session.getAttribute("userId");
        userJoinGroupService.leaveGroup(userId, groupId);
        return "redirect:/group/detail?groupId="+groupId;
    }
}


