package com.spring.group.controller;

import com.spring.group.dto.GroupDTO;
import com.spring.group.service.GroupService;
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

    // 그룹 생성 작성폼 //create.jsp
    @GetMapping("/create")
    public String createForm(){
        return "/group/create";
    }

    // 그룹 생성
    @PostMapping("/create")
    public String createGroup(@ModelAttribute GroupDTO groupDTO, HttpSession session){

        // 세션에서 로그인 유저 ID 받아와서 leader로 설정
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) {
            return "redirect:/user/login";  // 또는 index.jsp로 이동
        }

        groupService.save(groupDTO);
        return "redirect:/group/list";
    }

    // 그룹 목록 보기 //list.jsp
    @GetMapping("/list")
    public String groupList(Model model){
        List<GroupDTO> groupList = groupService.findAll();
        model.addAttribute("groupList",groupList);
        return "group/list";
    }

    // 그룹 상세 보기 // detail.jsp
    @GetMapping("/detail")
    public String detail(@RequestParam("id") int id, Model model) {
        GroupDTO group = groupService.findById(id);
        model.addAttribute("group", group);
        return "group/detail";  // detail.jsp
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
    public String update(@ModelAttribute GroupDTO groupDTO, HttpSession session){
        Integer loginId = (Integer) session.getAttribute("loginId");
        GroupDTO group = groupService.findById(groupDTO.getId());
        // 사용자가 모임장이 아닐경우 수정 차단
        /*if(group.getLeader() != loginId){
            return "error/unauthorized";
        }*/
        groupService.update(groupDTO);
        return "redirect:/group/detail?id=" + groupDTO.getId();

    }


    // 그룹 삭제
    @GetMapping("/delete")
    public String delete(@RequestParam("id") int id, HttpSession session){
        int loginId  = (int) session.getAttribute("loginId ");
        GroupDTO group = groupService.findById(id);  // 그룹 조회


        // 로그인한 유저가 모인장이 아닐때 삭제 차단
        /*if(group.getLeader() != loginId){
            return "error/unauthorized";
        }*/

        groupService.delete(id);
        return "redirect:/group/list"; // 수정하기

    }

//  로그인 처리 컨트롤러 setAttribute 확인하고 수정하기



}
