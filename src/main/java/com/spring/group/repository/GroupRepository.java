package com.spring.group.repository;

import com.spring.group.dto.GroupDTO;
import com.spring.group.dto.GroupScheduleDTO;
import com.spring.schedule.dto.ScheduleDTO;
import com.spring.user.dto.UserScheduleDTO;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.annotations.Param;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class GroupRepository {
    private final SqlSessionTemplate sql;

    // 그룹 생성하여 저장
    public void save(GroupDTO groupDTO) {
        sql.insert("Group.createGroup",groupDTO);
    }

    // 그룹 전체 조회
    public List<GroupDTO> findAll() {
        return sql.selectList("Group.findAll");
    }

    // 그룹 검색 조회
    public List<GroupDTO> searchByKeyword(@Param("keyword") String keyword) {
        return sql.selectList("Group.searchByKeyword", keyword);
    }

    // 그룹 상세 조회
    public GroupDTO findById(int id) {
        return sql.selectOne("Group.findById", id);
    }

    // 그룹 수정
    public int update(GroupDTO groupDTO) {
        return sql.update("Group.update",groupDTO);
    }

    // 그룹 삭제
    public int delete(int id) {
        return sql.delete("Group.delete",id);
    }

    public Integer findInactiveGroupIdByLeader(int leader) {
        return sql.selectOne("Group.findInactiveGroupIdByLeader", leader);
    }

    public int reactivateGroup(int id, String title, String description,
                               String location, int maxUserNum, Integer fileId) {
        Map<String,Object> p = new HashMap<>();
        p.put("id", id);
        p.put("title", title);
        p.put("description", description);
        p.put("location", location);
        p.put("maxUserNum", maxUserNum);
        p.put("fileId", fileId);
        return sql.update("Group.reactivateGroup", p);
    }

    public int countActiveByLeader(int leader) {
        return sql.selectOne("Group.countActiveByLeader", leader);
    }

    public void createGroupSchedule(GroupScheduleDTO groupScheduleDTO) {
        sql.insert("Group.createGroupSchedule", groupScheduleDTO);
    }

    public List<GroupScheduleDTO> getGroupScheduleByGroupId(int groupId) {
        return sql.selectList("Group.getGroupScheduleByGroupId", groupId);
    }

    public GroupScheduleDTO getGroupScheduleDetail(int groupScheduleId) {
        return sql.selectOne("Group.getGroupScheduleDetail", groupScheduleId);
    }

    public List<UserScheduleDTO> getScheduleGroupByGroup(int groupScheduleId) {
        return sql.selectList("Group.getScheduleGroupByGroup", groupScheduleId);
    }

    public void acceptSchedule(ScheduleDTO scheduleDTO) {
        sql.update("Group.acceptSchedule", scheduleDTO);
    }

    public void endRecruit(int id) {
        sql.update("Group.endRecruit", id);
    }

    public Integer findGroupIdByScheduleId(int groupScheduleId) {
        return sql.selectOne("Group.findGroupIdByScheduleId", groupScheduleId);
    }
}
