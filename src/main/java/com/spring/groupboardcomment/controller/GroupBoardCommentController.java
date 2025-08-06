package com.spring.groupboardcomment.controller;


import com.spring.groupboardcomment.dto.GroupBoardCommentDTO;
import com.spring.groupboardcomment.service.GroupBoardCommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;


@Controller
@RequiredArgsConstructor
@RequestMapping("/groupboardcomment")
public class GroupBoardCommentController {

    private final GroupBoardCommentService groupBoardCommentService;


    // 댓글 저장
    @PostMapping("/create")
    public String save(@ModelAttribute GroupBoardCommentDTO groupBoardCommentDTO,
                       HttpSession session){
        Integer loginUserId = (Integer) session.getAttribute("userId");

        if(loginUserId == null){
            return "redirect:/user/login";
        }

        // depth 1 초과 댓글 막기 // 댓글-대댓글 1단계까지만 가능
        if (groupBoardCommentDTO.getDepth() > 1) {
            return "redirect:/groupboard/detail?id=" + groupBoardCommentDTO.getBoardId();
        }

        groupBoardCommentDTO.setAuthor(loginUserId);
        groupBoardCommentService.save(groupBoardCommentDTO);

        return "redirect:/groupboard/detail?id=" + groupBoardCommentDTO.getBoardId();
    }

    // 댓글 수정
    @PostMapping("/update")
    public String update(@RequestParam("id") int id,
                         @RequestParam("boardId") int boardId,
                         @RequestParam("content") String content) {
        groupBoardCommentService.update(id, content);
        return "redirect:/groupboard/detail?id=" + boardId;
    }


    // 댓글 삭제
    @PostMapping("/delete")
    public String delete(@RequestParam("id") int id,
                         @RequestParam("boardId") int boardId){
        groupBoardCommentService.delete(id);
        return "redirect:/groupboard/detail?id=" + boardId;
    }




}
