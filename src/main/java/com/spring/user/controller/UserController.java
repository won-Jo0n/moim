package com.spring.user.controller;

import com.spring.user.dto.UserDTO;
import com.spring.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

    @GetMapping("/home")
    public String home(){
        return "home";
    }

    @GetMapping("/join")
    public String joinForm(){
        return "/user/join";
    }

    @PostMapping("/join")
    public String join(@ModelAttribute UserDTO userDTO){
        System.out.println(userDTO.getRegion());
        int result = userService.join(userDTO);

        return "redirect:/";

    }

}
