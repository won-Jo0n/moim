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

    // 리뷰 작성 폼
    @GetMapping("/review")
    public String reviewForm(@RequestParam("groupScheduleId") int groupScheduleId,
                             @RequestParam(value = "error", required = false) String error,
                             Model model,
                             HttpSession session){
        Integer reviewerIdObj = (Integer) session.getAttribute("userId");
        if (reviewerIdObj == null) {
            return "redirect:/login";
        }
        int reviewerId = reviewerIdObj;

        List<UserScheduleDTO> scheduleList =  groupService.getScheduleGroupByGroup(groupScheduleId);

        List<UserDTO> joinUser = new ArrayList<>();
        for(UserScheduleDTO u : scheduleList){
            if( u != null && u.getStatus() == 1 && u.getUserId() != reviewerId ){
                UserDTO userDTO = userService.getUserById(u.getUserId());
                joinUser.add(userDTO);
            }
        }
        Integer groupId = groupService.findGroupIdByScheduleId(groupScheduleId);
        model.addAttribute("groupId", groupId);

        model.addAttribute("groupScheduleId", groupScheduleId);
        model.addAttribute("reviewer", reviewerId);
        model.addAttribute("joinUser", joinUser);
        model.addAttribute("error", error);

        return "/review/review";
    }


    // 리뷰 제출 처리
    @PostMapping("/review")
    public String review(@ModelAttribute ReviewDTO reviewDTO,
                         HttpSession session) {

        // 로그인 체크
        Integer reviewerId = (Integer) session.getAttribute("userId");
        if (reviewerId == null) {
            return "redirect:/login";
        }
        reviewDTO.setReviewer(reviewerId); // 서버에서 세팅

        // groupId 서버에서 조회
        Integer groupId = groupService.findGroupIdByScheduleId(reviewDTO.getGroupScheduleId());
        if (groupId == null) {
            return "redirect:/review/review?groupScheduleId=" + reviewDTO.getGroupScheduleId();
        }
        reviewDTO.setGroupId(groupId);

        // 비었으면 다시 폼으로
        if (reviewDTO.getUserId() == 0 || reviewDTO.getScore() == 0) {
            return "redirect:/review/review?groupScheduleId=" + reviewDTO.getGroupScheduleId();
        }

        // 중복 체크
        boolean duplicated = reviewSerivce.existsReview(reviewDTO.getGroupScheduleId(),
                reviewDTO.getReviewer(),
                reviewDTO.getUserId());
        if (duplicated) {
            return "redirect:/review/review?groupScheduleId=" + reviewDTO.getGroupScheduleId() + "&error=duplicate";
        }

        // 저장
        int result = reviewSerivce.createReviewAndUpdateRating(reviewDTO);
        if (result > 0) {
            return "redirect:/group/detail?groupId=" + groupId;
        } else {
            return "redirect:/review/review?groupScheduleId=" + reviewDTO.getGroupScheduleId();
        }
    }


    // 모임 일정 상세 //review 본인 제외한 user 넘기기
    @GetMapping("/group/groupScheduleDetail")
    public String scheduleDetail(@RequestParam("groupScheduleId") int groupScheduleId,
                                 HttpSession session,
                                 Model model) {
        int reviewer = (int) session.getAttribute("userId");

        List<UserDTO> targetList = reviewSerivce.findParticipantsExceptReviewer(groupScheduleId, reviewer);

        model.addAttribute("groupScheduleId", groupScheduleId);
        model.addAttribute("targetList", targetList);
        model.addAttribute("reviewer", reviewer);

        return "/group/groupScheduleDetail";
    }

}
