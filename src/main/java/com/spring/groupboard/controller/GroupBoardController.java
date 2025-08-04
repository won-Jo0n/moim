package com.spring.groupboard.controller;

import com.spring.groupboard.dto.GroupBoardDTO;
import com.spring.groupboard.service.GroupBoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/groupboard")
public class GroupBoardController {

    private final GroupBoardService groupBoardService;

    // 모임별 게시글 목록
    @GetMapping("/list")
    public String list(@RequestParam("groupId") int groupId, Model model) {
        List<GroupBoardDTO> boardList = groupBoardService.findByGroupId(groupId);
        model.addAttribute("boardList", boardList);
        model.addAttribute("groupId", groupId);
        return "/groupboard/board";
    }

    // 글 작성 폼
    @GetMapping("/create")
    public String createForm(@RequestParam("groupId") int groupId, Model model) {
        model.addAttribute("groupId", groupId);
        return "/groupboard/create"; // 작성 폼은 추후 만들 예정
    }

    // 글 작성 처리
    @PostMapping("/create")
    public String create(@ModelAttribute GroupBoardDTO dto, HttpSession session) {
        int loginUserId = (int) session.getAttribute("userId");
        dto.setAuthor(loginUserId);
        groupBoardService.save(dto);
        return "redirect:/groupboard/list?groupId=" + dto.getGroupId();
    }

    // 글 삭제
    @PostMapping("/delete")
    public String delete(@RequestParam("id") int id, @RequestParam("groupId") int groupId) {
        groupBoardService.delete(id);
        return "redirect:/groupboard/list?groupId=" + groupId;
    }

    // 글 수정 폼 및 처리도 이후에 추가 가능
}
