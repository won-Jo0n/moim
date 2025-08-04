package com.spring.userjoingroup.service;


import com.spring.userjoingroup.dto.UserJoinGroupDTO;
import com.spring.userjoingroup.repository.UserJoinGroupRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UserJoinGroupService {

    private final UserJoinGroupRepository userJoinGroupRepository;

    // 모임 참여 신청
    public void applyToGroup(int userId, int groupId) {
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
}
