package com.spring.review.controller;

import com.spring.group.service.GroupService;
import com.spring.review.dto.ReviewDTO;
import com.spring.review.service.ReviewSerivce;
import com.spring.user.dto.UserDTO;

import com.spring.user.dto.UserScheduleDTO;
import com.spring.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.ArrayList;


@Controller
@RequestMapping("/review")
@RequiredArgsConstructor
public class ReviewController {
    private final ReviewSerivce reviewSerivce;
    private final GroupService groupService;
    private final UserService userService;

    @GetMapping("/review")
    public String reviewForm(@RequestParam int id, Model model){
        List<UserScheduleDTO> scheduleList =  groupService.getScheduleGroupByGroup(id);
        List<UserDTO> joinUser = new ArrayList<>();

        for(UserScheduleDTO u : scheduleList){
            if(u.getStatus() == 1){
                UserDTO userDTO = userService.getUserById(u.getUserId());
                joinUser.add(userDTO);
            }
        }
        model.addAttribute("joinUser", joinUser);

        return "/review/review";
    }

    @PostMapping("/review")
    public String review(@ModelAttribute ReviewDTO reviewDTO){
        int result = reviewSerivce.createReview(reviewDTO);

        if(result >= 1){
            return "";
        }else{
            return "";
        }

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
