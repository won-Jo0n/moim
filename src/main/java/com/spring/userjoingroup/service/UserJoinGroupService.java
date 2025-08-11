package com.spring.userjoingroup.service;


import com.spring.group.dto.GroupDTO;
import com.spring.group.service.GroupService;
import com.spring.userjoingroup.dto.UserJoinGroupDTO;
import com.spring.userjoingroup.repository.UserJoinGroupRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UserJoinGroupService {

    private final UserJoinGroupRepository userJoinGroupRepository;
    private final GroupService groupService;

    // 모임 참여 신청
    public void applyToGroup(int userId, int groupId,
                             HttpSession session) {
        UserJoinGroupDTO dto = new UserJoinGroupDTO();
        dto.setUserId(userId);
        dto.setGroupId(groupId);

        // 중복 insert 방지
        UserJoinGroupDTO existing = userJoinGroupRepository.findOne(dto);
        if (existing != null) {
            throw new IllegalStateException("이미 신청한 모임입니다.");
        }

        dto.setStatus("pending");
        dto.setRole("member");
        dto.setJoinedAt(null); // 승인 전이므로 null
        userJoinGroupRepository.insertRequest(dto);
    }

    // 신청 취소
    public void cancelApplication(int userId, int groupId) {
        UserJoinGroupDTO dto = new UserJoinGroupDTO();
        dto.setUserId(userId);
        dto.setGroupId(groupId);
        userJoinGroupRepository.deleteByUserAndGroup(dto);
    }

    // 대기 목록 가져오기
    public List<UserJoinGroupDTO> getPendingRequests(int groupId) {
        UserJoinGroupDTO dto = new UserJoinGroupDTO();
        dto.setGroupId(groupId);
        return userJoinGroupRepository.findPendingByGroupId(dto);
    }

    // 승인 or 거절
    public void updateStatus(int userId, int groupId, String status) {
        UserJoinGroupDTO dto = new UserJoinGroupDTO();

        dto.setUserId(userId);
        dto.setGroupId(groupId);
        dto.setStatus(status);
        if ("approved".equals(status)) {
            dto.setJoinedAt(new Timestamp(System.currentTimeMillis()));
        }
        userJoinGroupRepository.updateStatus(dto);
    }

    // 탈퇴
    public void leaveGroup(int userId, int groupId) {
        userJoinGroupRepository.leaveGroup(userId, groupId);
    }

    // 승인된 멤버만 게시글 목록 조회 가능하도록
    public boolean isApprovedMember(int groupId, int userId) {
        UserJoinGroupDTO dto = userJoinGroupRepository.findOneByGroupIdAndUserId(groupId, userId);
        return dto != null && "approved".equals(dto.getStatus());
    }

    public boolean isLeader(int userId, int groupId) {
        GroupDTO group = userJoinGroupRepository.findById(groupId);
        return group != null && group.getLeader() == userId;
    }

    public boolean isManager(int userId, int groupId) {
        return userJoinGroupRepository.isManager(userId, groupId);
    }

    public boolean canCreateSchedule(int userId, int groupId) {
        return isLeader(userId, groupId) || isManager(userId, groupId);
    }

    // 리더만 매니저 부여/해제 가능
    public void grantManager(int leaderId, int groupId, int targetUserId) {
        if (!isLeader(leaderId, groupId)) {
            throw new IllegalStateException("권한 없음: 리더만 매니저를 지정할 수 있습니다.");
        }
        if (!userJoinGroupRepository.isApprovedMember(targetUserId, groupId)) {
            throw new IllegalStateException("승인된 멤버에게만 매니저를 부여할 수 있습니다.");
        }
        // 리더 자신에게 매니저 부여 방지
        if (groupService.findById(groupId).getLeader() == targetUserId) {
            throw new IllegalStateException("리더는 별도 매니저 지정이 필요 없습니다.");
        }
        userJoinGroupRepository.updateRole(groupId, targetUserId, "manager");
    }

    public void revokeManager(int leaderId, int groupId, int targetUserId) {
        if (!isLeader(leaderId, groupId)) {
            throw new IllegalStateException("권한 없음: 리더만 매니저를 해제할 수 있습니다.");
        }
        userJoinGroupRepository.updateRole(groupId, targetUserId, "member");
    }


}
