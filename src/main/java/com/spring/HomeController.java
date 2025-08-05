package com.spring;

import com.spring.user.dto.UserDTO;
import com.spring.userdetails.CustomerUserDetails;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;

@Controller
public class HomeController {
    @GetMapping("/")
    public String index(){
        return "index";
    }

    @GetMapping("/home")
    public String home(Model model, HttpSession session){
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomerUserDetails userDetails = (CustomerUserDetails) auth.getPrincipal();
        UserDTO loginUser = userDetails.getUserDTO();
        session.setAttribute("userId", loginUser.getId());

        if(userDetails == null){
            System.out.println("null");
        }
        model.addAttribute("loginUser", loginUser.getId());
        return "home";
    }



}
