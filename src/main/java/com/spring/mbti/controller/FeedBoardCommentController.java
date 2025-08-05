package com.spring.mbti.controller;

import com.spring.mbti.dto.FeedBoardCommentDTO;
import com.spring.mbti.service.FeedBoardCommentService;
import com.spring.user.dto.UserDTO;
import com.spring.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequiredArgsConstructor
@RequestMapping("/feed/comment")
public class FeedBoardCommentController {

    private final FeedBoardCommentService commentService;
    private final UserService userService;

    @PostMapping("/save")
    public String save(@ModelAttribute FeedBoardCommentDTO dto,
                       HttpSession session) {
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/login";

        dto.setAuthor(loginUser.getId());
        dto.setMbtiId(loginUser.getMbtiId());
        dto.setStatus(1);

        commentService.save(dto);
        return "redirect:/feed/detail/" + dto.getFeedId();
    }

    @PostMapping("/reply")
    public String reply(@ModelAttribute FeedBoardCommentDTO replyDTO,
                        HttpSession session) {
        return save(replyDTO, session);
    }

    @PostMapping("/update")
    public String update(@ModelAttribute FeedBoardCommentDTO dto) {
        commentService.update(dto);
        return "redirect:/feed/detail/" + dto.getFeedId();
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id,
                         @RequestParam Long feedId) {
        commentService.delete(id);
        return "redirect:/feed/detail/" + feedId;
    }
}
