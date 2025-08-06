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
        Object nickNameObj = session.getAttribute("nickName");
        System.out.println("세션 nickName: " + nickNameObj);

        if (nickNameObj == null) {
            System.out.println("세션에 닉네임 없음 → 로그인 필요");
            return "redirect:/login";  // 로그인 페이지로 리디렉트
        }

        String author = nickNameObj.toString();


        groupBoardCommentDTO.setAuthor(author);
        groupBoardCommentService.save(groupBoardCommentDTO);
        return "redirect:/groupboard/detail?id=" + groupBoardCommentDTO.getBoardId();

    }

    // 댓글 삭제
    @PostMapping("/delete")
    public String delete(@RequestParam("id") int id,
                         @RequestParam("boardId") int boardId){
        groupBoardCommentService.delete(id);
        return "redirect:/groupboard/detail?id=" + boardId;
    }




}
