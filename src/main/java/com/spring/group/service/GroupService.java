package com.spring.group.service;

import com.spring.group.dto.GroupDTO;
import com.spring.group.dto.GroupScheduleDTO;
import com.spring.group.repository.GroupRepository;
import com.spring.notification.dto.NotificationDTO;
import com.spring.notification.service.NotificationService;
import com.spring.schedule.dto.ScheduleDTO;
import com.spring.user.dto.UserScheduleDTO;
import com.spring.userjoingroup.dto.UserJoinGroupDTO;
import com.spring.userjoingroup.repository.UserJoinGroupRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class GroupService {
    private final NotificationService notificationService;
    private final GroupRepository groupRepository;
    private final UserJoinGroupRepository userJoinGroupRepository;

    // 그룹 생성하여 저장
    // userJoinGroup 같이 처리 (모임장 함께 등록)
    @Transactional
    public void save(GroupDTO groupDTO, int loginUserId) {
        // 안전장치: leader 세팅
        groupDTO.setLeader(loginUserId);

        // 1) 사전 검증: 활성 모임이 이미 있으면 차단 (500 대신 안내)
        if (groupRepository.countActiveByLeader(loginUserId) > 0) {
            throw new IllegalStateException("이미 생성한 활성 모임이 있어요. 한 사람당 모임은 1개만 생성할 수 있습니다.");
        }

        // 2) 재활성화 경로: 삭제(status=-1) 이력 있으면 그 행을 '신규처럼' 살린다
        Integer inactiveId = groupRepository.findInactiveGroupIdByLeader(loginUserId);
        if (inactiveId != null) {
            groupRepository.reactivateGroup(
                    inactiveId,
                    groupDTO.getTitle(),
                    groupDTO.getDescription(),
                    groupDTO.getLocation(),
                    groupDTO.getMaxUserNum(),
                    groupDTO.getFileId()
            );

            // userjoingroup 보정
            UserJoinGroupDTO existing = userJoinGroupRepository
                    .findOneByGroupIdAndUserId(inactiveId, loginUserId);

            if (existing == null) {
                UserJoinGroupDTO join = new UserJoinGroupDTO();
                join.setUserId(loginUserId);
                join.setGroupId(inactiveId);
                join.setRole("leader");
                join.setStatus("approved");
                join.setJoinedAt(new java.sql.Timestamp(System.currentTimeMillis()));
                userJoinGroupRepository.insert(join);
            } else {
                if (!"leader".equals(existing.getRole())) {
                    userJoinGroupRepository.updateRole(inactiveId, loginUserId, "leader");
                }
                if (!"approved".equals(existing.getStatus())) {
                    UserJoinGroupDTO fix = new UserJoinGroupDTO();
                    fix.setUserId(loginUserId);
                    fix.setGroupId(inactiveId);
                    fix.setStatus("approved");
                    fix.setJoinedAt(new java.sql.Timestamp(System.currentTimeMillis()));
                    userJoinGroupRepository.updateStatus(fix);
                }
            }
            groupDTO.setId(inactiveId); // 필요시 컨트롤러 리다이렉트용
            return;
        }

        // 3) 신규 INSERT (여기서 단 한 번만)
        groupRepository.save(groupDTO);

        // 4) 리더 조인 insert
        UserJoinGroupDTO join = new UserJoinGroupDTO();
        join.setUserId(loginUserId);
        join.setGroupId(groupDTO.getId());
        join.setRole("leader");
        join.setStatus("approved");
        join.setJoinedAt(new java.sql.Timestamp(System.currentTimeMillis()));
        userJoinGroupRepository.insert(join);
    }

    // 그룹 검색 조회
    public List<GroupDTO> searchGroups(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return groupRepository.findAll();
        }else{
            return groupRepository.searchByKeyword(keyword);
        }
    }

    // 그룹 상세 조회 // 모임장 권한 체크에 필요
    public GroupDTO findById(int id) {
        return groupRepository.findById(id);
    }

    // 그룹 수정
    public boolean update(GroupDTO groupDTO) {
        int isUpdate = groupRepository.update(groupDTO);
        return isUpdate>0;

    }

    // 그룹 삭제
    // userJoinGroup 같이 처리
    public void delete(int id) {
        userJoinGroupRepository.deleteByGroupId(id); // 연관 테이블 먼저 정리
        groupRepository.delete(id); // 이후 삭제
    }



    public void createGroupSchedule(GroupScheduleDTO groupScheduleDTO) {
        System.out.println("groupScheduleDTO: " + groupScheduleDTO);
        groupRepository.createGroupSchedule(groupScheduleDTO);
        //모임 일정 등록하면 모임의 구성원들에게 알림이 가도록 하는 코드
        List<UserJoinGroupDTO> approvedMembers = userJoinGroupRepository.findApprovedMembersByGroupId(groupScheduleDTO.getGroupId());
        for(UserJoinGroupDTO member : approvedMembers){
            System.out.println("member: " + member);
            NotificationDTO notificationDTO = new NotificationDTO();
            notificationDTO.setUserId(member.getUserId());
            notificationDTO.setRequestUserId(groupScheduleDTO.getScheduleLeader());
            notificationDTO.setRelatedId(groupScheduleDTO.getId());
            notificationDTO.setType("NEW_SCHEDULE");
            notificationDTO.setContent(groupScheduleDTO.getTitle());
            notificationDTO.setPath("/group/detail?groupId=" + groupScheduleDTO.getGroupId());
            System.out.println("notificationDTO: " + notificationDTO);
            notificationService.createNotification(notificationDTO);
        }
    }

    public List<GroupScheduleDTO> getGroupScheduleByGroupId(int groupId) {
        return groupRepository.getGroupScheduleByGroupId(groupId);
    }

    public GroupScheduleDTO getGroupScheduleDetail(int groupScheduleId) {
        return groupRepository.getGroupScheduleDetail(groupScheduleId);
    }

    public List<UserScheduleDTO> getScheduleGroupByGroup(int groupScheduleId) {
        return groupRepository.getScheduleGroupByGroup(groupScheduleId);
    }

    public void acceptSchedule(ScheduleDTO scheduleDTO) {
        groupRepository.acceptSchedule(scheduleDTO);
    }

    public void refuseSchedule(ScheduleDTO scheduleDTO) {groupRepository.refuseSchedule(scheduleDTO);}

    public void endRecruit(int id) {
        groupRepository.endRecruit(id);
    }

    public Integer findGroupIdByScheduleId(int groupScheduleId) {
        return groupRepository.findGroupIdByScheduleId(groupScheduleId);
    }


    public List<GroupDTO> getPaginationGroups(Map<String, Object> params) {
        if(params.get("keyword") == null){
            return groupRepository.getPaginationGroups(params);
        }else{
            return groupRepository.searchByPaginationGroups(params);
        }

    }
}
