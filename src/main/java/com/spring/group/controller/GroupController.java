package com.spring.group.controller;

import com.spring.group.dto.GroupDTO;
import com.spring.group.service.GroupService;
import com.spring.groupboard.dto.GroupBoardDTO;
import com.spring.groupboard.service.GroupBoardService;
import com.spring.userjoingroup.dto.UserJoinGroupDTO;
import com.spring.userjoingroup.repository.UserJoinGroupRepository;
import com.spring.userjoingroup.service.UserJoinGroupService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/group")
public class GroupController {
    private final GroupService groupService;
    private final UserJoinGroupRepository userJoinGroupRepository;
    private final UserJoinGroupService userJoinGroupService;
    private final GroupBoardService groupBoardService;

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
                              HttpSession session){

        int loginUserId = (int) session.getAttribute("userId");
        String location = city + " " + country;

        GroupDTO groupDTO = new GroupDTO();
        groupDTO.setTitle(title);
        groupDTO.setDescription(description);
        groupDTO.setLocation(location);
        groupDTO.setMaxUserNum(maxUserNum);
        groupDTO.setLeader(loginUserId); // 모임장 설정


        groupService.save(groupDTO, loginUserId);
        return "redirect:/group/list";
    }

    // 그룹 목록 보기
    @GetMapping("/list")
    public String groupList(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<GroupDTO> groupList = groupService.searchGroups(keyword);  // 검색어 없으면 전체 리스트 , 있다면 필터링 된 리스트
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

        if (isLeader || isApprovedMember) {
            List<GroupBoardDTO> boardList = groupBoardService.findByGroupId(groupId); // 게시글 조회
            model.addAttribute("boardList", boardList);
        }

        model.addAttribute("isAppliedMember", isAppliedMember);
        model.addAttribute("isApprovedMember", isApprovedMember);
        model.addAttribute("isLeader", isLeader);

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


}
