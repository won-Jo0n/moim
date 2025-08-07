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

import java.util.ArrayList;
import java.util.List;

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

}
