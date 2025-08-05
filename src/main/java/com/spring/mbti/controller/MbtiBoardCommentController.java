package com.spring.mbti.controller;

import com.spring.mbti.dto.MbtiBoardCommentDTO;
import com.spring.mbti.service.MbtiBoardCommentService;
import com.spring.user.dto.UserDTO;
import com.spring.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mbti/board/comment")
public class MbtiBoardCommentController {

    private final MbtiBoardCommentService commentService;
    private final UserService userService;

    // 댓글 작성
    @PostMapping("/save")
    public String save(@ModelAttribute MbtiBoardCommentDTO dto,
                       @RequestParam Long boardId,
                       HttpSession session) {
        int userId = (int) session.getAttribute("userId");
        UserDTO loginUser = userService.getUserById(userId);
        dto.setAuthor(loginUser.getId());
        dto.setBoardId(boardId);
        commentService.save(dto);
        return "redirect:/mbti/board/detail/" + boardId;
    }

    // 댓글 수정
    @PostMapping("/update")
    public String updateComment(@ModelAttribute MbtiBoardCommentDTO dto,
                                HttpSession session) {
        int userId = (int) session.getAttribute("userId");
        MbtiBoardCommentDTO original = commentService.findById(dto.getId());

        if (original == null || original.getAuthor() != userId) {
            return "redirect:/mbti/board/detail/" + dto.getBoardId();
        }

        commentService.update(dto);
        return "redirect:/mbti/board/detail/" + dto.getBoardId();
    }

    // 댓글 삭제
    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Long id,
                         @RequestParam Long boardId,
                         HttpSession session) {
        int userId = (int) session.getAttribute("userId");
        MbtiBoardCommentDTO original = commentService.findById(id);

        if (original == null || original.getAuthor() != userId) {
            return "redirect:/mbti/board/detail/" + boardId;
        }

        commentService.delete(id);
        return "redirect:/mbti/board/detail/" + boardId;
    }
}
