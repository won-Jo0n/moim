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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

    // 모임장이 신청자 확인 + 승인된 멤버 목록 (매니저 지정/해제 버튼 노출)
    @GetMapping("/requests")
    public String viewRequests(@RequestParam("groupId") int groupId,
                               Model model,
                               HttpSession session) {
        GroupDTO group = groupService.findById(groupId);
        int loginUserId = (int) session.getAttribute("userId");
        // 리더만 접근
        if (loginUserId != group.getLeader()) {
            return "redirect:/group/detail?groupId=" + groupId;
        }

        // 대기 목록 + 승인 목록
        List<UserJoinGroupDTO> pendingList = userJoinGroupService.getPendingRequests(groupId);
        List<UserJoinGroupDTO> approvedMembers = userJoinGroupRepository.findApprovedMembersByGroupId(groupId);

        model.addAttribute("pendingList", pendingList);
        model.addAttribute("approvedMembers", approvedMembers);
        model.addAttribute("groupId", groupId);
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
    public String leaveGroup(@RequestParam int groupId,
                             HttpSession session,
                             RedirectAttributes ra) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            ra.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/login";
        }

        // 리더인지 체크
        if (userJoinGroupService.isLeader(userId, groupId)) {
            ra.addFlashAttribute("error", "모임장은 탈퇴할 수 없습니다. 모임장을 위임한 뒤 탈퇴하세요.");
            return "redirect:/group/detail?groupId=" + groupId; // 이전 상세로 돌려보내기
        }

        userJoinGroupService.leaveGroup(userId, groupId);
        ra.addFlashAttribute("msg", "모임에서 탈퇴했습니다.");
        return "redirect:/group/list";
    }

    // 매니저 권한 부여/해제
    @PostMapping("/manager/grant")
    public String grantManager(@RequestParam("groupId") int groupId,
                               @RequestParam("targetUserId") int targetUserId,
                               HttpSession session) {
        int leaderId = (int) session.getAttribute("userId");
        GroupDTO group = groupService.findById(groupId);

        // 리더만 가능
        if (leaderId != group.getLeader()) {
            return "redirect:/group/detail?groupId=" + groupId;
        }
        // 승인된 멤버에게만 부여
        if (!userJoinGroupRepository.isApprovedMember(targetUserId, groupId)) {
            return "redirect:/groupjoin/requests?groupId=" + groupId;
        }
        // 리더 자신에게는 불필요
        if (targetUserId == group.getLeader()) {
            return "redirect:/groupjoin/requests?groupId=" + groupId;
        }

        userJoinGroupRepository.updateRole(groupId, targetUserId, "manager");
        return "redirect:/groupjoin/requests?groupId=" + groupId;
    }

    @PostMapping("/manager/revoke")
    public String revokeManager(@RequestParam("groupId") int groupId,
                                @RequestParam("targetUserId") int targetUserId,
                                HttpSession session) {
        int leaderId = (int) session.getAttribute("userId");
        GroupDTO group = groupService.findById(groupId);

        if (leaderId != group.getLeader()) {
            return "redirect:/group/detail?groupId=" + groupId;
        }
        // manager -> member로 되돌림
        userJoinGroupRepository.updateRole(groupId, targetUserId, "member");
        return "redirect:/groupjoin/requests?groupId=" + groupId;
    }
}



