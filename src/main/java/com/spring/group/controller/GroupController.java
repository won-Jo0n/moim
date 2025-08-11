package com.spring.group.controller;

import com.spring.group.dto.GroupDTO;
import com.spring.group.dto.GroupScheduleDTO;
import com.spring.group.service.GroupService;
import com.spring.groupboard.dto.GroupBoardDTO;
import com.spring.groupboard.service.GroupBoardService;
import com.spring.mbti.dto.MbtiDTO;
import com.spring.mbti.service.MbtiService;
import com.spring.page.dto.PageInfoDTO;
import com.spring.schedule.dto.ScheduleDTO;
import com.spring.user.dto.UserDTO;
import com.spring.user.dto.UserScheduleDTO;
import com.spring.user.service.UserService;
import com.spring.userjoingroup.dto.UserJoinGroupDTO;
import com.spring.userjoingroup.repository.UserJoinGroupRepository;
import com.spring.userjoingroup.service.UserJoinGroupService;
import com.spring.utils.FileUtil;
import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/group")
public class GroupController {
    private final GroupService groupService;
    private final UserJoinGroupRepository userJoinGroupRepository;
    private final GroupBoardService groupBoardService;
    private final FileUtil fileUtil;
    private final UserService userService;
    private final MbtiService mbtiService;
    private final UserJoinGroupService userJoinGroupService;

    // 그룹 생성 작성폼
    @GetMapping("/create")
    public String createForm(){
        return "group/create";
    }

    // 그룹 생성
    // userJoinGroup 같이 처리
    @PostMapping("/create")
    public String createGroup(@RequestParam("title") String title,
                              @RequestParam("description") String description,
                              @RequestParam("city") String city,
                              @RequestParam("country") String country,
                              @RequestParam("maxUserNum") int maxUserNum,
                              @RequestParam(value = "groupFile", required = false) MultipartFile file,
                              HttpSession session,
                              Model model) throws IOException {

        int loginUserId = (int) session.getAttribute("userId");
        String location = city + " " + country;

        GroupDTO groupDTO = new GroupDTO();
        groupDTO.setTitle(title);
        groupDTO.setDescription(description);
        groupDTO.setLocation(location);
        groupDTO.setMaxUserNum(maxUserNum);
        groupDTO.setLeader(loginUserId); // 모임장 설정

        if(!file.isEmpty()){
            int fileId = fileUtil.fileSave(file);
            groupDTO.setFileId(fileId);
        }else{
            groupDTO.setFileId(1);
        }

        try {
            groupService.save(groupDTO, loginUserId);
            return "redirect:/group/list";
        } catch (IllegalStateException e) {
            // 안내문 노출 + 사용자가 입력한 값 유지
            model.addAttribute("error", e.getMessage());
            model.addAttribute("group", groupDTO);
            return "group/create";
        }

    }

    // 그룹 목록 보기
    @GetMapping("/list")
    public String groupList(@RequestParam(value = "keyword", required = false) String keyword, Model model,
                            @RequestParam(value = "page", defaultValue = "1") int page,
                            @RequestParam(value="size", defaultValue = "10") int size) {
        Map<String, Object> params = new HashMap<>();
        params.put("limit", size);
        params.put("offset", (page - 1) * size);
        List<GroupDTO> groupList = groupService.searchGroups(keyword);  // 검색어 없으면 전체 리스트 , 있다면 필터링 된 리스트
        List<GroupDTO> pageGroupList = groupService.getPaginationGroups(params);
        long totalGroup = groupList.size();
        int totalPages = (int) Math.ceil((double) totalGroup / size);

        PageInfoDTO pageInfo = new PageInfoDTO();
        pageInfo.setTotalPage(totalPages);
        pageInfo.setCurrentPage(page);
        pageInfo.setPageSize(size);
        pageInfo.setTotalItems(totalGroup);

        model.addAttribute("pageGroupList", pageGroupList);
        model.addAttribute("pageInfo", pageInfo);



        model.addAttribute("groupList", groupList);
        return "group/list";
    }

    // 그룹 상세 보기 // detail.jsp
    @GetMapping("/detail")
    public String detail(@RequestParam("groupId") int groupId,
                         HttpSession session,
                         Model model) {
        GroupDTO group = groupService.findById(groupId); // 모임 정보 가져오기
        model.addAttribute("group", group);

        int loginUserId = (int) session.getAttribute("userId");
        //중복 신청 여부 확인
        UserJoinGroupDTO dto = new UserJoinGroupDTO();
        dto.setUserId(loginUserId);
        dto.setGroupId(groupId);
        UserJoinGroupDTO existing = userJoinGroupRepository.findOne(dto); // 참여 상태 조회
        boolean isAppliedMember = (existing != null && "pending".equals(existing.getStatus()));
        boolean isApprovedMember = (existing != null && "approved".equals(existing.getStatus()));
        boolean isLeader = (loginUserId == group.getLeader());
        boolean isManager = userJoinGroupRepository.isManager(loginUserId, groupId);
        boolean canCreateSchedule = (isLeader || isManager);

        if (isLeader || isApprovedMember) {
            List<GroupBoardDTO> boardList = groupBoardService.findByGroupId(groupId); // 게시글 조회
            model.addAttribute("boardList", boardList);
        }
        List<GroupScheduleDTO> groupScheduleList = groupService.getGroupScheduleByGroupId(groupId);
        Map<Integer, String> groupScheduleStartTime = new HashMap<>();
        Map<Integer, String> groupScheduleEndTime = new HashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm");

        List<UserJoinGroupDTO> approvedMembers = userJoinGroupRepository.findApprovedMembersByGroupId(groupId);
        model.addAttribute("approvedMembers", approvedMembers);
        model.addAttribute("isAppliedMember", isAppliedMember);
        model.addAttribute("isApprovedMember", isApprovedMember);
        model.addAttribute("isLeader", isLeader);
        model.addAttribute("groupScheduleList", groupScheduleList);
        for(GroupScheduleDTO s : groupScheduleList){
            groupScheduleStartTime.put(s.getId(), s.getStartTime().format(formatter));
            groupScheduleEndTime.put(s.getId(), s.getEndTime().format(formatter));
        }
        model.addAttribute("groupScheduleStartTime", groupScheduleStartTime);
        model.addAttribute("groupScheduleEndTime", groupScheduleEndTime);
        model.addAttribute("isManager", isManager);
        model.addAttribute("canCreateSchedule", canCreateSchedule);

        Map<Integer, String> groupScheduleLeader = new HashMap<>();
        for(GroupScheduleDTO g : groupScheduleList){
            UserDTO leader = userService.getUserById(g.getScheduleLeader());
            groupScheduleLeader.put(g.getId(), leader.getNickName());
            if(g.getStartTime().isBefore(LocalDateTime.now())){
                groupService.endRecruit(g.getId());
                g.setStatus(1);
            }
        }
        model.addAttribute("groupScheduleLeaderNickName", groupScheduleLeader);
        return "group/detail";
    }

    // 그룹 수정 작성폼 // update.jsp
    @GetMapping("/update")
    public String updateForm(@RequestParam("id") int id, Model model) {
        GroupDTO group = groupService.findById(id);
        model.addAttribute("group", group);
        return "group/update";
    }


    // 그룹 수정
    @PostMapping("/update")
    public String update(@RequestParam("id") int id,
                         @RequestParam("title") String title,
                         @RequestParam("description") String description,
                         @RequestParam("city") String city,
                         @RequestParam("country") String country,
                         @RequestParam("maxUserNum") int maxUserNum) {
        String location = city + " " + country;
        GroupDTO groupDTO = new GroupDTO(); // 수정할 그룹 정보 세팅
        groupDTO.setId(id);
        groupDTO.setTitle(title);
        groupDTO.setDescription(description);
        groupDTO.setLocation(location);
        groupDTO.setMaxUserNum(maxUserNum);

        groupService.update(groupDTO); // DB 업데이트
        return "redirect:/group/detail?groupId=" + id;
    }

    // 그룹 삭제
    @PostMapping("/delete")
    public String delete(@RequestParam("id") int id, HttpSession session){
        int userId  = (int) session.getAttribute("userId");

        GroupDTO group = groupService.findById(id);  // 그룹 조회

        // 로그인한 유저가 모인장이 아닐때 삭제 차단
        /*if(group.getLeader() != userId){
            return "error/unauthorized";
        }*/

        groupService.delete(id); // 연관 테이블 + 그룹 삭제
        return "redirect:/group/list"; // 수정하기

    }

    // 그룹 일정 생성
    @GetMapping("/createSchedule")
    public String createScheduleForm(@RequestParam("groupId") int groupId,
                                     HttpSession session,
                                     Model model){
        int loginUserId = (int) session.getAttribute("userId");
        GroupDTO group = groupService.findById(groupId);

        boolean isLeader = (group.getLeader() == loginUserId);
        boolean isManager = userJoinGroupRepository.isManager(loginUserId, groupId);

        if (!(isLeader || isManager)) {
            model.addAttribute("error", "일정 생성 권한이 없습니다. (리더/매니저만 가능)");
            return "error/unauthorized"; // 프로젝트에 맞게 에러 페이지 지정
        }

        // 세션 사용자를 스케줄 리더로 고정
        model.addAttribute("scheduleLeader" , loginUserId);
        model.addAttribute("groupId" , groupId);

        int groupMax = group.getMaxUserNum();
        model.addAttribute("groupMaxUserNum", groupMax);

        return "/group/createSchedule";
    }

    @PostMapping("/createSchedule")
    public String createSchedule(@ModelAttribute GroupScheduleDTO groupScheduleDTO,
                                 HttpSession session,
                                 Model model) {

        int loginUserId = (int) session.getAttribute("userId");
        GroupDTO group = groupService.findById(groupScheduleDTO.getGroupId());

        boolean isLeader = (group.getLeader() == loginUserId);
        boolean isManager = userJoinGroupRepository.isManager(loginUserId, group.getId());

        if (!(isLeader || isManager)) {
            model.addAttribute("error", "일정 생성 권한이 없습니다. (리더/매니저만 가능)");
            return "/group/createSchedule";
        }
        groupScheduleDTO.setScheduleLeader(loginUserId);

        // 1. 시작시간은 현재 이후로만 설정 가능
        if (groupScheduleDTO.getStartTime().isBefore(LocalDateTime.now())) {
            model.addAttribute("error", "시작 시간은 현재 시각 이후로만 설정 가능합니다.");
            return "/group/createSchedule";
        }

        // 2. 종료시간 - 시작시간 >= 1시간
        if (java.time.Duration.between(groupScheduleDTO.getStartTime(), groupScheduleDTO.getEndTime()).toMinutes() < 60) {
            model.addAttribute("error", "모임일정은 1시간 이상으로 설정 가능합니다");
            return "/group/createSchedule";
        }

        // 3. 최대인원은 해당 모임의 최대인원 이하만 가능
        int groupMaxUserNum = groupService.findById(groupScheduleDTO.getGroupId()).getMaxUserNum();
        if (groupScheduleDTO.getMaxUserNum() > groupMaxUserNum) {
            model.addAttribute("error", "일정 최대 인원은 모임 최대 인원(" + groupMaxUserNum + "명) 이하로 설정해야 합니다.");
            return "/group/createSchedule";
        }

        // 4. 일정 생성 처리
        groupService.createGroupSchedule(groupScheduleDTO);

        return "redirect:/group/detail?groupId=" + groupScheduleDTO.getGroupId();
    }


    @GetMapping("/groupScheduleDetail")
    public String groupScheduleDetail(@RequestParam("id") int groupScheduleId,
                                      Model model,
                                      HttpSession session){
        GroupScheduleDTO groupScheduleDTO = groupService.getGroupScheduleDetail(groupScheduleId);
        List<UserScheduleDTO> scheduleList = groupService.getScheduleGroupByGroup(groupScheduleId);
        List<ScheduleDTO> scheduleDTOList = new ArrayList<>();

        for(UserScheduleDTO user: scheduleList){
            UserDTO joinUser = userService.getUserById(user.getUserId());
            MbtiDTO mbti = mbtiService.getMbti(joinUser.getMbtiId());

            ScheduleDTO schedule = new ScheduleDTO();
            schedule.setNickName(joinUser.getNickName());
            schedule.setStatus(user.getStatus());
            schedule.setRegion(joinUser.getRegion());
            schedule.setUserId(joinUser.getId());
            schedule.setGroupScheduleId(user.getGroupScheduleId());
            schedule.setRating(joinUser.getRating());
            schedule.setMbti(mbti.getMbti());
            scheduleDTOList.add(schedule);
        }

        UserDTO user = userService.getUserById(groupScheduleDTO.getScheduleLeader());
        int userId = (int)session.getAttribute("userId");

        // 현재 시간이 종료시간 이후인지 체크
        boolean isDone = groupScheduleDTO.getEndTime().isBefore(LocalDateTime.now());
        model.addAttribute("isDone", isDone);

        UserScheduleDTO userScheduleDTO = new UserScheduleDTO();
        userScheduleDTO.setGroupScheduleId(groupScheduleId);
        userScheduleDTO.setUserId(userId);

        if(groupScheduleDTO.getEndTime().isBefore(LocalDateTime.now())){
            model.addAttribute("isDone", true);
        }else{
            model.addAttribute("isDone", false);
        }

        model.addAttribute("groupScheduleDTO", groupScheduleDTO);
        model.addAttribute("leaderNickName", user.getNickName());
        model.addAttribute("scheduleList", scheduleDTOList);

        return "/group/groupScheduleDetail";
    }

    @GetMapping("/scheduleJoin")
    public String groupScheduleJoin(@RequestParam("joinUserId") int joinUser,
                                    @RequestParam("scheduleId") int scheduleId){

        UserScheduleDTO userScheduleDTO = new UserScheduleDTO();
        userScheduleDTO.setUserId(joinUser);
        userScheduleDTO.setGroupScheduleId(scheduleId);

        userService.createUserSchedule(userScheduleDTO);

        return "redirect:/group/groupScheduleDetail?id=" +  userScheduleDTO.getGroupScheduleId();
    }

    @GetMapping("/accept")
    public String accept(@ModelAttribute ScheduleDTO scheduleDTO){
        System.out.println("신청자: "+scheduleDTO.getUserId());
        System.out.println("그룹일정 id: " + scheduleDTO.getGroupScheduleId());

        groupService.acceptSchedule(scheduleDTO);

        return "redirect:/group/groupScheduleDetail?id="+scheduleDTO.getGroupScheduleId();

    }

    @GetMapping("/endRecruit")
    public String endRecruit(@RequestParam("groupScheduleId") int id){
        groupService.endRecruit(id);

        return "redirect:/group/groupScheduleDetail?id="+id;
    }

    @PostMapping("/manager/assign")
    public String assignManager(@RequestParam int groupId,
                                @RequestParam int userId,
                                HttpSession session) {
        int leaderId = (int) session.getAttribute("userId");
        // 리더만 가능 + 대상은 approved 멤버 체크
        userJoinGroupService.grantManager(leaderId, groupId, userId);
        return "redirect:/group/detail?groupId=" + groupId;
    }

    @PostMapping("/manager/revoke")
    public String revokeManager(@RequestParam int groupId,
                                @RequestParam int userId,
                                HttpSession session) {
        int leaderId = (int) session.getAttribute("userId");
        userJoinGroupService.revokeManager(leaderId, groupId, userId);
        return "redirect:/group/detail?groupId=" + groupId;
    }


}
