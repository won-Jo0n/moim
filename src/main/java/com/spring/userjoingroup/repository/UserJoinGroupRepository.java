package com.spring.userjoingroup.repository;

import com.spring.group.dto.GroupDTO;
import com.spring.userjoingroup.dto.UserJoinGroupDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
//MyBatis Mapper 인터페이스
public interface UserJoinGroupRepository {

    // 그룹 생성 시 leader insert
    void insert(UserJoinGroupDTO dto);

    // 참여 신청 insert
    void insertRequest(UserJoinGroupDTO dto);

    // 중복 신청 방지
    UserJoinGroupDTO findOne(UserJoinGroupDTO dto);

    // 그룹 삭제 시
    void deleteByGroupId(int groupId);

    // 신청 취소
    void deleteByUserAndGroup(UserJoinGroupDTO dto);

    // 대기 신청 목록
    List<UserJoinGroupDTO> findPendingByGroupId(UserJoinGroupDTO dto);

    // 승인/거절 처리
    void updateStatus(UserJoinGroupDTO dto);

    // 그룹 탈퇴
    void leaveGroup(@Param("userId") int userId, @Param("groupId") int groupId);

    // 게시글 목록 조회를 위한
    UserJoinGroupDTO findOneByGroupIdAndUserId(@Param("groupId") int groupId,
                                               @Param("userId") int userId);

    // 승인된 멤버 목록(리더 제외)
    List<UserJoinGroupDTO> findApprovedMembersByGroupId(@Param("groupId") int groupId);

    // manager 여부
    boolean isManager(@Param("userId") int userId, @Param("groupId") int groupId);

    // 승인 멤버 여부
    boolean isApprovedMember(@Param("userId") int userId, @Param("groupId") int groupId);

    // 역할 변경 (member <-> manager)
    int updateRole(@Param("groupId") int groupId,
                   @Param("userId") int userId,
                   @Param("role") String role);

    GroupDTO findById(int groupId);
}
