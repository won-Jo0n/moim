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

    @PostMapping("/edit")
    public String edit(@ModelAttribute MbtiBoardCommentDTO dto,
                       @RequestParam Long boardId) {
        commentService.update(dto);
        return "redirect:/mbti/board/detail/" + boardId;
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Long id,
                         @RequestParam Long boardId) {
        commentService.delete(id);
        return "redirect:/mbti/board/detail" + boardId;
    }
}
