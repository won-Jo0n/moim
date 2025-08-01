package com.spring.review.controller;

import com.spring.review.dto.ReviewDTO;
import com.spring.review.service.ReviewSerivce;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/review")
@RequiredArgsConstructor
public class ReviewController {
    private final ReviewSerivce reviewSerivce;

    @GetMapping("/review")
    public String reviewForm(){
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
