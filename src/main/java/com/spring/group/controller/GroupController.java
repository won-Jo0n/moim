package com.spring.group.controller;

import com.spring.group.dto.GroupDTO;
import com.spring.group.service.GroupService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequiredArgsConstructor
@RequestMapping("/group")
public class GroupController {
    private final GroupService groupService;

    // 그룹 생성 작성폼
    @GetMapping("/create")
    public String createForm(){
        return "/group/create";
    }

    // 그룹 생성
    @PostMapping("/create")
    public String createGroup(@ModelAttribute GroupDTO groupDTO){
        groupService.createGroup(groupDTO);
        return "redirect:/group/list";
    }


    // 그룹 수정
    // 모임장만 가능
    @PostMapping("/update")
    public String update(@ModelAttribute GroupDTO groupDTO){
        boolean result = groupService.update(groupDTO);
        return "redirect:/";

    }


    // 그룹 삭제 // 모임장만 가능
    @GetMapping("/delete")
    public String findById(@RequestParam("id") int id, HttpSession session){
        int loginId = session.getAttribute()
      groupService.delete(id);
      return "redirect:/"; // 수정하기

    }


    // 모임장이 탈퇴하려고 할시에는 위임 후 가능





}
