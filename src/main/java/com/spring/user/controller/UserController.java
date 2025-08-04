package com.spring.user.controller;

import com.spring.mbti.dto.MbtiDTO;
import com.spring.mbti.service.MbtiService;
import com.spring.oauth.service.OAuthService;
import com.spring.user.dto.UserDTO;
import com.spring.user.service.UserService;
import com.spring.userdetails.CustomerUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;
    private final OAuthService oAuthService;
    private final PasswordEncoder passwordEncoder;
    private final MbtiService mbtiService;

    @GetMapping("/home")
    public String home(){
        return "home";
    }

    @GetMapping("/join")
    public String joinForm(Model model){
        List<MbtiDTO> mbtiList = mbtiService.getMbtiList();
        model.addAttribute("mbtiList", mbtiList);
        return "/user/join";
    }

    @PostMapping("/join")
    public String join(@ModelAttribute UserDTO userDTO,@RequestParam("command") String command,
                       @RequestParam("city") String city, @RequestParam("county") String county){
        String region = city + " " + county;
        userDTO.setRegion(region);
        System.out.println(userDTO.getMbtiId());
        if(command.equals("OAuthJoin")){
            oAuthService.OAuthJoin(userDTO);
        }else{
            String encodedPassword = passwordEncoder.encode(userDTO.getPassword());
            userDTO.setPassword(encodedPassword);

            int result = userService.join(userDTO);
        }

        return "redirect:/";
    }

    @PostMapping("/login")
    public String login(@ModelAttribute UserDTO userDTO, HttpSession session){
        UserDTO loginUser = userService.login(userDTO);
        if(loginUser != null){
            session.setAttribute("userId", loginUser.getId());
            System.out.println("성공");
            return "home";
        }else{
            System.out.println("실패");
            return "index";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session){
        session.invalidate();
        return "redirect:/";
    }

    @GetMapping("/modify")
    public String modifyForm(HttpSession session, Model model){
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomerUserDetails userDetails = (CustomerUserDetails) auth.getPrincipal();
        int userId = userDetails.getUserDTO().getId();
        UserDTO userDTO = userService.getUserById(userId);
        String[] region = userDTO.getRegion().split(" ");
        model.addAttribute("city", region[0]);
        model.addAttribute("county", region[1]);
        model.addAttribute("user", userDTO);

        return "/user/modify";
    }

    @PostMapping("/modify")
    public String modify(@ModelAttribute UserDTO userDTO, @RequestParam("city") String city, @RequestParam("county") String county){
        String region = city + " " + county;
        userDTO.setRegion(region);
        int result = userService.modify(userDTO);

        return "redirect:/home";
    }

    @GetMapping("/delete")
    public String delete(HttpSession session){
        int userId = (int) session.getAttribute("userId");
        userService.delete(userId);

        return "redirect:/";
    }



}
