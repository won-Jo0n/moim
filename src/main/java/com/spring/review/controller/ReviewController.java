package com.spring.review.controller;

import com.spring.review.dto.ReviewDTO;
import com.spring.review.service.ReviewSerivce;
import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/review")
@RequiredArgsConstructor
public class ReviewController {
    private final ReviewSerivce reviewSerivce;

    @PostMapping("/review")
    public String review(@ModelAttribute ReviewDTO reviewDTO){
        int result = reviewSerivce.createReview(reviewDTO);

        if(result >= 1){
            return "";
        }else{
            return "";
        }

    }

    @GetMapping("/review")
    public String reviewForm(@RequestParam("groupScheduleId") int groupScheduleId,
                             @RequestParam("userId") int userId,
                             HttpSession session,
                             Model model) {
        int reviewer = (int) session.getAttribute("userId");

        model.addAttribute("groupScheduleId", groupScheduleId);
        model.addAttribute("targetList", userId);
        model.addAttribute("reviewer", reviewer);

        return "/review/review";
    }

    @GetMapping("/groupschedule/detail")
    public String scheduleDetail(@RequestParam("groupScheduleId") int groupScheduleId,
                                 HttpSession session,
                                 Model model) {
        int reviewer = (int) session.getAttribute("userId");

        List<UserDTO> targetList = reviewSerivce.findParticipantsExceptReviewer(groupScheduleId, reviewer);

        model.addAttribute("groupScheduleId", groupScheduleId);
        model.addAttribute("targetList", targetList);
        model.addAttribute("reviewer", reviewer);

        return "/groupschedule/detail";
    }

}
