package com.spring.user.controller;

import com.spring.user.dto.UserDTO;
import com.spring.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

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
        System.out.println(userDTO.getPassword());
        int result = userService.join(userDTO);

        return "redirect:/";
    }

    @PostMapping("/login")
    public String login(@ModelAttribute UserDTO userDTO, HttpSession session){

        UserDTO loginUser = userService.login(userDTO);

        if(loginUser != null){
            session.setAttribute("loginId", loginUser.getLoginId());
            System.out.println("성공");
            return "home";
        }else{
            System.out.println("실패");
            return "index";
        }

    }


}
